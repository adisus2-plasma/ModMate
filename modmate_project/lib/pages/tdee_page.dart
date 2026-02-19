import 'package:flutter/material.dart';
import '../services/firestore_auth_service.dart';

class TdeePage extends StatefulWidget {
  final String username; // ✅ ต้องรู้ว่า user คนไหน เพื่อบันทึกเข้า DB
  const TdeePage({super.key, required this.username});

  @override
  State<TdeePage> createState() => _TdeePageState();
}

enum TdeeGender { male, female }

class _TdeePageState extends State<TdeePage> {
  // ===== Theme (ตามภาพ) =====
  static const Color kBg = Color(0xFF0F1012);
  static const Color kCard = Color(0xFF2C2D33);
  static const Color kTile = Color(0xFF3A3B43);
  static const Color kAccent = Color(0xFFFF7A1A);
  static const Color kTextDim = Color(0xFFB7B7B7);

  final _pageCtrl = PageController();
  int _page = 0;

  // ===== Inputs =====
  TdeeGender _gender = TdeeGender.male;
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();

  // Activity factor (ตามภาพ)
  // 0 = sedentary, 1 = light, 2 = moderate, 3 = very, 4 = extra
  int _activityIndex = 0;

  // Goal (ลด/เพิ่มน้ำหนัก)
  // kcal adjustment per day (ประมาณการจาก kg/week)
  // -1kg/wk ~ -1000 kcal/day, -0.5 ~ -500, -0.25 ~ -250, +0.25 ~ +250, +0.5 ~ +500, +1 ~ +1000
  int _goalIndex = 3; // ค่าเริ่มต้น “เพิ่มน้ำหนักเล็กน้อย” ตามภาพ (index 3)

  // ===== Results =====
  double? _bmr;
  double? _tdee; // base tdee (BMR * activity)
  double? _tdeeGoalAdjusted; // tdee หลังปรับเป้าหมาย
  bool _saving = false;

