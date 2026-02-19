import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _newPassCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final p1 = _newPassCtrl.text.trim();
    final p2 = _confirmCtrl.text.trim();

    if (p1.isEmpty || p2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอกรหัสผ่านให้ครบ")),
      );
      return;
    }
    if (p1 != p2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("รหัสผ่านไม่ตรงกัน")),
      );
      return;
    }

    // TODO: ใส่ logic reset password จริง
    Navigator.pop(context);
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
            // ✅ รูปดัมเบลมุมล่างขวา (ใส่ asset ตามที่มี)
            Align(
              alignment: Alignment.bottomRight,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    "assets/dumbell_forgot.png", // 👈 เปลี่ยน path ให้ตรงโปรเจกต์
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
                  // ✅ back button แบบในภาพ
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                  ),

                  const SizedBox(height: 18),

                  // ✅ Title ใหญ่
                  const Text(
                    "ลืมรหัสผ่าน",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 60),

                  _label("รหัสผ่านใหม่"),
                  const SizedBox(height: 10),
                  _darkTextField(
                    controller: _newPassCtrl,
                    hint: "NEW PASSWORD",
                    obscureText: _obscure1,
                    onToggle: () => setState(() => _obscure1 = !_obscure1),
                  ),

                  const SizedBox(height: 22),

                  _label("ยืนยันรหัสผ่านใหม่"),
                  const SizedBox(height: 10),
                  _darkTextField(
                    controller: _confirmCtrl,
                    hint: "CONFIRM NEW PASSWORD",
                    obscureText: _obscure2,
                    onToggle: () => setState(() => _obscure2 = !_obscure2),
                  ),

                  const SizedBox(height: 28),

                  // ✅ ปุ่มยืนยันสีส้มโค้งมน
                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "ยืนยัน",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(height: 260), // เว้นพื้นที่ให้รูปด้านล่าง
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

  Widget _darkTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
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

          // ✅ icon ซ้าย (รูปกุญแจ)
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.6)),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

          // ✅ icon ขวา (ตา)
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white.withOpacity(0.35),
            ),
          ),
        ),
      ),
    );
  }
}
