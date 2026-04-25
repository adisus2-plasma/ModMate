import 'package:flutter/material.dart';
import '../services/firestore_auth_service.dart';
import 'assessment/assessment_flow_page.dart';
import 'home_page.dart';
import 'privacy/privacy_consent_page.dart';


class RegisterPage extends StatefulWidget {
  final String username; // สมมติว่าได้มาจากหน้า login หรือเก็บไว้ใน local storage
  const RegisterPage({super.key, required this.username});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;

  static const _accent = Color(0xFFFF7A1A);

  @override
  void initState() {
    super.initState();
    _usernameCtrl.addListener(_refresh);
    _passCtrl.addListener(_refresh);
    _confirmCtrl.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ---- Password strength ----
  PasswordStrength get _strength => _calcStrength(_passCtrl.text);

  PasswordStrength _calcStrength(String p) {
    if (p.isEmpty) return PasswordStrength.none;

    int score = 0;
    if (p.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[a-z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]').hasMatch(p)) score++;

    // แปลงเป็น 0..4 แถบ
    if (score <= 1) return PasswordStrength.weak;
    if (score == 2) return PasswordStrength.fair;
    if (score == 3) return PasswordStrength.good;
    return PasswordStrength.amazing;
  }

  bool get _passwordsMatch =>
      _passCtrl.text.isNotEmpty &&
      _confirmCtrl.text.isNotEmpty &&
      _passCtrl.text == _confirmCtrl.text;

  bool get _canSubmit =>
      _usernameCtrl.text.trim().isNotEmpty &&
      _passwordsMatch &&
      (_strength == PasswordStrength.good || _strength == PasswordStrength.amazing);

  Future<void> _submit() async {
    if (!_canSubmit) return;

    final username = _usernameCtrl.text.trim();
    final password = _passCtrl.text;

    try {
      await FirestoreAuthService.instance.register(
        username: username, password: password
      );

      if (!mounted) return;

      final result = await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PrivacyConsentPage(username: username),
        ),
      );
    // result คือข้อมูลที่กรอก
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage(username: AutofillHints.username)),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("สมัครสำเร็จ กรุณาเข้าสู่ระบบ")),
      );

    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } catch (e) {
      // debug ดู error จริง
      debugPrint("REGISTER ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("สมัครไม่สำเร็จ ลองใหม่อีกครั้ง")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = _strength;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 22),

              // โลโก้
              SizedBox(
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
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "ลงทะเบียน",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
              ),

              const SizedBox(height: 26),

              _label("ตั้งชื่อผู้ใช้"),
              const SizedBox(height: 8),
              _roundedField(
                controller: _usernameCtrl,
                hint: "USERNAME",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline,
              ),

              const SizedBox(height: 18),

              // ในภาพเขียน Confirm Password แต่จริงๆ อันแรกคือ Password
              _label("ตั้งรหัสผ่าน"),
              const SizedBox(height: 8),
              _roundedField(
                controller: _passCtrl,
                hint: "***************",
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePass,
                suffix: IconButton(
                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                  icon: Icon(
                    _obscurePass
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black45,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Strength bars + label
              _StrengthBars(strength: strength),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ความปลอดภัยรหัสผ่าน: ${strength.text}",
                  style: const TextStyle(color: Color.fromARGB(234, 255, 255, 255)),
                ),
              ),

              const SizedBox(height: 18),

              _label("ยืนยันรหัสผ่าน"),
              const SizedBox(height: 8),
              _roundedField(
                controller: _confirmCtrl,
                hint: "***************",
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirm,
                suffix: IconButton(
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black45,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Sign Up button (disabled/enabled แบบภาพ)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    disabledBackgroundColor: const Color.fromARGB(255, 255, 123, 0),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: const Color.fromARGB(255, 255, 255, 255),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("ลงทะเบียน",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // I already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "ถ้ามีบัญชีอยู่แล้ว ",
                    style: TextStyle(color: Color.fromARGB(137, 255, 255, 255)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "เข้าสู่ระบบที่นี่",
                      style: TextStyle(
                        color: _accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- UI ----------
  Widget _label(String t) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        t,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color.fromARGB(221, 255, 255, 255),
        ),
      ),
    );
  }

  Widget _roundedField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        prefixIcon: Icon(prefixIcon, color: Colors.black45),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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

// ---------------- Strength UI ----------------

enum PasswordStrength { none, weak, fair, good, amazing }

extension on PasswordStrength {
  int get bars {
    switch (this) {
      case PasswordStrength.none:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.fair:
        return 2;
      case PasswordStrength.good:
        return 3;
      case PasswordStrength.amazing:
        return 4;
    }
  }

  String get text {
    switch (this) {
      case PasswordStrength.none:
        return "-";
      case PasswordStrength.weak:
        return "ไร้ความปลอดภัย 😞";
      case PasswordStrength.fair:
        return "ใช้ได้ 🙂";
      case PasswordStrength.good:
        return "ดี 👍";
      case PasswordStrength.amazing:
        return "ยอดเยี่ยม! 🤘";
    }
  }

  Color get color {
    switch (this) {
      case PasswordStrength.none:
        return const Color.fromARGB(255, 255, 255, 255);
      case PasswordStrength.weak:
        return const Color(0xFFFF4D4D); // แดง
      case PasswordStrength.fair:
        return const Color(0xFFFFA000); // ส้มเข้ม
      case PasswordStrength.good:
        return const Color(0xFF8BC34A); // เขียวอ่อน
      case PasswordStrength.amazing:
        return const Color(0xFF43A047); // เขียวเข้ม
    }
  }
}

class _StrengthBars extends StatelessWidget {
  final PasswordStrength strength;
  const _StrengthBars({required this.strength});

  @override
  Widget build(BuildContext context) {
    final active = strength.bars;

    return Row(
      children: List.generate(4, (i) {
        final isOn = i < active;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i == 3 ? 0 : 6),
            decoration: BoxDecoration(
              color: isOn ? strength.color : const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        );
      }),
    );
  }
}
