import 'package:flutter/material.dart';
import 'onboarding_page_template.dart';

class OnboardingPage4 extends StatelessWidget {
  const OnboardingPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageTemplate(
      title: "คำนวณดัชนีมวลกาย (BMI)\nและพลังงานที่ต้องการต่อวัน",
      description:
          "คำนวณดัชนีมวลกาย (BMI)\nและพลังงานที่ต้องการต่อวัน (TDEE)",
      imagePath: "assets/onboarding_bg_4.png",
    );
  }
}