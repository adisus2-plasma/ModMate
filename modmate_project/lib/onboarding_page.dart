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

  // ✅ จำนวนหน้า: 5 (Welcome + 4 intro)
  static const int _totalPages = 5;

  void _goNext() {
    if (_index < _totalPages - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }


  void _skip() {
    _finish();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PreferredSizeWidget _appBarForIntro() {
    // ✅ หน้า intro (หน้า 1-4) มี back + ข้าม แบบ wireframe
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () {
          if (_index > 0) {
            _controller.previousPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: _skip,
          child: const Text("ข้าม"),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWelcome = _index == 0;
    final isIntro = _index >= 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isIntro ? _appBarForIntro() : null,
      body: SafeArea(
        top: !isIntro, // ถ้ามี appbar แล้วไม่ต้อง safearea top ซ้ำ
        child: PageView(
          controller: _controller,
          onPageChanged: (i) => setState(() => _index = i),
          children: const [
            _WelcomeSlide(),
            _IntroSlide(
              title: "แนะนำท่าออกกำลังกาย",
              description:
                  "ไม่เคยเล่น? กลัวทำท่าไม่ถูก? เราช่วยได้\nแนะนำการเล่นเวทเทรนนิ่งแบบเข้าใจง่าย",
            ),
            _IntroSlide(
              title: "ดูท่าทางได้แบบ 360 องศา",
              description:
                  "ดูท่าทางจากทุกมุมได้ผ่านคลิปวิดีโอ 3D\nและฟีเจอร์เสริม AR ผ่านกล้องมือถือ\nเหมือนมีคนช่วยสอนอยู่ข้างๆ!",
            ),
            _IntroSlide(
              title: "คำนวณดัชนีมวลกาย (BMI)\nและพลังงานที่ต้องการต่อวัน (TDEE)",
              description:
                  "เราช่วยคำนวณค่า BMI/BMR เพื่อประเมินสุขภาพ\nและแนะนำปริมาณแคลอรี่ที่เหมาะสมต่อวัน",
            ),
            _IntroSlide(
              title: "แปลงค่าปอนด์ (lbs)\nเป็น กิโลกรัม (kg)",
              description:
                  "อุปกรณ์ในยิมเป็นหน่วยปอนด์?\nไม่เป็นไร เดี๋ยวเราแปลงให้",
            ),
          ],
        ),
      ),

      // ✅ ปุ่ม/indicator ตาม wireframe
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isWelcome) ...[
                const SizedBox(height: 8),
                _PrimaryButton(
                  text: "มาเริ่มกันเลย",
                  onPressed: _goNext,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("ถ้ามีบัญชีอยู่แล้ว "),
                    GestureDetector(
                      onTap: _finish, // TODO: ไปหน้า Login ของจริง
                      child: const Text(
                        "เข้าสู่ระบบที่นี่",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                _PrimaryButton(
                  text: (_index == _totalPages - 1) ? "เริ่มใช้งาน" : "ถัดไป",
                  onPressed: _goNext,
                ),
                const SizedBox(height: 14),
                _DotsIndicator(
                  currentIndex: _index - 1, // ✅ intro มี 4 หน้า ใช้ index 0-3
                  count: 4,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// ----------------------
/// Welcome Slide (หน้าแรกตาม wireframe)
/// ----------------------
class _WelcomeSlide extends StatelessWidget {
  const _WelcomeSlide();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ ภาพ placeholder ใหญ่ (แทนรูปจริง)
                Container(
                  width: double.infinity,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined, size: 44),
                ),
                const SizedBox(height: 28),
                const Text(
                  "ModMate",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                const Text(
                  "แอปพลิเคชันที่เหมือนเป็นเพื่อนคอยช่วย\nให้การเริ่มต้นการออกกำลังกายเป็นเรื่องง่ายสำหรับคุณ",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------------
/// Intro Slide (หน้าแนะนำ 4 หน้า)
/// ----------------------
class _IntroSlide extends StatelessWidget {
  final String title;
  final String description;

  const _IntroSlide({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 18),

          // ✅ กล่องรูป placeholder (ตาม wireframe)
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.image_outlined, size: 44),
          ),

          const SizedBox(height: 18),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// ----------------------
/// Dots Indicator (4 จุด)
/// ----------------------
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
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.black54 : Colors.black12,
          ),
        );
      }),
    );
  }
}

/// ----------------------
/// ปุ่มสไตล์ wireframe
/// ----------------------
class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}

/// ✅ ตัวอย่างปลายทาง (แทน Home/Login จริง)
class PlaceholderHome extends StatelessWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Home / Login ของคุณ")),
    );
  }
}