  @override
  void dispose() {
    _pageCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  // ===== Flow controls =====
  void _goNext() {
    FocusScope.of(context).unfocus();
    if (_page < 2) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  void _goPrev() {
    if (_page == 0) {
      Navigator.pop(context);
      return;
    }
    _pageCtrl.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  // ===== Calculations =====
  double _activityFactor(int idx) {
    // ตรงกับชื่อใน UI ด้านล่าง
    switch (idx) {
      case 0:
        return 1.2; // น้อยมาก/ไม่ออก
      case 1:
        return 1.375; // 1-3 ครั้ง/สัปดาห์
      case 2:
        return 1.55; // 3-4 ครั้ง/สัปดาห์
      case 3:
        return 1.725; // 4-5 ครั้ง/สัปดาห์
      case 4:
        return 1.9; // 6-7 ครั้ง/สัปดาห์/หนัก
      default:
        return 1.2;
    }
  }

  int _goalDeltaKcal(int idx) {
    // ตามภาพหน้า “ความต้องการในการลดน้ำหนัก”
    switch (idx) {
      case 0:
        return -1000; // ลดมาก (-1kg/สัปดาห์)
      case 1:
        return -500; // ลด (-0.5)
      case 2:
        return -250; // ลดเล็กน้อย (-0.25)
      case 3:
        return 250; // เพิ่มเล็กน้อย (+0.25)
      case 4:
        return 500; // เพิ่ม (+0.5)
      case 5:
        return 1000; // เพิ่มมาก (+1)
      default:
        return 0;
    }
  }

  void _calculate() {
    final age = double.tryParse(_ageCtrl.text.trim());
    final weightKg = double.tryParse(_weightCtrl.text.trim());
    final heightCm = double.tryParse(_heightCtrl.text.trim());

    if (age == null || weightKg == null || heightCm == null || heightCm <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบและถูกต้อง")),
      );
      return;
    }

    // BMR (Mifflin-St Jeor)
    final bmr = (_gender == TdeeGender.male)
        ? (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5
        : (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;

    final baseTdee = bmr * _activityFactor(_activityIndex);
    final goalAdjusted = (baseTdee + _goalDeltaKcal(_goalIndex)).clamp(0, 999999);

    setState(() {
      _bmr = double.parse(bmr.toStringAsFixed(0));
      _tdee = double.parse(baseTdee.toStringAsFixed(0));
      _tdeeGoalAdjusted = double.parse(goalAdjusted.toStringAsFixed(0));
    });

    // ไปหน้าผลลัพธ์ (หน้า 4)
    _pageCtrl.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  // ===== Save / No Save =====
  void _returnWithoutSave() {
    // ส่งค่ากลับไปให้หน้า Home อัปเดต UI ได้ (แต่ DB ไม่เปลี่ยน)
    Navigator.pop(context, {
      'tdee': _tdeeGoalAdjusted,
      'tdeeBase': _tdee,
      'bmr': _bmr,
    });
  }

  Future<void> _saveToDb() async {
    if (_tdeeGoalAdjusted == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ยังไม่มีผลลัพธ์ให้บันทึก")),
      );
      return;
    }

    final age = int.tryParse(_ageCtrl.text.trim());
    final weightKg = double.tryParse(_weightCtrl.text.trim());
    final heightCm = double.tryParse(_heightCtrl.text.trim());

    if (age == null || weightKg == null || heightCm == null || heightCm <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอก อายุ/น้ำหนัก/ส่วนสูง ให้ถูกต้อง")),
      );
      return;
    }

    final genderStr = (_gender == TdeeGender.male) ? "male" : "female";

    setState(() => _saving = true);
    try {
      await FirestoreAuthService.instance.updateProfileAndMetrics(
        username: widget.username,
        gender: genderStr,
        age: age,
        weightKg: weightKg,
        heightCm: heightCm,
        tdee: _tdeeGoalAdjusted!,
        activityIndex: _activityIndex,
        goalIndex: _goalIndex,
      );


      if (!mounted) return;

      Navigator.pop(context, {
        'tdee': _tdeeGoalAdjusted,
        'saved': true,
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("บันทึกไม่สำเร็จ ลองใหม่อีกครั้ง")),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    final title = "คำนวณ TDEE";

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: title,
              onBack: _goPrev,
            ),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _Step1Basic(
                    gender: _gender,
                    onGenderChanged: (g) => setState(() => _gender = g),
                    ageCtrl: _ageCtrl,
                    weightCtrl: _weightCtrl,
                    heightCtrl: _heightCtrl,
                    onNext: _goNext,
                  ),
                  _Step2Activity(
                    selectedIndex: _activityIndex,
                    onSelect: (i) => setState(() => _activityIndex = i),
                    onNext: _goNext,
                  ),
                  _Step3Goal(
                    selectedIndex: _goalIndex,
                    onSelect: (i) => setState(() => _goalIndex = i),
                    onCalculate: _calculate,
                  ),
                  _Step4Result(
                    tdee: _tdeeGoalAdjusted,
                    saving: _saving,
                    onSave: _saveToDb,
                    onNoSave: _returnWithoutSave,
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

// ===================== TOP BAR =====================

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

// ===================== STEP 1: เพศ/อายุ/น้ำหนัก/ส่วนสูง =====================

class _Step1Basic extends StatelessWidget {
  final TdeeGender gender;
  final ValueChanged<TdeeGender> onGenderChanged;
  final TextEditingController ageCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController heightCtrl;
  final VoidCallback onNext;

  const _Step1Basic({
    required this.gender,
    required this.onGenderChanged,
    required this.ageCtrl,
    required this.weightCtrl,
    required this.heightCtrl,
    required this.onNext,
  });

  static const Color kTile = Color(0xFF3A3B43);
  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Column(
        children: [
          const SizedBox(height: 6),
          const Text("เพศ", style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),

          _SelectTile(
            icon: Icons.male,
            text: "ชาย",
            selected: gender == TdeeGender.male,
            onTap: () => onGenderChanged(TdeeGender.male),
          ),
          const SizedBox(height: 12),
          _SelectTile(
            icon: Icons.female,
            text: "หญิง",
            selected: gender == TdeeGender.female,
            onTap: () => onGenderChanged(TdeeGender.female),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text("อายุ", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    _InputPill(controller: ageCtrl, hint: "อายุ", keyboardType: TextInputType.number),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  children: [
                    const Text("น้ำหนัก", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    _InputPill(controller: weightCtrl, hint: "น้ำหนักของคุณ (kg)", keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text("ส่วนสูง", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          _InputPill(controller: heightCtrl, hint: "ส่วนสูงของคุณ (cm)", keyboardType: TextInputType.number),

          const SizedBox(height: 22),

          SizedBox(
            height: 46,
            width: 160,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ถัดไป 1/3", style: TextStyle(fontWeight: FontWeight.w900)),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SelectTile({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  static const Color kTile = Color(0xFF3A3B43);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: kTile,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Color(0x24000000), blurRadius: 20, offset: Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            const Spacer(),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.black : Colors.transparent,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputPill extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _InputPill({
    required this.controller,
    required this.hint,
    required this.keyboardType,
  });

  static const Color kField = Color(0xFF3A3B43);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kField,
        borderRadius: BorderRadius.circular(22),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.35), fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

// ===================== STEP 2: ความถี่การออกกำลังกาย =====================

class _Step2Activity extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;

  const _Step2Activity({
    required this.selectedIndex,
    required this.onSelect,
    required this.onNext,
  });

  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    final items = <_ChoiceItem>[
      _ChoiceItem(icon: Icons.remove, text: "ออกกำลังกายน้อยมาก หรือไม่ออกเลย"),
      _ChoiceItem(icon: Icons.fitness_center, text: "ออกกำลังกาย 1-3 ครั้ง / สัปดาห์"),
      _ChoiceItem(icon: Icons.fitness_center, text: "ออกกำลังกาย 3-4 ครั้ง / สัปดาห์"),
      _ChoiceItem(icon: Icons.fitness_center, text: "ออกกำลังกาย 4-5 ครั้ง / สัปดาห์"),
      _ChoiceItem(icon: Icons.fitness_center, text: "ออกกำลังกาย 6-7 ครั้ง / สัปดาห์"),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          const Text(
            "ความถี่การออกกำลังกาย",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),

          for (int i = 0; i < items.length; i++) ...[
            _ChoiceTile(
              icon: items[i].icon,
              text: items[i].text,
              selected: selectedIndex == i,
              onTap: () => onSelect(i),
            ),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              height: 46,
              width: 160,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ถัดไป 2/3", style: TextStyle(fontWeight: FontWeight.w900)),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== STEP 3: เป้าหมายลด/เพิ่มน้ำหนัก =====================

class _Step3Goal extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onCalculate;

  const _Step3Goal({
    required this.selectedIndex,
    required this.onSelect,
    required this.onCalculate,
  });

  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    final items = <String>[
      "ลดน้ำหนักอย่างมาก (-1kg/สัปดาห์)",
      "ลดน้ำหนัก (-0.5 kg/สัปดาห์)",
      "ลดน้ำหนักเล็กน้อย (-0.25 kg/สัปดาห์)",
      "เพิ่มน้ำหนักเล็กน้อย (+0.25 kg/สัปดาห์)",
      "เพิ่มน้ำหนัก (+0.5 kg/สัปดาห์)",
      "เพิ่มน้ำหนักอย่างมาก (+1kg/สัปดาห์)",
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          const Text(
            "ความต้องการ\nในการลดน้ำหนัก",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),

          for (int i = 0; i < items.length; i++) ...[
            _ChoiceTile(
              icon: Icons.chat_bubble_outline,
              text: items[i],
              selected: selectedIndex == i,
              onTap: () => onSelect(i),
            ),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              height: 46,
              width: 160,
              child: ElevatedButton(
                onPressed: onCalculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("คำนวณ", style: TextStyle(fontWeight: FontWeight.w900)),
                    SizedBox(width: 10),
                    Icon(Icons.edit, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== STEP 4: ผลลัพธ์ + บันทึก/ไม่บันทึก =====================

class _Step4Result extends StatelessWidget {
  final double? tdee;
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback onNoSave;

  const _Step4Result({
    required this.tdee,
    required this.saving,
    required this.onSave,
    required this.onNoSave,
  });

  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    final display = (tdee ?? 0).toStringAsFixed(0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      child: Column(
        children: [
          const SizedBox(height: 26),
          const Icon(Icons.local_fire_department_outlined, color: kAccent, size: 40),
          const SizedBox(height: 18),

          Text(
            display,
            style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),

          const Text(
            "พลังงานที่เหมาะสมในแต่ละวันของคุณ",
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: saving ? null : onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(saving ? "กำลังบันทึก..." : "บันทึก",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(width: 10),
                  const Icon(Icons.save_outlined, size: 20),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ✅ ไม่บันทึก
          TextButton(
            onPressed: saving ? null : onNoSave,
            child: const Text(
              "ไม่บันทึก / กลับ",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== Choice tile =====================

class _ChoiceItem {
  final IconData icon;
  final String text;
  _ChoiceItem({required this.icon, required this.text});
}

class _ChoiceTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceTile({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  static const Color kTile = Color(0xFF3A3B43);
  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF3A1B0B) : kTile;
    final border = selected ? kAccent : Colors.transparent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 1.2),
          boxShadow: const [
            BoxShadow(color: Color(0x24000000), blurRadius: 20, offset: Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? kAccent : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.black, size: 16)
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
