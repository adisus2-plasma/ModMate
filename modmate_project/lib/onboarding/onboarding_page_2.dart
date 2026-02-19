import 'package:flutter/material.dart';
import 'onboarding_page_template.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageTemplate(
      title: "แนะนำท่าออกกำลังกาย",
      description:
          "ไม่เคยเล่น? กลัวทำไม่ถูก? เราช่วยได้\nแนะนำการเล่นเวทเทรนนิ่งแบบเข้าใจง่าย",
      imagePath: "assets/onboarding_bg_2.png",
    );
  }
}
