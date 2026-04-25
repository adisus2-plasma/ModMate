import 'package:flutter/material.dart';
import 'package:modmate_project/pages/register_page.dart';
import 'onboarding_page_template.dart';
// import 'register_page.dart'; // อย่าลืม import หน้า register ของคุณนะครับ

class OnboardingPage5 extends StatelessWidget {
  const OnboardingPage5({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: "แปลงค่าปอนด์ (lbs)\nเป็น กิโลกรัม (kg)",
      description: "อุปกรณ์ในยิมมีหน่วยปอนด์ ก็ไม่ใช่ปัญหา\nแปลงค่าได้ทันที",
      imagePath: "assets/onboarding_bg_5.png",
      
      // ✅ เพิ่มปุ่มตรงนี้
      action: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // ไปหน้า Register
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage(username: AutofillHints.username)));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7A12), // สีส้มตามธีมแอป
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            "เริ่มต้นใช้งาน",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}