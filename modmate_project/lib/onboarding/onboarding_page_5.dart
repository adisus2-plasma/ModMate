import 'package:flutter/material.dart';
import 'onboarding_page_template.dart';

class OnboardingPage5 extends StatelessWidget {
  const OnboardingPage5({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageTemplate(
      title: "แปลงค่าปอนด์ (lbs)\nเป็น กิโลกรัม (kg)",
      description:
          "อุปกรณ์ในยิมมีหน่วยปอนด์ ก็ไม่ใช่ปัญหา\nแปลงค่าได้ทันที",
      imagePath: "assets/onboarding_bg_5.png",
    );
  }
}