import 'package:flutter/material.dart';

class OnboardingPageTemplate extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Widget? action; // ✅ เพิ่มตัวแปรนี้

  const OnboardingPageTemplate({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.action, // ✅ รับค่าเข้ามา (ใส่หรือไม่ใส่ก็ได้)
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: const Color(0xFF141518),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(22, 20, 22, screenHeight * 0.12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      // ปรับขนาด Font ตามความกว้างหน้าจอเล็กน้อยเพื่อให้ Scale
                      fontSize: screenHeight > 700 ? 28 : 24, 
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: HeroImageCard(imagePath: imagePath),
              ),
              
              // ✅ ถ้ามีการส่ง action มา ให้แสดงผลตรงนี้
              if (action != null) ...[
                const SizedBox(height: 20),
                action!,
              ],
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          // ใช้ BoxDecoration สำหรับเงาและโค้ง
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                blurRadius: 30,
                offset: const Offset(0, 14),
                color: Colors.black.withOpacity(0.35),
              ),
            ],
          ),
          // ใช้ ClipRRect เพื่อให้รูปไม่ล้นขอบโค้ง
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              imagePath,
              // ✅ สำคัญ: BoxFit.contain จะช่วยให้รูป Scale อัตโนมัติในพื้นที่ที่จำกัด
              // โดยที่สัดส่วนรูปภาพไม่เพี้ยน
              fit: BoxFit.contain, 
            ),
          ),
        );
      },
    );
  }
}

