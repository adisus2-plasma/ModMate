import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'bmi_bmr_page.dart';
import 'tdee_page.dart';
import '../services/firestore_auth_service.dart';
import 'lbs_kg_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ===== Theme (ตามภาพ) =====
  static const Color kBg = Colors.black;
  static const Color kCard = Color(0xFF23242A);
  static const Color kCardBorder = Color(0xFF3A3B40);
  static const Color kAccent = Color(0xFFFF7A1A);
  static const Color kGreen = Color(0xFF7CFF00);
  static const Color kTextDim = Color(0xFFB7B7B7);

  // ===== Metrics =====
  double? bmi;
  double? bmr;
  double? tdee;

  int _workoutIndex = 0;
  int _tipIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    final metrics = await FirestoreAuthService.instance.getMetrics(widget.username);
    if (!mounted) return;

    setState(() {
      bmi = (metrics?['bmi'] as num?)?.toDouble();
      bmr = (metrics?['bmr'] as num?)?.toDouble();
      tdee = (metrics?['tdee'] as num?)?.toDouble();
    });
  }

  Future<void> _openBmiBmr() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BmiBmrPage(username: widget.username)),
    );

    if (result is Map) {
      setState(() {
        bmi = (result['bmi'] as num?)?.toDouble();
        bmr = (result['bmr'] as num?)?.toDouble();
      });
    }
    await _loadMetrics();
  }

  Future<void> _openTdee() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TdeePage(username: widget.username)),
    );

    if (result is Map) {
      setState(() {
        tdee = (result['tdee'] as num?)?.toDouble();
      });
    }
    await _loadMetrics();
  }

  Future<void> _openLbsToKg() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LbsKgConvertPage()),
    );
  }

  Future<void> _openWorkoutRecommend() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlaceholderPage(title: 'ท่าออกกำลังกายเวทเทรนนิ่ง')),
    );
  }

  // ===== Helpers =====
  String _fmtInt(double? v) => (v == null) ? '-' : v.toStringAsFixed(0);
  String _fmtNum(double? v, {int fraction = 2}) => (v == null) ? '-' : v.toStringAsFixed(fraction);

  _BmiStatus _bmiStatus(double? bmiVal) {
    if (bmiVal == null) return _BmiStatus(text: 'ยังไม่มีข้อมูล', color: Colors.white60);
    if (bmiVal < 18.5) return _BmiStatus(text: 'น้ำหนักต่ำกว่าเกณฑ์', color: const Color.fromARGB(255, 255, 217, 0));
    if (bmiVal < 25.0) return _BmiStatus(text: 'น้ำหนักอยู่ในเกณฑ์ปกติ', color: kGreen);
    if (bmiVal < 30.0) return _BmiStatus(text: 'น้ำหนักเริ่มเกินมาตรฐาน', color: const Color.fromARGB(255, 237, 104, 3));
    return _BmiStatus(text: 'อ้วน', color: Colors.redAccent);
  }


  @override
  Widget build(BuildContext context) {
    final bmiStatus = _bmiStatus(bmi);

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopHero(
                username: widget.username,
                tdee: tdee,
                tdeeText: tdee == null ? null : '${_fmtInt(tdee)} kcal/วัน',
                onAvatarTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfilePage(username: widget.username)),
                  );
                },
              ),

              const SizedBox(height: 14),

              // ===== หมวดหมู่ =====
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "หมวดหมู่",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CategoryIcon(
                      bg: const Color(0xFF5B5D66),
                      icon: Icons.fitness_center,
                      label: "ท่าออกกำลังกาย\nเวทเทรนนิ่ง",
                      onTap: _openWorkoutRecommend,
                    ),
                    _CategoryIcon(
                      bg: const Color(0xFF4A230D),
                      icon: Icons.apple,
                      label: "คำนวณ\nTDEE",
                      onTap: _openTdee,
                    ),
                    _CategoryIcon(
                      bg: const Color(0xFF182453),
                      icon: Icons.stacked_line_chart,
                      label: "คำนวณ\nBMI/BMR",
                      onTap: _openBmiBmr,
                    ),
                    _CategoryIcon(
                      bg: const Color(0xFF1E3C13),
                      icon: Icons.swap_horiz,
                      label: "แปลงหน่วย\nlbs-kg",
                      onTap: _openLbsToKg,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ===== ภาพรวมของคุณ (การ์ดเดียว BMI/BMR) =====
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "ภาพรวมของคุณ",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _SummaryCard(
                  bmi: bmi,
                  bmr: bmr,
                  bmiText: _fmtNum(bmi, fraction: 2),
                  bmrText: '${_fmtInt(bmr)} kcal/day',
                  status: bmiStatus,
                ),
              ),

              const SizedBox(height: 18),

              // ===== ท่าเวทเทรนนิ่งที่แนะนำ =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "ท่าเวทเทรนนิ่งที่แนะนำ",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                    TextButton(
                      onPressed: _openWorkoutRecommend,
                      child: const Text(
                        "ดูทั้งหมด",
                        style: TextStyle(color: kAccent, fontWeight: FontWeight.w800),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 260,
                child: PageView(
                  onPageChanged: (i) => setState(() => _workoutIndex = i),
                  children: const [
                    _WorkoutSlide(
                      imagePath: "assets/workouts/dumbbell_curls.png", // ใส่รูปจริงทีหลัง
                      title: "Dumbbell Curls",
                      subtitle: "ทำม้วนข้อด้วยดัมเบลล์",
                    ),
                    _WorkoutSlide(
                      imagePath: "assets/workouts/bench_press.png",
                      title: "Bench Press",
                      subtitle: "เทมเพลตว่าง",
                    ),
                    _WorkoutSlide(
                      imagePath: "assets/workouts/lat_pulldown.png",
                      title: "Lat Pulldown",
                      subtitle: "เทมเพลตว่าง",
                    ),
                    _WorkoutSlide(
                      imagePath: "assets/workouts/shoulder_press.png",
                      title: "Shoulder Press",
                      subtitle: "เทมเพลตว่าง",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _DotsDark(count: 4, index: _workoutIndex),
              const SizedBox(height: 18),

              // ===== Tips ต่าง ๆ =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Tips ต่าง ๆ",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "ดูทั้งหมด",
                        style: TextStyle(color: kAccent, fontWeight: FontWeight.w800),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 170,
                child: PageView(
                  controller: PageController(viewportFraction: 0.86),
                  onPageChanged: (i) => setState(() => _tipIndex = i),
                  children: const [
                    _TipCard(
                      imagePath: "assets/tips/tip1.png",
                      tag: "Nutrition tips",
                      title: "การใช้สายตา\nคำนวณปริมาณโปรตีนให้เข้าใจ",
                      brand: "ModMate",
                    ),
                    _TipCard(
                      imagePath: "assets/tips/tip2.png",
                      tag: "Nutrition tips",
                      title: "เลือกโปรตีน\nแทนมื้อว่าง",
                      brand: "ModMate",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _DotsDark(count: 2, index: _tipIndex),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== TOP HERO (ตามภาพ) =====================

class _TopHero extends StatelessWidget {
  final String username;
  final double? tdee;
  final String? tdeeText;
  final VoidCallback onAvatarTap;

  const _TopHero({
    required this.username,
    required this.tdee,
    required this.tdeeText,
    required this.onAvatarTap,
  });

  static const Color kHeader = Color(0xFF2A2B30);
  static const Color kAccent = Color(0xFFFF7A1A);
  static const Color kGreen = Color(0xFF7CFF00);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: kHeader,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onAvatarTap,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kAccent, width: 2),
              ),
              child: const Icon(Icons.person_outline, color: Color.fromARGB(255, 255, 255, 255), size: 50),
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 2),
                Text(
                  "สวัสดี $username",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ✅ โลโก้เล็ก ๆ
                    // Image.asset(
                    //   "assets/logo.png",
                    //   width: 46,
                    //   height: 28,
                    //   fit: BoxFit.contain,
                    //   errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, color: Colors.white70),
                    // ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
                          children: [
                            const TextSpan(text: "พลังงานที่เหมาะสมกับคุณในวันนี้\n(TDEE) "),
                            TextSpan(
                              text: tdeeText ?? "-",
                              style: const TextStyle(color: kGreen, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== CATEGORY ICONS =====================

class _CategoryIcon extends StatelessWidget {
  final Color bg;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryIcon({
    required this.bg,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 78,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFEDEDED)),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== SUMMARY CARD (BMI+BMR รวม) =====================

class _SummaryCard extends StatelessWidget {
  final double? bmi;
  final double? bmr;
  final String bmiText;
  final String bmrText;
  final _BmiStatus status;

  const _SummaryCard({
    required this.bmi,
    required this.bmr,
    required this.bmiText,
    required this.bmrText,
    required this.status,
  });

  static const Color kCard = Color(0xFF23242A);
  static const Color kBorder = Color(0xFF3A3B40);
  static const Color kGreen = Color(0xFF7CFF00);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ค่าดัชนีมวลกาย (BMI)",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A1A).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.monitor_weight_outlined, color: Color(0xFFFF7A1A), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                bmiText,
                style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            status.text,
            style: TextStyle(color: status.color == Colors.white60 ? kGreen : status.color, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: Colors.white.withOpacity(0.12)),
          const SizedBox(height: 14),
          const Text(
            "พลังงานที่ต้องการต่อวัน (BMR)",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 182, 76, 76).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_fire_department_outlined, color: Color.fromARGB(255, 255, 5, 5), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                bmrText,
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===================== WORKOUT SLIDE =====================

class _WorkoutSlide extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const _WorkoutSlide({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  static const Color kCard = Color(0xFF16171B);
  static const Color kBorder = Color(0xFF2A2B30);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: kCard,
                child: const Center(
                  child: Icon(Icons.image_outlined, color: Colors.white24, size: 46),
                ),
              ),
            ),
            // overlay ดำไล่ระดับ
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.black.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== TIP CARD =====================

class _TipCard extends StatelessWidget {
  final String imagePath;
  final String tag;
  final String title;
  final String brand;

  const _TipCard({
    required this.imagePath,
    required this.tag,
    required this.title,
    required this.brand,
  });

  static const Color kBorder = Color(0xFF2A2B30);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1A1B20),
                  child: const Center(
                    child: Icon(Icons.image_outlined, color: Colors.white24, size: 46),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.85),
                      Colors.black.withOpacity(0.10),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tag, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, height: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo_small.png",
                        width: 24,
                        height: 18,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, color: Colors.white70, size: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(brand, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ===================== DOTS =====================

class _DotsDark extends StatelessWidget {
  final int count;
  final int index;

  const _DotsDark({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.white : Colors.white24,
          ),
        );
      }),
    );
  }
}

// ===================== Helpers / Placeholder =====================

class _BmiStatus {
  final String text;
  final Color color;
  _BmiStatus({required this.text, required this.color});
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFF7A1A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Template ว่างไว้ก่อน',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
