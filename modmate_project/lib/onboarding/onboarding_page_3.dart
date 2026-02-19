import 'package:flutter/material.dart';
import 'onboarding_page_template.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageTemplate(
      title: "ดูท่าทางได้แบบ 360 องศา",
      description:
          "ดูท่าทางทุกการขยับได้ทันที คลิปวิดีโอ 3D\nและฟีเจอร์เสริม AR ผ่านกล้องมือถือ\nเหมือนมีคนช่วยสอนอยู่ข้างกาย!",
      imagePath: "assets/onboarding_bg_3.png",
    );
  }
}
