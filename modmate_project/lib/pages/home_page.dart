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

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ===== Colors & Theme =====
  static const Color kBg = Colors.black;
  static const Color kAccent = Color(0xFFFF7A1A);
  static const Color kGreen = Color(0xFF7CFF00);
  static const Color kCard = Color(0xFF23242A);
  static const Color kCardBorder = Color(0xFF3A3B40);

  // ===== Scroll Control =====
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
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

  // Navigation Logic
  void _goToExercise(BuildContext context, String exerciseId) {
    final allExercises = ExerciseListPage(bodyPartLabel: '', bodyPartKey: '').allExercises;
    final exercise = allExercises.firstWhere((e) => e.id == exerciseId, orElse: () => allExercises.first);
    Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseActionPage(exercise: exercise)));
  }

  // Helpers
  String _fmtInt(double? v) => (v == null) ? '-' : v.toStringAsFixed(0);
  String _fmtNum(double? v, {int fraction = 2}) => (v == null) ? '-' : v.toStringAsFixed(fraction);

  _BmiStatus _bmiStatus(double? bmiVal) {
    if (bmiVal == null) return _BmiStatus(text: 'ยังไม่มีข้อมูล', color: Colors.white60);
    if (bmiVal < 18.5) return _BmiStatus(text: 'น้ำหนักต่ำกว่าเกณฑ์', color: Colors.yellow);
    if (bmiVal < 25.0) return _BmiStatus(text: 'น้ำหนักอยู่ในเกณฑ์ปกติ', color: kGreen);
    if (bmiVal < 30.0) return _BmiStatus(text: 'น้ำหนักเริ่มเกินมาตรฐาน', color: Colors.orange);
    return _BmiStatus(text: 'อ้วน', color: Colors.redAccent);
  }

  @override
  Widget build(BuildContext context) {
    final bmiStatus = _bmiStatus(bmi);
    final top3Tips = kTips.take(3).toList();

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          thickness: 5,
          radius: const Radius.circular(10),
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Hero Section
                _TopHero(
                  username: widget.username,
                  tdeeText: tdee == null ? null : '${_fmtInt(tdee)} kcal/วัน',
                  onAvatarTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(username: widget.username)));
                  },
                ),

                const SizedBox(height: 24),

                // 2. Categories
                const _Label(text: "หมวดหมู่"),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CategoryIcon(bg: const Color(0xFF5B5D66), icon: Icons.fitness_center, label: "เวทเทรนนิ่ง", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BodyPartSelectionPage()))),
                      _CategoryIcon(bg: const Color(0xFF4A230D), icon: Icons.apple, label: "คำนวณ TDEE", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TdeePage(username: widget.username)))),
                      _CategoryIcon(bg: const Color(0xFF182453), icon: Icons.stacked_line_chart, label: "BMI/BMR", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BmiBmrPage(username: widget.username)))),
                      _CategoryIcon(bg: const Color(0xFF1E3C13), icon: Icons.swap_horiz, label: "แปลงหน่วย", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LbsKgConvertPage()))),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Summary Card
                const _Label(text: "ภาพรวมของคุณ"),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SummaryCard(
                    bmiText: _fmtNum(bmi, fraction: 2),
                    bmrText: '${_fmtInt(bmr)} kcal/day',
                    status: bmiStatus,
                  ),
                ),

                const SizedBox(height: 24),

                // 4. Workout Slides
                _HeaderWithAction(title: "ท่าเวทเทรนนิ่งที่แนะนำ", onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BodyPartSelectionPage()))),
                const SizedBox(height: 12),
                SizedBox(
                  height: 250,
                  child: PageView(
                    onPageChanged: (i) => setState(() => _workoutIndex = i),
                    children: [
                      _WorkoutSlide(onTap: () => _goToExercise(context, 'arm_1'), imagePath: "assets/workout_img/arm/arm_1.png", title: "Dumbbell Curl", subtitle: "ฝึกกล้ามเนื้อแขนหน้า"),
                      _WorkoutSlide(onTap: () => _goToExercise(context, 'chest_1'), imagePath: "assets/workout_img/chest/chest_1.png", title: "Bench Press", subtitle: "ฝึกกล้ามเนื้อหน้าอก"),
                      _WorkoutSlide(onTap: () => _goToExercise(context, 'back_1'), imagePath: "assets/workout_img/back/back_1.png", title: "Dumbbell Rows", subtitle: "ฝึกกล้ามเนื้อหลัง"),
                      _WorkoutSlide(onTap: () => _goToExercise(context, 'shoulder_1'), imagePath: "assets/workout_img/shoulder/shoulder_1.png", title: "Dumbbell Shoulder Press", subtitle: "ฝึกกล้ามเนื้อหัวไหล่"),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _Dots(count: 4, index: _workoutIndex),

                const SizedBox(height: 24),

                // 5. Tips Section
                _HeaderWithAction(title: "Tips ต่าง ๆ", onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TipsPage()))),
                const SizedBox(height: 12),
                SizedBox(
                  height: 280,
                  child: PageView(
                    controller: PageController(viewportFraction: 0.88),
                    onPageChanged: (i) => setState(() => _tipIndex = i),
                    children: top3Tips.map((t) => _TipCard(
                      imagePath: t.imagePath,
                      tag: t.tag,
                      title: t.title,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TipDetailPage(item: t))),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                _Dots(count: top3Tips.length, index: _tipIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Sub-Widgets ---

class _TopHero extends StatelessWidget {
  final String username;
  final String? tdeeText;
  final VoidCallback onAvatarTap;
  const _TopHero({required this.username, required this.tdeeText, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF2A2B30),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: const CircleAvatar(radius: 28, backgroundColor: Color(0xFFFFE0B2), child: Icon(Icons.person, color: Color(0xFFFF7A1A))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text("สวัสดี $username", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png", width: 50, height: 50, errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, color: Colors.white, size: 40)),
              const SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("พลังงานที่เหมาะสมกับวันนี้", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(text: "(TDEE) ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          TextSpan(text: tdeeText ?? "คำนวณเลย", style: const TextStyle(color: Color(0xFF7CFF00), fontSize: 18, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
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
      child: Column(
        children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 26)),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String bmiText;
  final String bmrText;
  final _BmiStatus status;
  const _SummaryCard({required this.bmiText, required this.bmrText, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF23242A), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFF3A3B40))),
      child: Column(
        children: [
          _buildMetricRow("ค่าดัชนีมวลกาย (BMI)", bmiText, status.text, status.color, Icons.monitor_weight_outlined, const Color(0xFFFF7A1A)),
          const Divider(color: Colors.white10, height: 32),
          _buildMetricRow("พลังงานพื้นฐาน (BMR)", bmrText, "kcal/day", Colors.white70, Icons.local_fire_department_outlined, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String title, String value, String sub, Color subCol, IconData icon, Color iconCol) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconCol.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconCol)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              Text(sub, style: TextStyle(color: subCol, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkoutSlide extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _WorkoutSlide({required this.imagePath, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[900])),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent]))),
              Positioned(left: 20, bottom: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text(subtitle, style: const TextStyle(color: Colors.white70))])),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String imagePath;
  final String tag;
  final String title;
  final VoidCallback onTap;
  const _TipCard({required this.imagePath, required this.tag, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(22)),
        child: Column(
          children: [
            Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(22)), child: Image.asset(imagePath, width: double.infinity, fit: BoxFit.cover))),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tag, style: const TextStyle(color: Color(0xFFFF7A1A), fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)));
}

class _HeaderWithAction extends StatelessWidget {
  final String title;
  final VoidCallback onAction;
  const _HeaderWithAction({required this.title, required this.onAction});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)), TextButton(onPressed: onAction, child: const Text("ดูทั้งหมด", style: TextStyle(color: Color(0xFFFF7A1A))))]),
  );
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;
  const _Dots({required this.count, required this.index});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(count, (i) => Container(margin: const EdgeInsets.symmetric(horizontal: 4), width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: i == index ? Colors.white : Colors.white24))));
}

class _BmiStatus {
  final String text;
  final Color color;
  _BmiStatus({required this.text, required this.color});
}