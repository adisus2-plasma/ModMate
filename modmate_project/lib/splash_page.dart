import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding/onboarding_page_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _goToIntro();
  }

  void _goToIntro() {
    Timer(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6A00), // สีส้ม
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(flex: 2),

              /// โลโก้กลางจอ
              Image.asset(
                "assets/logo.png",
                width: 130,
              ),

              const Spacer(flex: 1),

              /// 📝 ✅ กล่องข้อความอ้างอิงข้อมูลโครงการวิจัย (จัดสไตล์สวยงาม)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15), // เพิ่มมิติกล่องให้จางลงเล็กน้อย
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // หัวข้อโครงการวิจัย (ใช้ความกว้างเต็มสำหรับการจัดพาดหัว)
                    const Text(
                      'โครงการวิจัย',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'การพัฒนาแอปพลิเคชันให้ความรู้เกี่ยวกับการออกกำลังกายในรูปแบบเวทเทรนนิ่งด้วยตนเองโดยใช้ร่วมกับเทคโนโลยีความเป็นจริงเสริม (AR)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white24, height: 1),
                    ),

                    // รายละเอียดอื่น ๆ จัดเรียงแบบตารางให้อ่านง่าย
                    _buildInfoRow('ผู้จัดทำ', 'นางสาวธมิดา พาหูถิตย์'),
                    _buildInfoRow('ที่ปรึกษา', 'ผศ.ดร. ชุดาณัฏฐ์ สุดทองคง'),
                    _buildInfoRow('หลักสูตร', 'ปริญญาเทคโนโลยีบัณฑิต โครงการร่วมบริหารหลักสูตรมีเดียอาตส์และเทคโนโลยีมีเดีย'),
                    _buildInfoRow('สาขาวิชา', 'มีเดียทางการแพทย์และวิทยาศาสตร์'),
                    _buildInfoRow('คณะ', 'สถาปัตยกรรมศาสตร์และการออกแบบ'),
                    _buildInfoRow('มหาวิทยาลัย', 'มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าธนบุรี'),
                    _buildInfoRow('ปีการศึกษา', '2568', isLast: true),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              /// Loading ด้านล่างสุด
              SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.95),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

/// Widget ตัวช่วยในการจัดเรียงข้อความซ้าย-ขวาให้ตรงกันสวยงาม
  Widget _buildInfoRow(String label, String value, {bool isLast = false}) {
    return Padding(
      // 🛠️ แก้ไขบรรทัดนี้: เช็กแค่ตัวแปร isLast โดยตรงเพื่อกำหนดระยะห่างขอบล่าง
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 75, // ล็อกความกว้างฝั่งซ้ายเพื่อให้คอลัมน์ขวาตรงกันทั้งหมด
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}