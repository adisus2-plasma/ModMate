import 'package:flutter/material.dart';
import '../../services/firestore_auth_service.dart';
import '../login_page.dart';

class AssessmentFlowPage extends StatefulWidget {
  final String username;
  const AssessmentFlowPage({super.key, required this.username});

  @override
  State<AssessmentFlowPage> createState() => _AssessmentFlowPageState();
}

enum Gender { male, female, other, preferNot }


class _AssessmentFlowPageState extends State<AssessmentFlowPage> {
  static const _accent = Color(0xFFFF7A1A);
  static const _bg = Color(0xFF141518);
  static const _card = Color(0xFF3B3C41); // เทาเข้มแบบในภาพ
  static const _card2 = Color(0xFF2C2D32); // เผื่อใช้

  final _controller = PageController();
  int _page = 0;

  double _activityFactorFromIndex(int? i) {
    switch (i) {
      case 0: return 1.2;   // น้อยมาก/ไม่ออกเลย
      case 1: return 1.375; // 1-3 ครั้ง/สัปดาห์
      case 2: return 1.55;  // 3-4 ครั้ง/สัปดาห์
      case 3: return 1.725; // 4-5 ครั้ง/สัปดาห์
      case 4: return 1.9;   // 6-7 ครั้ง/สัปดาห์
      case 5: return 2.0;   // หนักทุกวัน (ปรับได้)
      default: return 1.2;
    }
  }

  double _calcBmi({required double weightKg, required double heightCm}) {
    final hM = heightCm / 100.0;
    if (hM <= 0) return 0;
    return weightKg / (hM * hM);
  }

  double _calcBmr({
    required Gender g,
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    // Mifflin-St Jeor
    // male: 10W + 6.25H - 5A + 5
    // female: 10W + 6.25H - 5A - 161
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    if (g == Gender.male) return base + 5;
    if (g == Gender.female) return base - 161;

    // other / preferNot: ใช้ค่าเฉลี่ยระหว่าง +5 และ -161 = -78
    return base - 78;
  }

  // ข้อมูล
  Gender? gender;

  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();

  int? _frequencyIndex;

  @override
  void initState() {
    super.initState();
    _ageCtrl.text = "";
    _weightCtrl.text = "";
    _heightCtrl.text = "";
  }

  @override
  void dispose() {
    _controller.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_page == 0) {
      Navigator.pop(context);
    } else {
      _controller.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _goNext() async {
    // pages: 0 Intro, 1 Gender/Body, 2 Frequency, 3 Success
    if (_page < 2) {
      _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      return;
    }

    // ✅ ถ้าอยู่หน้า Frequency แล้วกดต่อไป -> save แล้วไปหน้า success
    if (_page == 2) {
      final ok = await _finish(); // เปลี่ยน _finish ให้คืน bool
      if (!mounted) return;
      if (ok) {
        _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
      return;
    }
  }

  void _goToLogin() {
  // ✅ ล้าง stack แล้วไปหน้า Login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage(username: null)),
      (route) => false,
    );
  }

  Future<bool> _finish() async {
    final g = (gender ?? Gender.preferNot);

    final age = int.tryParse(_ageCtrl.text.trim()) ?? 0;
    final weightKg = double.tryParse(_weightCtrl.text.trim()) ?? 0;
    final heightCm = double.tryParse(_heightCtrl.text.trim()) ?? 0;

    if (age <= 0 || weightKg <= 0 || heightCm <= 0) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอก อายุ/น้ำหนัก/ส่วนสูง ให้ถูกต้อง")),
      );
      return false;
    }

    final bmi = _calcBmi(weightKg: weightKg, heightCm: heightCm);
    final bmr = _calcBmr(g: g, weightKg: weightKg, heightCm: heightCm, age: age);

    final factor = _activityFactorFromIndex(_frequencyIndex);
    final tdee = bmr * factor;

    try {
      await FirestoreAuthService.instance.updateAssessment(
        username: widget.username,
        gender: g.name,
        weightKg: double.parse(weightKg.toStringAsFixed(2)),
        heightCm: double.parse(heightCm.toStringAsFixed(2)),
        dailyKcal: double.parse(tdee.toStringAsFixed(0)),
      );

      await FirestoreAuthService.instance.updateMetrics(
        username: widget.username,
        bmi: double.parse(bmi.toStringAsFixed(2)),
        bmr: double.parse(bmr.toStringAsFixed(0)),
        tdee: double.parse(tdee.toStringAsFixed(0)),
      );

      return true;
    } catch (_) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("บันทึกข้อมูลไม่สำเร็จ ลองใหม่อีกครั้ง")),
      );
      return false;
    }
  }

  void _skipAll() async => await _finish();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              page: _page,
              total: 4,
              onBack: _goBack,
              onSkip: _skipAll,
            ),

            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _IntroStep(
                    onContinue: _goNext,
                    onSkipAll: _skipAll,
                  ),
                  _GenderAndBodyStep(
                    gender: gender,
                    onGenderChanged: (g) => setState(() => gender = g),
                    ageCtrl: _ageCtrl,
                    weightCtrl: _weightCtrl,
                    heightCtrl: _heightCtrl,
                    onContinue: _goNext,
                  ),
                  _FrequencyStep(
                    selectedIndex: _frequencyIndex,
                    onSelect: (i) => setState(() => _frequencyIndex = i),
                    onContinue: _goNext,
                  ),
                  _RegisterSuccessStep(
                    onGoToLogin: _goToLogin,
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

// =================== TOP BAR ===================

class _TopBar extends StatelessWidget {
  final int page;
  final int total;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const _TopBar({
    required this.page,
    required this.total,
    required this.onBack,
    required this.onSkip,
  });

  static const accent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    final v = (page + 1) / total;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: v,
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.14),
                valueColor: const AlwaysStoppedAnimation(accent),
              ),
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: onSkip,
            child: const Text(
              "ข้าม",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =================== COMMON BUTTON ===================

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.text, required this.onPressed});

  static const accent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }
}

