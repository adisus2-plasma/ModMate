import 'package:flutter/material.dart';
import 'pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  // 0 = Welcome, 1-4 = Intro
  static const int _totalPages = 5;

  void _goLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _goToWorkoutIntro() {
  _controller.animateToPage(
    1, // ✅ หน้า "แนะนำท่าออกกำลังกาย" (index 1)
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final isWelcome = _index == 0;
    final isLast = _index == _totalPages - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: [
                _WelcomeSlide(
                  onStart: _goToWorkoutIntro,
                  onLogin: _goLogin,
                ),
                const _IntroSlide(
                  title: "แนะนำท่าออกกำลังกาย",
                  description:
                      "ไม่เคยเล่น? กลัวทำท่าไม่ถูก? เราช่วยได้\nแนะนำการเล่นเวทเทรนนิ่งแบบเข้าใจง่าย",
                  imageAsset: "assets/onboarding_2.png",
                ),
                const _IntroSlide(
                  title: "ดูท่าทางได้แบบ 360 องศา",
                  description:
                      "ดูท่าทางจากทุกมุมได้ผ่านคลิปวิดีโอ 3D\nและฟีเจอร์เสริม AR ผ่านกล้องมือถือ\nเหมือนมีคนช่วยสอนอยู่ข้างๆ!",
                  imageAsset: "assets/onboarding_3.png",
                ),
                const _IntroSlide(
                  title: "คำนวณดัชนีมวลกาย (BMI)\nและพลังงานที่ต้องการต่อวัน (TDEE)",
                  description:
                      "เราช่วยคำนวณค่า BMI/BMR เพื่อประเมินสุขภาพ\nและแนะนำปริมาณแคลอรี่ที่เหมาะสมต่อวัน",
                  imageAsset: "assets/onboarding_4.png",
                ),
                _IntroSlide(
                  title: "แปลงค่าปอนด์ (lbs)\nเป็น กิโลกรัม (kg)",
                  description:
                      "อุปกรณ์ในยิมเป็นหน่วยปอนด์?\nไม่เป็นไร เดี๋ยวเราแปลงให้",
                  imageAsset: "assets/onboarding_5.png",
                  // หน้า 5 มีปุ่ม “เข้าสู่ระบบ” ตามภาพรวม UX
                  bottomWidget: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _PrimaryOrangeButton(
                      text: "เข้าสู่ระบบ",
                      onPressed: _goLogin,
                    ),
                  ),
                ),
              ],
            ),

            // ✅ Top controls: Back (หน้า 2-5) + Skip (หน้า 2-5)
            Positioned(
              left: 8,
              top: 8,
              child: AnimatedOpacity(
                opacity: isWelcome ? 0 : 1,
                duration: const Duration(milliseconds: 180),
                child: IgnorePointer(
                  ignoring: isWelcome,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, size: 28),
                    onPressed: () => _controller.previousPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 14,
              top: 16,
              child: AnimatedOpacity(
                opacity: isWelcome ? 0 : 1,
                duration: const Duration(milliseconds: 180),
                child: IgnorePointer(
                  ignoring: isWelcome,
                  child: TextButton(
                    onPressed: _goLogin,
                    child: const Text(
                      "ข้าม",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ✅ Dots indicator (หน้า 2-5 ตามภาพ) — ไม่มีปุ่มถัดไปแล้ว
            if (!isWelcome)
              Positioned(
                left: 0,
                right: 0,
                bottom: isLast ? 34 : 24, // หน้า 5 มีปุ่ม เลยขยับขึ้นนิด
                child: Center(
                  child: _DotsIndicator(
                    currentIndex: _index - 1, // intro 4 หน้า
                    count: 4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------
/// หน้า 1: Welcome (มีสีสัน + ภาพเต็มจอ + ปุ่มส้ม)
/// --------------------------------------
class _WelcomeSlide extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onLogin;

  const _WelcomeSlide({
    required this.onStart,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ Background image เต็มจอจริง
        Positioned.fill(
          child: Image.asset(
            "assets/onboarding_bg_1.png",
            fit: BoxFit.cover,
          ),
        ),

        // ✅ ไล่เฉดจาก “ขาวจางๆ” ด้านล่างขึ้นไป (เหมือนรูปที่ 2)
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000), // โปร่งใสด้านบน
                  Color(0x00000000),
                  Color.fromARGB(255, 255, 255, 255), // ขาวจางช่วงล่าง
                  Color(0xFFFFFFFF), // ขาวเต็มด้านล่าง
                ],
                stops: [0.0, 0.55, 0.78, 1.0],
              ),
            ),
          ),
        ),

        // ✅ Content ยึดด้านล่าง (SafeArea เฉพาะ content)
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false, // สำคัญ: อย่าให้ safearea ดันรูปด้านบน
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "ModMate",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "แอปพลิเคชันที่เหมือนเป็นเพื่อนคอยช่วย\nให้การเริ่มต้นการออกกำลังกายเป็นเรื่องง่ายสำหรับคุณ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ปุ่มส้ม
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: onStart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A1A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "เริ่มกันเลย",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "ถ้ามีบัญชีอยู่แล้ว ",
                        style: TextStyle(color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: onLogin,
                        child: const Text(
                          "เข้าสู่ระบบที่นี่",
                          style: TextStyle(
                            color: Color(0xFFFF7A1A),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


/// --------------------------------------
/// หน้า 2-5: Intro (ขาวคลีน แต่ “มีสีสัน” ผ่าน accent + shadow)
/// --------------------------------------
class _IntroSlide extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final Widget? bottomWidget;

  const _IntroSlide({
    required this.title,
    required this.description,
    required this.imageAsset,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 64, 22, 22),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 22),

          // ✅ Phone mock frame look (ใส่เงาให้ดูมีมิติ)
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 24,
                      offset: Offset(0, 10),
                      color: Color(0x14000000),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF4F4F4),
                      alignment: Alignment.center,
                      child: const Icon(Icons.phone_iphone, size: 60, color: Colors.black26),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.55,
              color: Colors.black54,
            ),
          ),

          if (bottomWidget != null) ...[
            const SizedBox(height: 18),
            bottomWidget!,
          ],

          const SizedBox(height: 64), // เผื่อพื้นที่ dots ด้านล่าง
        ],
      ),
    );
  }
}

/// --------------------------------------
/// ปุ่มส้ม (ตามภาพ)
/// --------------------------------------
class _PrimaryOrangeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _PrimaryOrangeButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7A1A),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

/// --------------------------------------
/// Dots indicator (4 จุด)
/// --------------------------------------
class _DotsIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;

  const _DotsIndicator({
    required this.currentIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: isActive ? 18 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: isActive ? const Color(0xFFFF7A1A) : Colors.black12,
          ),
        );
      }),
    );
  }
}
