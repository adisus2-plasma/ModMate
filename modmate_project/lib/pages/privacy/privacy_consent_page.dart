import 'package:flutter/material.dart';
import 'privacy_policy_page.dart';

class PrivacyConsentPage extends StatefulWidget {
  /// ส่ง callback ไปหน้าถัดไปหลังยอมรับสำเร็จ
  final String username; // เพิ่มตัวแปรรับ username

  const PrivacyConsentPage({super.key, required this.username});

  @override
  State<PrivacyConsentPage> createState() => _PrivacyConsentPageState();
}

class _PrivacyConsentPageState extends State<PrivacyConsentPage> {
  static const Color kAccent = Color(0xFFFF7A1A);
  bool _accepted = false;

  Future<void> _openPolicy() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PrivacyPolicyPage(username: widget.username), // ส่ง username ต่อไปยัง PrivacyPolicyPage
      ),
    );
  }

  void _next() => _accepted ? _openPolicy() : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
          child: Column(
            children: [
              const Spacer(flex: 2),

              const Text(
                "ความยินยอมเรื่องข้อมูลส่วนบุคคล",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "ModMate ให้ความสำคัญกับข้อมูลส่วนบุคคลของคุณ\nโปรดอ่านรายละเอียดเกี่ยวกับ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 6),

              GestureDetector(
                onTap: _openPolicy,
                child: const Text(
                  "เงื่อนไขการใช้งาน\nและนโยบายด้านความเป็นส่วนตัว",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kAccent,
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.underline,
                    height: 1.35,
                  ),
                ),
              ),

              const Spacer(),

              InkWell(
                onTap: () => setState(() => _accepted = !_accepted),
                borderRadius: BorderRadius.circular(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: _accepted ? const Color(0xFF2E7D32) : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: _accepted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.82),
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                          children: const [
                            TextSpan(text: "รับทราบและให้ความยินยอมตาม ModMate\n"),
                            TextSpan(
                              text: "ข้อตกลงเกี่ยวกับเงื่อนไขการใช้งาน\nและนโยบายด้านความเป็นส่วนตัว",
                              style: TextStyle(color: kAccent, decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("ต่อไป", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
