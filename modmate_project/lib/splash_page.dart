import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_page.dart'; // หรือปลายทางที่คุณต้องการ

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    // TODO: ถ้ามีงานโหลดจริง ใส่ไว้ตรงนี้ได้ (เช่นเช็ค token/config)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ใช้ height เพื่อจัดตำแหน่งให้เหมือนภาพ: โลโก้กลาง / loader ต่ำลงมานิด
            final h = constraints.maxHeight;

            return Stack(
              children: [
                // ✅ โลโก้กลางจอ
                Positioned(
                  top: h * 0.33,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _Logo(),
                  ),
                ),

                // ✅ Loading ring อยู่ช่วงล่างกึ่งกลาง (ประมาณ 70% ของความสูง)
                Positioned(
                  top: h * 0.70,
                  left: 0,
                  right: 0,
                  child: const Center(
                    child: _RingLoader(size: 46, stroke: 6),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ----------------------------
/// โลโก้ (ใช้ asset ถ้ามี)
/// ----------------------------
class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Image.asset(
        'assets/logo.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          // fallback เผื่อยังไม่มีรูป
          return const Icon(Icons.fitness_center, size: 90);
        },
      ),
    );
  }
}

/// ----------------------------
/// Ring Loader (เหมือนรูป: วงแหวนสีอ่อน + ส่วนไฮไลท์สีส้มหมุน)
/// ไม่ใช้สีในธีม? ผมกำหนดตาม mood ในภาพให้เลย
/// ----------------------------
class _RingLoader extends StatefulWidget {
  final double size;
  final double stroke;

  const _RingLoader({
    required this.size,
    required this.stroke,
  });

  @override
  State<_RingLoader> createState() => _RingLoaderState();
}

class _RingLoaderState extends State<_RingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // สีโทนตามภาพ: วงแหวนครีมอ่อน + ส้ม
    const base = Color(0xFFF6E9C8);
    const accent = Color(0xFFFF8A3D);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          return CustomPaint(
            painter: _RingPainter(
              progress: _c.value,
              stroke: widget.stroke,
              baseColor: base,
              accentColor: accent,
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress; // 0..1
  final double stroke;
  final Color baseColor;
  final Color accentColor;

  _RingPainter({
    required this.progress,
    required this.stroke,
    required this.baseColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - stroke / 2;

    final basePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // วงพื้น (เต็มวง)
    canvas.drawCircle(center, radius, basePaint);

    // ส่วนไฮไลท์ (ประมาณ 25% ของวง) หมุนไปตาม progress
    const sweep = 0.25 * 6.283185307179586; // 25% ของ 2π
    final start = (progress * 6.283185307179586) - (sweep / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.stroke != stroke ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.accentColor != accentColor;
  }
}
