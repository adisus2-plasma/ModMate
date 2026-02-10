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
    final p1 = _newPassCtrl.text;
    final p2 = _confirmCtrl.text;

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
    Navigator.pop(context); // กลับไปหน้า login
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
        title: const Text("ลืมรหัสผ่าน"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text("ลืมรหัสผ่าน", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),

            _label("รหัสผ่านใหม่"),
            const SizedBox(height: 6),
            TextField(
              controller: _newPassCtrl,
              obscureText: _obscure1,
              decoration: _inputDecoration(
                hint: "NEW PASSWORD",
                suffix: IconButton(
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                  icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),

            const SizedBox(height: 14),

            _label("ยืนยันรหัสผ่านใหม่"),
            const SizedBox(height: 6),
            TextField(
              controller: _confirmCtrl,
              obscureText: _obscure2,
              decoration: _inputDecoration(
                hint: "CONFIRM NEW PASSWORD",
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
                onPressed: _submit,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "ยืนยัน",
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
