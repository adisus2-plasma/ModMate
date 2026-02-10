import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _register() {
    final u = _usernameCtrl.text.trim();
    final p1 = _passwordCtrl.text;
    final p2 = _confirmCtrl.text;

    if (u.isEmpty || p1.isEmpty || p2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบ")),
      );
      return;
    }
    if (p1 != p2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("รหัสผ่านไม่ตรงกัน")),
      );
      return;
    }

    // TODO: ใส่ logic register จริง
    Navigator.pop(context); // สมัครเสร็จ กลับไปหน้า login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("ลงทะเบียน"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text("ModMate", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            const Text("ลงทะเบียน", style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 26),

            _label("ชื่อผู้ใช้"),
            const SizedBox(height: 6),
            TextField(
              controller: _usernameCtrl,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(hint: "USERNAME"),
            ),

            const SizedBox(height: 14),

            _label("รหัสผ่าน"),
            const SizedBox(height: 6),
            TextField(
              controller: _passwordCtrl,
              obscureText: _obscure1,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                hint: "PASSWORD",
                suffix: IconButton(
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                  icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),

            const SizedBox(height: 14),

            _label("ยืนยันรหัสผ่าน"),
            const SizedBox(height: 6),
            TextField(
              controller: _confirmCtrl,
              obscureText: _obscure2,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _register(),
              decoration: _inputDecoration(
                hint: "CONFIRM PASSWORD",
                suffix: IconButton(
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                  icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: _register,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "ลงทะเบียน",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Text(t, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      );

  InputDecoration _inputDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      suffixIcon: suffix,
    );
  }
}
