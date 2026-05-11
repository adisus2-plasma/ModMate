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

  final _controller = PageController();
  int _page = 0;

  // ข้อมูลฟิลด์กรอกข้อมูล
  Gender? gender;
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  int? _frequencyIndex;

  @override
  void dispose() {
    _controller.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  // --- Logic Methods ---
  double _activityFactorFromIndex(int? i) {
    switch (i) {
      case 0: return 1.2;
      case 1: return 1.375;
      case 2: return 1.55;
      case 3: return 1.725;
      case 4: return 1.9;
      case 5: return 2.0;
      default: return 1.2;
    }
  }

  double _calcBmi({required double weightKg, required double heightCm}) {
    final hM = heightCm / 100.0;
    return (hM <= 0) ? 0 : weightKg / (hM * hM);
  }

  double _calcBmr({required Gender g, required double weightKg, required double heightCm, required int age}) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    if (g == Gender.male) return base + 5;
    if (g == Gender.female) return base - 161;
    return base - 78;
  }

  void _goBack() {
    if (_page == 0) {
      Navigator.pop(context);
    } else {
      _controller.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  void _goNext() async {
    FocusScope.of(context).unfocus(); // ✅ ปิดคีย์บอร์ดก่อนไปหน้าถัดไป
    if (_page < 2) {
      _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    } else if (_page == 2) {
      final ok = await _finish();
      if (ok && mounted) _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  Future<bool> _finish() async {
    final age = int.tryParse(_ageCtrl.text.trim()) ?? 0;
    final weightKg = double.tryParse(_weightCtrl.text.trim()) ?? 0;
    final heightCm = double.tryParse(_heightCtrl.text.trim()) ?? 0;

    if (age <= 0 || weightKg <= 0 || heightCm <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบถ้วน")));
      return false;
    }

    final bmi = _calcBmi(weightKg: weightKg, heightCm: heightCm);
    final bmr = _calcBmr(g: gender ?? Gender.preferNot, weightKg: weightKg, heightCm: heightCm, age: age);
    final factor = _activityFactorFromIndex(_frequencyIndex);
    final tdee = bmr * factor;

    try {
      await FirestoreAuthService.instance.updateAssessment(
        username: widget.username,
        gender: (gender ?? Gender.preferNot).name,
        age: age,
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
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      resizeToAvoidBottomInset: true, // ✅ ให้ UI ขยับหนีคีย์บอร์ด
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(page: _page, total: 4, onBack: _goBack, onSkip: () async => await _finish()),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _IntroStep(onContinue: _goNext),
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
                  _RegisterSuccessStep(onGoToLogin: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage(username: null)), (r) => false);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Steps ---

class _IntroStep extends StatelessWidget {
  final VoidCallback onContinue;
  const _IntroStep({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          const Spacer(),
          Image.asset("assets/logo.png", width: 100, height: 100, errorBuilder: (_, _, _) => const Icon(Icons.fitness_center, color: Colors.white, size: 80)),
          const SizedBox(height: 18),
          const Text("ข้อมูลสุขภาพ", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const Text("เราจะคำนวณ TDEE, BMI และแนะนำแคลอรี่ที่เหมาะสมให้คุณ", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
          const Spacer(),
          _PrimaryButton(text: "เข้าใจแล้ว", onPressed: onContinue),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _GenderAndBodyStep extends StatelessWidget {
  final Gender? gender;
  final ValueChanged<Gender> onGenderChanged;
  final TextEditingController ageCtrl, weightCtrl, heightCtrl;
  final VoidCallback onContinue;

  const _GenderAndBodyStep({required this.gender, required this.onGenderChanged, required this.ageCtrl, required this.weightCtrl, required this.heightCtrl, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView( // ✅ แก้ปัญหาคีย์บอร์ดบังปุ่ม
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  const Text("เพศ", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  _SelectRow(icon: Icons.male, text: "ชาย", selected: gender == Gender.male, onTap: () => onGenderChanged(Gender.male)),
                  const SizedBox(height: 12),
                  _SelectRow(icon: Icons.female, text: "หญิง", selected: gender == Gender.female, onTap: () => onGenderChanged(Gender.female)),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(child: _LabeledField(label: "อายุ", controller: ageCtrl, hint: "ปี")),
                      const SizedBox(width: 14),
                      Expanded(child: _LabeledField(label: "น้ำหนัก", controller: weightCtrl, hint: "kg")),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _LabeledField(label: "ส่วนสูง", controller: heightCtrl, hint: "cm"),
                  const Expanded(child: SizedBox(height: 40)), // ✅ ดันปุ่มลงล่างสุด
                  _PrimaryButton(text: "ต่อไป", onPressed: onContinue),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _FrequencyStep extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onContinue;

  const _FrequencyStep({required this.selectedIndex, required this.onSelect, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final options = [
      ("ออกกำลังกายน้อยมาก หรือไม่ออกเลย", Icons.remove),
      ("ออกกำลังกาย 1-3 ครั้ง / สัปดาห์", Icons.fitness_center),
      ("ออกกำลังกาย 3-4 ครั้ง / สัปดาห์", Icons.fitness_center),
      ("ออกกำลังกาย 4-5 ครั้ง / สัปดาห์", Icons.fitness_center),
      ("ออกกำลังกาย 6-7 ครั้ง / สัปดาห์", Icons.fitness_center),
      ("ออกกำลังกายอย่างหนักทุกวัน", Icons.speed),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView( // ✅ แก้ปัญหาคีย์บอร์ดบังปุ่ม
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("ความถี่การออกกำลังกาย", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  ...List.generate(options.length, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SelectPill(icon: options[i].$2, text: options[i].$1, selected: selectedIndex == i, onTap: () => onSelect(i)),
                  )),
                  const Expanded(child: SizedBox(height: 40)),
                  _PrimaryButton(text: "ต่อไป", onPressed: onContinue),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _RegisterSuccessStep extends StatelessWidget {
  final VoidCallback onGoToLogin;
  const _RegisterSuccessStep({required this.onGoToLogin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF69B81D), size: 80),
          const SizedBox(height: 18),
          const Text("ลงทะเบียนเรียบร้อย", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 40),
          _PrimaryButton(text: "เข้าสู่หน้าเริ่มต้น", onPressed: onGoToLogin),
        ],
      ),
    );
  }
}

// --- Elements ---

class _TopBar extends StatelessWidget {
  final int page, total;
  final VoidCallback onBack, onSkip;
  const _TopBar({required this.page, required this.total, required this.onBack, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          IconButton(onPressed: onBack, icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30)),
          Expanded(child: LinearProgressIndicator(value: (page + 1) / total, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(Color(0xFFFF7A1A)))),
          TextButton(onPressed: onSkip, child: const Text("ข้าม", style: TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7A1A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), const SizedBox(width: 8), const Icon(Icons.arrow_forward, color: Colors.white)]),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  const _LabeledField({required this.label, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: const Color(0xFF3B3C41), borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.white24), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
          ),
        ),
      ],
    );
  }
}

class _SelectRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _SelectRow({required this.icon, required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFF3B3C41), borderRadius: BorderRadius.circular(12), border: selected ? Border.all(color: const Color(0xFFFF7A1A)) : null),
        child: Row(children: [Icon(icon, color: Colors.white), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(color: Colors.white))), Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? const Color(0xFFFF7A1A) : Colors.white24)]),
      ),
    );
  }
}

class _SelectPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _SelectPill({required this.icon, required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: selected ? const Color(0xFF4A230D) : const Color(0xFF3B3C41), borderRadius: BorderRadius.circular(12), border: selected ? Border.all(color: const Color(0xFFFF7A1A)) : null),
        child: Row(children: [Icon(icon, color: selected ? const Color(0xFFFF7A1A) : Colors.white), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(color: Colors.white))), if (selected) const Icon(Icons.check, color: Color(0xFFFF7A1A))]),
      ),
    );
  }
}