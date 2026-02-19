import 'package:flutter/material.dart';
import '../services/firestore_auth_service.dart';
import 'forgotPass_page.dart';
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  final String? username; // สมมติว่าได้มาจากหน้า register หรือเก็บไว้ใน local storage
  const LoginPage({super.key, required this.username});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool _keepSignedIn = true;

  static const _accent = Color(0xFFFF7A1A);

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = _usernameCtrl.text.trim();
    final pass = _passwordCtrl.text;

    if (username.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอก Username และ Password")),
      );
      return;
    }

    try {
      final ok = await FirestoreAuthService.instance.login(
        username: username,
        password: pass,
      );

      if (!mounted) return;

      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username หรือ Password ไม่ถูกต้อง")),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(username: username)),
      );
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เข้าสู่ระบบไม่สำเร็จ ลองใหม่อีกครั้ง")),
      );
    }
  }

  void _goForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
    );
  }

  void _goRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage(username: AutofillHints.username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
          child: Column(
            children: [
              const SizedBox(height: 26),

              Container(
                width: 80,
                height: 80,
                child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  // fallback เผื่อยังไม่มีรูป
                  return const Icon(Icons.fitness_center, size: 90);
                  },
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "ModMate",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                "เข้าสู่ระบบ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),

              const SizedBox(height: 26),

              _label("ชื่อผู้ใช้"),
              const SizedBox(height: 8),
              _roundedField(
                controller: _usernameCtrl,
                hint: "USERNAME",
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: 18),

              _label("รหัสผ่าน"),
              const SizedBox(height: 8),
              _roundedField(
                controller: _passwordCtrl,
                hint: "****************",
                prefixIcon: Icons.lock_outline,
                obscureText: _obscure,
                suffix: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _keepSignedIn = !_keepSignedIn),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _keepSignedIn ? _accent : const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: _keepSignedIn ? _accent : const Color.fromARGB(66, 255, 255, 255),
                            ),
                          ),
                          child: _keepSignedIn
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "เข้าสู่ระบบไว้ต่อไป",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _goForgotPassword,
                    child: const Text(
                      "ลืมรหัสผ่าน?",
                      style: TextStyle(
                        color: _accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("เข้าสู่ระบบ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 26),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("ยังไม่มีบัญชีใช่ไหม? ",
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                  GestureDetector(
                    onTap: _goRegister,
                    child: const Text(
                      "ลงทะเบียนที่นี่",
                      style: TextStyle(
                        color: _accent,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          t,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      );

  Widget _roundedField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 208, 208, 208)),
        prefixIcon: Icon(prefixIcon, color: const Color.fromARGB(255, 0, 0, 0)),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _accent, width: 1.2),
        ),
      ),
    );
  }
}
