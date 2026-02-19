import 'package:flutter/material.dart';

import 'onboarding_page_1.dart';
import 'onboarding_page_2.dart';
import 'onboarding_page_3.dart';
import 'onboarding_page_4.dart';
import 'onboarding_page_5.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  /// ✅ ให้หน้าอื่นเรียกใช้ state ได้ง่าย โดยไม่ต้องใช้ GlobalKey
  static OnboardingScreenState of(BuildContext context) {
    final state = context.findAncestorStateOfType<OnboardingScreenState>();
    assert(state != null, "OnboardingScreenState not found in widget tree");
    return state!;
  }

  @override
  State<OnboardingScreen> createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  static const int _totalPages = 5;

  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ✅ ให้หน้า 1 กดปุ่มแล้วไปหน้า 2 (หรือหน้าอื่น)
  void goToPage(int page) {
    if (page < 0 || page >= _totalPages) return;
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _next() => goToPage(_index + 1);
  void _prev() => goToPage(_index - 1);

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF121212);
    const accent = Color(0xFFFF6A00);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: const [
                OnboardingPage1(),
                OnboardingPage2(),
                OnboardingPage3(),
                OnboardingPage4(),
                OnboardingPage5(),
              ],
            ),

            /// ✅ ซ่อน dot + ลูกศร เฉพาะหน้าแรก (index 0)
            if (_index != 0)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CircleNavButton(
                        icon: Icons.chevron_left,
                        onTap: _index == 0 ? null : _prev,
                        accent: accent,
                      ),
                      const SizedBox(width: 18),

                      _DotsIndicator(
                        count: _totalPages,
                        index: _index,
                        activeColor: Colors.white.withOpacity(0.85),
                        inactiveColor: Colors.white.withOpacity(0.25),
                      ),

                      const SizedBox(width: 18),
                      _CircleNavButton(
                        icon: Icons.chevron_right,
                        onTap: _index == _totalPages - 1 ? null : _next,
                        accent: accent,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CircleNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color accent;

  const _CircleNavButton({
    required this.icon,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1 : 0.35,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: accent, size: 30),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  const _DotsIndicator({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 14 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
