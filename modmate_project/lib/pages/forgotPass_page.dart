import 'package:flutter/material.dart';
import '../services/firestore_auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _usernameCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _isLoading = false;

  // Step 1 = กรอก username, Step 2 = กรอกรหัสผ่านใหม่
  int _step = 1;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkUsername() async {
    final username = _usernameCtrl.text.trim();
    if (username.isEmpty) {
      _showSnack("กรุณากรอก Username");
      return;
    }

    setState(() => _isLoading = true);
    try {
      final exists = await FirestoreAuthService.instance.isUsernameExists(username);
      if (exists) {
        setState(() => _step = 2);
      } else {
        _showSnack("ไม่พบ Username นี้ในระบบ");
      }
    } catch (e) {
      _showSnack("เกิดข้อผิดพลาด: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final p1 = _newPassCtrl.text.trim();
    final p2 = _confirmCtrl.text.trim();

    if (p1.isEmpty || p2.isEmpty) {
      _showSnack("กรุณากรอกรหัสผ่านให้ครบ");
      return;
    }
    if (p1 != p2) {
      _showSnack("รหัสผ่านไม่ตรงกัน");
      return;
    }
    if (p1.length < 6) {
      _showSnack("รหัสผ่านต้องมีอย่างน้อย 6 ตัว");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirestoreAuthService.instance.resetPassword(
        username: _usernameCtrl.text.trim(),
        newPassword: p1,
      );
      _showSnack("เปลี่ยนรหัสผ่านสำเร็จ!");
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnack("เกิดข้อผิดพลาด: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF141518);
    const accent = Color(0xFFFF6A00);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    "assets/dumbell_forgot.png",
                    width: 240,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      if (_step == 2) {
                        setState(() => _step = 1);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "ลืมรหัสผ่าน",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _step == 1
                        ? "กรอก Username เพื่อค้นหาบัญชี"
                        : "กรอกรหัสผ่านใหม่สำหรับ @${_usernameCtrl.text.trim()}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Step 1: กรอก Username
                  if (_step == 1) ...[
                    _label("Username"),
                    const SizedBox(height: 10),
                    _darkTextField(
                      controller: _usernameCtrl,
                      hint: "USERNAME",
                      obscureText: false,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 28),
                    _submitButton(
                      label: "ค้นหาบัญชี",
                      onPressed: _checkUsername,
                      accent: accent,
                    ),
                  ],

                  // Step 2: กรอกรหัสผ่านใหม่
                  if (_step == 2) ...[
                    _label("รหัสผ่านใหม่"),
                    const SizedBox(height: 10),
                    _darkTextField(
                      controller: _newPassCtrl,
                      hint: "NEW PASSWORD",
                      obscureText: _obscure1,
                      icon: Icons.lock_outline,
                      onToggle: () => setState(() => _obscure1 = !_obscure1),
                    ),
                    const SizedBox(height: 22),
                    _label("ยืนยันรหัสผ่านใหม่"),
                    const SizedBox(height: 10),
                    _darkTextField(
                      controller: _confirmCtrl,
                      hint: "CONFIRM NEW PASSWORD",
                      obscureText: _obscure2,
                      icon: Icons.lock_outline,
                      onToggle: () => setState(() => _obscure2 = !_obscure2),
                    ),
                    const SizedBox(height: 28),
                    _submitButton(
                      label: "ยืนยันเปลี่ยนรหัสผ่าน",
                      onPressed: _resetPassword,
                      accent: accent,
                    ),
                  ],

                  const SizedBox(height: 260),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Text(
        t,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      );

  Widget _submitButton({
    required String label,
    required VoidCallback onPressed,
    required Color accent,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                label,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
      ),
    );
  }

  Widget _darkTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required IconData icon,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.25),
            letterSpacing: 1.0,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: Icon(icon, color: Colors.white.withOpacity(0.6)),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: onToggle != null
              ? IconButton(
                  onPressed: onToggle,
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white.withOpacity(0.35),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}