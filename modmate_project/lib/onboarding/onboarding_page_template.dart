import 'package:flutter/material.dart';

class OnboardingPageTemplate extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPageTemplate({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // สีพื้นหลังใกล้เคียงภาพ
      color: const Color(0xFF141518),
      child: SafeArea(
        child: Padding(
          // เว้นล่างไว้สำหรับแถบ dot + ลูกศรใน onboarding_screen
          padding: const EdgeInsets.fromLTRB(22, 34, 22, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Title ชิดซ้าย
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 18),

              // ✅ Description จัดกลาง (เหมือนภาพ)
              Align(
                alignment: Alignment.center,
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.55,
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // ✅ การ์ดรูปอยู่กลางจอ
              Expanded(
                child: Center(
                  child: HeroImageCard(imagePath: imagePath),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroImageCard extends StatelessWidget {
  final String imagePath;

  const HeroImageCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ⭐ เต็มความกว้าง

      margin: const EdgeInsets.symmetric(horizontal: 4),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),

        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: const Offset(0, 14),
            color: Colors.black.withOpacity(0.35),
          ),
        ],

        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.contain,
        ),
      ),

      /// ⭐ เพิ่มความสูง
      child: const AspectRatio(
        aspectRatio: 3 / 5, // 🔥 ใหญ่ขึ้นจาก 9/16
      ),
    );
  }
}

