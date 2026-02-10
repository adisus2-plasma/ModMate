import 'package:flutter/material.dart';
import 'dart:math';

class TdeePage extends StatefulWidget {
  const TdeePage({super.key});

  @override
  State<TdeePage> createState() => _TdeePageState();
}

class _TdeePageState extends State<TdeePage> {
  String _gender = 'male'; // male / female

  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController(); // cm
  final _weightCtrl = TextEditingController(); // kg

  ActivityLevel? _activity;
  GoalType? _goal;

  @override
  void dispose() {
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    final age = int.tryParse(_ageCtrl.text);
    final heightCm = double.tryParse(_heightCtrl.text);
    final weightKg = double.tryParse(_weightCtrl.text);

    if (age == null || heightCm == null || weightKg == null) {
      _toast("กรุณากรอก อายุ / ส่วนสูง / น้ำหนัก ให้ครบ");
      return;
    }
    if (_activity == null) {
      _toast("กรุณาเลือกกิจกรรมของคุณ");
      return;
    }
    if (_goal == null) {
      _toast("กรุณาเลือกความต้องการของคุณ");
      return;
    }

    // ✅ BMR (Mifflin-St Jeor)
    final bmr = _gender == 'male'
        ? (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5
        : (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;

    // ✅ TDEE = BMR * ActivityFactor
    final tdeeBase = bmr * _activity!.factor;

    // ✅ ปรับตามเป้าหมาย (ประมาณการพลังงานต่อวัน)
    // 1 kg ไขมัน ~ 7700 kcal → 1 kg/สัปดาห์ ≈ 1100 kcal/วัน (7700/7)
    final target = tdeeBase + _goal!.dailyKcalDelta;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TdeeResultPage(
          tdee: target,
          baseTdee: tdeeBase,
          bmr: bmr,
          activity: _activity!,
          goal: _goal!,
        ),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("TDEE"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("เพศ"),
            const SizedBox(height: 8),
            Row(
              children: [
                _genderButton("ชาย", _gender == 'male', () {
                  setState(() => _gender = 'male');
                }),
                const SizedBox(width: 12),
                _genderButton("หญิง", _gender == 'female', () {
                  setState(() => _gender = 'female');
                }),
              ],
            ),

            const SizedBox(height: 20),
            _label("อายุของคุณ"),
            const SizedBox(height: 6),
            _input(_ageCtrl, "เช่น 22"),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("ส่วนสูง"),
                      const SizedBox(height: 6),
                      _input(_heightCtrl, "เช่น 175"),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("น้ำหนัก"),
                      const SizedBox(height: 6),
                      _input(_weightCtrl, "เช่น 75"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),
            _label("กิจกรรมของคุณ"),
            const SizedBox(height: 8),
            _dropdown<ActivityLevel>(
              value: _activity,
              hint: "โปรดเลือก",
              items: ActivityLevel.values
                  .map((a) => DropdownMenuItem(
                        value: a,
                        child: Text(a.label),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _activity = v),
            ),

            const SizedBox(height: 18),
            _label("ความต้องการ"),
            const SizedBox(height: 8),
            _dropdown<GoalType>(
              value: _goal,
              hint: "เลือกความต้องการ",
              items: GoalType.values
                  .map((g) => DropdownMenuItem(
                        value: g,
                        child: Text(g.label),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _goal = v),
            ),

            const SizedBox(height: 26),
            Center(
              child: SizedBox(
                width: min(MediaQuery.of(context).size.width, 260),
                height: 48,
                child: OutlinedButton(
                  onPressed: _calculate,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "คำนวณ",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- UI helpers ----------
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
    );
  }

  Widget _input(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _genderButton(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            color: selected ? Colors.black12 : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(hint),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// ------------------------
/// Result Page (ตาม wireframe ด้านขวา)
/// ------------------------
class TdeeResultPage extends StatelessWidget {
  final double tdee; // หลังปรับเป้าหมาย
  final double baseTdee; // ก่อนปรับเป้าหมาย
  final double bmr;
  final ActivityLevel activity;
  final GoalType goal;

  const TdeeResultPage({
    super.key,
    required this.tdee,
    required this.baseTdee,
    required this.bmr,
    required this.activity,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final display = tdee.isFinite ? tdee.toStringAsFixed(0) : "-";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("TDEE"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          children: [
            const SizedBox(height: 70),
            const Text(
              "พลังงานที่เหมาะสมในแต่ละวันของคุณ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),

            // กล่องผลลัพธ์สีเทา
            Container(
              width: double.infinity,
              height: 86,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black26,
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "$display kcal/วัน",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: 260,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: บันทึกค่า
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("บันทึกเรียบร้อย (ตัวอย่าง)")),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "บันทึก",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // (Optional) debug info - ลบทิ้งได้
            // Text("BMR: ${bmr.toStringAsFixed(0)} | baseTDEE: ${baseTdee.toStringAsFixed(0)}"),
          ],
        ),
      ),
    );
  }
}

/// ------------------------
/// Dropdown Enums
/// ------------------------

enum ActivityLevel {
  none, // 1.2
  light, // 1.375
  moderate, // 1.55
  active, // 1.725
  veryActive, // 1.9
  heavy; // 2.0 (งานหนัก/หนักมาก)

  String get label {
    switch (this) {
      case ActivityLevel.none:
        return "ออกกำลังกายน้อยมาก หรือไม่ออกเลย";
      case ActivityLevel.light:
        return "ออกกำลังกาย 1-3 ครั้ง / สัปดาห์";
      case ActivityLevel.moderate:
        return "ออกกำลังกาย 3-4 ครั้ง / สัปดาห์";
      case ActivityLevel.active:
        return "ออกกำลังกาย 4-5 ครั้ง / สัปดาห์";
      case ActivityLevel.veryActive:
        return "ออกกำลังกาย 6-7 ครั้ง / สัปดาห์";
      case ActivityLevel.heavy:
        return "ออกกำลังกายอย่างหนักหรือทำงานหนักทุกวัน";
    }
  }

  double get factor {
    switch (this) {
      case ActivityLevel.none:
        return 1.2;
      case ActivityLevel.light:
        return 1.375;
      case ActivityLevel.moderate:
        return 1.55;
      case ActivityLevel.active:
        return 1.725;
      case ActivityLevel.veryActive:
        return 1.9;
      case ActivityLevel.heavy:
        return 2.0;
    }
  }
}

enum GoalType {
  lose1,
  lose05,
  lose025,
  gain025,
  gain05,
  gain1;

  String get label {
    switch (this) {
      case GoalType.lose1:
        return "ลดน้ำหน้กอย่างมาก (-1kg/สัปดาห์)";
      case GoalType.lose05:
        return "ลดน้ำหน้ก (-0.5kg/สัปดาห์)";
      case GoalType.lose025:
        return "ลดน้ำหน้กเล็กน้อย (-0.25kg/สัปดาห์)";
      case GoalType.gain025:
        return "เพิ่มน้ำหน้กเล็กน้อย (+0.25kg/สัปดาห์)";
      case GoalType.gain05:
        return "เพิ่มน้ำหน้ก (+0.5kg/สัปดาห์)";
      case GoalType.gain1:
        return "เพิ่มน้ำหน้กอย่างมาก (+1kg/สัปดาห์)";
    }
  }

  /// kcal/day delta (approx) based on 1kg fat ≈ 7700 kcal
  double get dailyKcalDelta {
    switch (this) {
      case GoalType.lose1:
        return -(7700 / 7); // ≈ -1100
      case GoalType.lose05:
        return -(3850 / 7); // ≈ -550
      case GoalType.lose025:
        return -(1925 / 7); // ≈ -275
      case GoalType.gain025:
        return (1925 / 7); // ≈ +275
      case GoalType.gain05:
        return (3850 / 7); // ≈ +550
      case GoalType.gain1:
        return (7700 / 7); // ≈ +1100
    }
  }
}