// =================== STEP 0 (Intro) ===================

class _IntroStep extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkipAll;

  const _IntroStep({
    required this.onContinue,
    required this.onSkipAll,
  });

  static const accent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // โลโก้เล็ก ๆ กลางจอ (ใส่ asset ได้)
          Transform.rotate(
            angle: -0.25,
            child: const Icon(Icons.fitness_center, color: Colors.white, size: 44),
          ),

          const SizedBox(height: 18),

          const Text(
            "ข้อมูลสุขภาพ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "เราจะสอบถามข้อมูลเพื่อไปคำนวณค่า TDEE, BMI\nและแนะนำจำนวนแคลอรี่ที่เหมาะสมต่อวันให้คุณ\nโดยไม่มีการเก็บข้อมูลส่วนตัวอื่นลงในฐานข้อมูล",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),

          const Spacer(),

          _PrimaryButton(text: "เข้าใจแล้ว", onPressed: onContinue),
          const SizedBox(height: 12),

          TextButton(
            onPressed: onSkipAll,
            child: const Text(
              "ฉันไม่ต้องการตอบคำถาม",
              style: TextStyle(
                color: accent,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// =================== STEP 1 (Gender + Age/Weight/Height) ===================

class _GenderAndBodyStep extends StatelessWidget {
  final Gender? gender;
  final ValueChanged<Gender> onGenderChanged;
  final TextEditingController ageCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController heightCtrl;
  final VoidCallback onContinue;

  const _GenderAndBodyStep({
    required this.gender,
    required this.onGenderChanged,
    required this.ageCtrl,
    required this.weightCtrl,
    required this.heightCtrl,
    required this.onContinue,
  });

  static const bg = Color(0xFF141518);
  static const card = Color(0xFF3B3C41);
  static const accent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 22),
          const Text(
            "เพศ",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),

          _SelectRow(
            icon: Icons.male,
            text: "ชาย",
            selected: gender == Gender.male,
            onTap: () => onGenderChanged(Gender.male),
          ),
          const SizedBox(height: 12),
          _SelectRow(
            icon: Icons.female,
            text: "หญิง",
            selected: gender == Gender.female,
            onTap: () => onGenderChanged(Gender.female),
          ),

          const SizedBox(height: 26),

          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: "อายุ",
                  controller: ageCtrl,
                  hint: "อายุ",
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _LabeledField(
                  label: "น้ำหนัก",
                  controller: weightCtrl,
                  hint: "น้ำหนักของคุณ (kg)",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _LabeledField(
            label: "ส่วนสูง",
            controller: heightCtrl,
            hint: "ส่วนสูงของคุณ (cm)",
          ),

          const Spacer(),

          _PrimaryButton(text: "ต่อไป", onPressed: onContinue),
        ],
      ),
    );
  }
}

class _SelectRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SelectRow({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  static const card = Color(0xFF3B3C41);
  static const accent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? accent : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;

  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hint,
  });

  static const card = Color(0xFF3B3C41);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            cursorColor: Colors.white70,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// =================== STEP 2 (Frequency) ===================

class _FrequencyStep extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onContinue;

  const _FrequencyStep({
    required this.selectedIndex,
    required this.onSelect,
    required this.onContinue,
  });

  static const accent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    final options = const [
      ("ออกกำลังกายน้อยมาก หรือไม่ออกเลย", Icons.remove),
      ("ออกกำลังกาย 1-3 ครั้ง / สัปดาห์", Icons.fitness_center),
      ("ออกกำลังกาย 3-4 ครั้ง / สัปดาห์", Icons.fitness_center),
      ("ออกกำลังกาย 4-5 ครั้ง / สัปดาห์", Icons.fitness_center),
      ("ออกกำลังกาย 6-7 ครั้ง / สัปดาห์", Icons.fitness_center),
      ("ออกกำลังกายอย่างหนักทุกวัน", Icons.speed),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22),
          const Text(
            "ความถี่การออกกำลังกาย",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),

          ...List.generate(options.length, (i) {
            final (label, icon) = options[i];
            final selected = selectedIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SelectPill(
                icon: icon,
                text: label,
                selected: selected,
                onTap: () => onSelect(i),
              ),
            );
          }),

          const Spacer(),
          _PrimaryButton(text: "ต่อไป", onPressed: onContinue),
        ],
      ),
    );
  }
}

// =================== (RegisterSuccess) ===================
class _RegisterSuccessStep extends StatelessWidget {
  final VoidCallback onGoToLogin;
  const _RegisterSuccessStep({required this.onGoToLogin});

  static const accent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 40, 22, 22),
      child: Column(
        children: [
          const Spacer(),

          // ไอคอนเขียว
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF69B81D),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.black, size: 30),
          ),

          const SizedBox(height: 18),

          const Text(
            "ลงทะเบียนเรียบร้อย",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onGoToLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
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
                    "เข้าสู่หน้าเริ่มต้น",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _SelectPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SelectPill({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  static const accent = Color(0xFFFF7A1A);
  static const card = Color(0xFF3B3C41);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4A230D) : card, // เลือกแล้วโทนส้มเข้ม
          borderRadius: BorderRadius.circular(16),
          border: selected ? Border.all(color: accent, width: 1) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? accent : Colors.white70),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? accent : Colors.black,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.black)
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
