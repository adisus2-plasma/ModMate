import 'package:flutter/material.dart';
import 'package:modmate_project/pages/tips/tip_detail_page.dart';
import 'profile_page.dart';
import 'bmi_bmr_page.dart';
import 'tdee_page.dart';
import '../services/firestore_auth_service.dart';
import 'lbs_kg_page.dart';
import '../pages/tips/tip_page.dart';
import '../pages/tips/tip_data.dart';
import '../pages/workoutPages/body_part_selection_page.dart';
import '../pages/workoutPages/exercise_list_page.dart';
import '../pages/workoutPages/exercise_action_page.dart';
import 'custom_scrollbar.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ===== 1. Controller Management =====
  // ✅ ย้ายมาประกาศที่นี่ เพื่อให้ Scrollbar เกาะติดกับ Controller ตลอดเวลา
  final ScrollController _scrollController = ScrollController();

  // ===== Theme =====
  static const Color kBg = Colors.black;
  static const Color kAccent = Color(0xFFFF7A1A);
  static const Color kGreen = Color(0xFF7CFF00);

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

  @override
  void dispose() {
    // ✅ ล้างหน่วยความจำเมื่อปิดหน้า
    _scrollController.dispose();
    super.dispose();
  }

  // ===== Logic Methods =====
  Future<void> _loadMetrics() async {
    final metrics = await FirestoreAuthService.instance.getMetrics(widget.username);
    if (!mounted) return;
    setState(() {
      bmi = (metrics?['bmi'] as num?)?.toDouble();
      bmr = (metrics?['bmr'] as num?)?.toDouble();
      tdee = (metrics?['tdee'] as num?)?.toDouble();
    });
  }

  void _goToExercise(BuildContext context, String exerciseId) {
    final allExercises = ExerciseListPage(bodyPartLabel: '', bodyPartKey: '').allExercises;
    final exercise = allExercises.firstWhere((e) => e.id == exerciseId, orElse: () => allExercises.first);
    Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseActionPage(exercise: exercise)));
  }

  // ===== Navigation Methods =====
  Future<void> _openBmiBmr() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => BmiBmrPage(username: widget.username)));
    await _loadMetrics();
  }

  Future<void> _openTdee() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => TdeePage(username: widget.username)));
    await _loadMetrics();
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
    final top3Tips = kTips.take(3).toList();

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        // ✅ 2. หุ้มด้วย CustomScrollbar โดยส่ง Controller ตัวเดียวกันเข้าไป
        child: CustomScrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController, // ✅ เชื่อมต่อ Controller กับ View
            padding: const EdgeInsets.only(bottom: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopHero(
                  username: widget.username,
                  tdee: tdee,
                  tdeeText: tdee == null ? null : '${_fmtInt(tdee)} kcal/วัน',
                  onAvatarTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(username: widget.username)));
                  },
                ),
                const SizedBox(height: 14),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text("หมวดหมู่", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 12),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CategoryIcon(bg: const Color(0xFF5B5D66), icon: Icons.fitness_center, label: "ท่าออกกำลังกาย\nเวทเทรนนิ่ง", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BodyPartSelectionPage()))),
                      _CategoryIcon(bg: const Color(0xFF4A230D), icon: Icons.apple, label: "คำนวณ\nTDEE", onTap: _openTdee),
                      _CategoryIcon(bg: const Color(0xFF182453), icon: Icons.stacked_line_chart, label: "คำนวณ\nBMI/BMR", onTap: _openBmiBmr),
                      _CategoryIcon(bg: const Color(0xFF1E3C13), icon: Icons.swap_horiz, label: "แปลงหน่วย\nlbs-kg", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LbsKgConvertPage()))),
                    ],
                  ),
                ),
                
                const SizedBox(height: 18),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text("ภาพรวมของคุณ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 12),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _SummaryCard(bmi: bmi, bmr: bmr, bmiText: _fmtNum(bmi), bmrText: '${_fmtInt(bmr)} kcal/day', status: bmiStatus),
                ),
                
                const SizedBox(height: 18),
                _SectionTitle(title: "ท่าเวทเทรนนิ่งที่แนะนำ", onSeeAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BodyPartSelectionPage()))),
                
                const SizedBox(height: 10),
                SizedBox(
                  height: 260,
                  child: PageView(
                    onPageChanged: (i) => setState(() => _workoutIndex = i),
                    children: [
                      _WorkoutSlide(onTap: () => _goToExercise(context, 'arm_1'), imagePath: "assets/workout_img/arm/arm_1.png", title: "Dumbbell Curl", subtitle: "ทำม้วนข้อด้วยดัมเบลล์"),
                      _WorkoutSlide(onTap: () => _goToExercise(context, 'chest_1'), imagePath: "assets/workout_img/chest/chest_1.png", title: "Dumbbell Bench Presses", subtitle: "ท่านอนยกดัมเบลล์"),
                      _WorkoutSlide(onTap: () => _goToExercise(context, 'back_2'), imagePath: "assets/workout_img/back/back_2.png", title: "Lat Pull-downs", subtitle: "ท่าดึงลงด้านหน้าแบบกางแขน"),
                      _WorkoutSlide(onTap: () => _goToExercise(context, 'shoulder_1'), imagePath: "assets/workout_img/shoulder/shoulder_1.png", title: "Dumbbell Shoulder Press", subtitle: "ท่านนั่งยกดัมเบลล์"),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _DotsDark(count: 4, index: _workoutIndex),
                
                const SizedBox(height: 18),
                _SectionTitle(title: "Tips ต่าง ๆ", onSeeAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TipsPage()))),
                
                const SizedBox(height: 10),
                SizedBox(
                  height: 280,
                  child: PageView(
                    controller: PageController(viewportFraction: 0.86),
                    onPageChanged: (i) => setState(() => _tipIndex = i),
                    children: top3Tips.map((t) => _TipCard(
                      imagePath: t.imagePath,
                      tag: t.tag,
                      title: t.title,
                      brand: "ModMate",
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TipDetailPage(item: t))),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                _DotsDark(count: top3Tips.length, index: _tipIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== COMPONENTS =====================

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionTitle({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800))),
          TextButton(onPressed: onSeeAll, child: const Text("ดูทั้งหมด", style: TextStyle(color: Color(0xFFFF7A1A), fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}

class _TopHero extends StatelessWidget {
  final String username;
  final double? tdee;
  final String? tdeeText;
  final VoidCallback onAvatarTap;

  const _TopHero({required this.username, required this.tdee, required this.tdeeText, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF2A2B30), borderRadius: BorderRadius.vertical(bottom: Radius.circular(40))),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.orange.shade100,
                  child: ClipOval(child: Image.asset("assets/avatar_placeholder.png", errorBuilder: (_, _, _) => const Icon(Icons.person, color: Colors.orange))),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text("สวัสดี $username", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png", width: 60, height: 40, errorBuilder: (_, _, _) => const Icon(Icons.fitness_center, color: Colors.white, size: 40)),
              const SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("พลังงานที่เหมาะสมกับคุณในวันนี้", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    RichText(text: TextSpan(style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), children: [
                      const TextSpan(text: "(TDEE) ", style: TextStyle(color: Colors.white)),
                      TextSpan(text: tdeeText ?? "คำนวณเลย", style: const TextStyle(color: Color(0xFF7CFF00))),
                    ])),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final Color bg;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _CategoryIcon({required this.bg, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 78,
        child: Column(
          children: [
            Container(width: 52, height: 52, decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: const Color(0xFFEDEDED))),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, height: 1.2)),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double? bmi, bmr;
  final String bmiText, bmrText;
  final _BmiStatus status;
  const _SummaryCard({required this.bmi, required this.bmr, required this.bmiText, required this.bmrText, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF23242A), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF3A3B40))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ค่าดัชนีมวลกาย (BMI)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.monitor_weight_outlined, color: Color(0xFFFF7A1A), size: 26),
            const SizedBox(width: 10),
            Text(bmiText, style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900)),
          ]),
          Text(status.text, style: TextStyle(color: status.color, fontWeight: FontWeight.w900)),
          const Divider(color: Colors.white12, height: 28),
          const Text("พลังงานที่ต้องการต่อวัน (BMR)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.local_fire_department_outlined, color: Colors.redAccent, size: 26),
            const SizedBox(width: 10),
            Text(bmrText, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
          ]),
        ],
      ),
    );
  }
}

class _WorkoutSlide extends StatelessWidget {
  final String imagePath, title, subtitle;
  final VoidCallback? onTap;
  const _WorkoutSlide({required this.imagePath, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: Colors.white10)),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.center, colors: [Colors.black.withOpacity(0.8), Colors.transparent]))),
              Positioned(left: 16, bottom: 16, right: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
              ])),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String imagePath, tag, title, brand;
  final VoidCallback onTap;
  const _TipCard({required this.imagePath, required this.tag, required this.title, required this.brand, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(22)),
          child: Column(
            children: [
              Expanded(flex: 5, child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(22)), child: Image.asset(imagePath, width: double.infinity, fit: BoxFit.cover))),
              Expanded(flex: 4, child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(tag, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ]),
                  Row(children: [
                    const Icon(Icons.fitness_center, size: 16, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(brand, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ]),
                ]),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _DotsDark extends StatelessWidget {
  final int count, index;
  const _DotsDark({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(count, (i) => Container(margin: const EdgeInsets.symmetric(horizontal: 4), width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: i == index ? Colors.white : Colors.white24))));
  }
}

class _BmiStatus {
  final String text;
  final Color color;
  _BmiStatus({required this.text, required this.color});
}