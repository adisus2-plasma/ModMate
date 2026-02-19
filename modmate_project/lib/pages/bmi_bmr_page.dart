import 'package:flutter/material.dart';
import '../services/firestore_auth_service.dart';

class BmiBmrPage extends StatefulWidget {
  final String username; // ✅ ต้องรู้ว่า user คนไหน
  const BmiBmrPage({super.key, required this.username});

  @override
  State<BmiBmrPage> createState() => _BmiBmrPageState();
}

enum Gender { male, female }

class _BmiBmrPageState extends State<BmiBmrPage> {
  // ===== Colors (ตามภาพดำ/ส้ม) =====
  static const Color kBg = Color(0xFF0F1012);
  static const Color kCard = Color(0xFF2C2D33);
  static const Color kField = Color(0xFF3A3B43);
  static const Color kAccent = Color(0xFFFF7A1A);

  Gender _gender = Gender.male;

  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();

  double? _bmi;
  double? _bmr;

  @override
  void dispose() {
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
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

    final heightM = heightCm / 100.0;

    // BMI
    final bmi = weightKg / (heightM * heightM);

    // BMR (Mifflin-St Jeor)
    // Male: 10W + 6.25H - 5A + 5
    // Female: 10W + 6.25H - 5A - 161
    final bmr = (_gender == Gender.male)
        ? (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5
        : (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;

    setState(() {
      _bmi = double.parse(bmi.toStringAsFixed(2));
      _bmr = double.parse(bmr.toStringAsFixed(0));
    });
  }

  String _bmiLabel(double bmi) {
    if (bmi < 18.5) return "น้ำหนักต่ำกว่าเกณฑ์";
    if (bmi < 25) return "น้ำหนักอยู่ในเกณฑ์ปกติ";
    if (bmi < 30) return "น้ำหนักเริ่มเกินมาตรฐาน";
    return "อ้วน";
  }

  Color _bmiLabelColor(double bmi) {
    if (bmi < 25) return const Color(0xFF4CAF50);
    if (bmi < 30) return const Color(0xFFFFC107);
    return const Color(0xFFFF5252);
  }

  Future<void> _save() async {
    if (_bmi == null || _bmr == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากดคำนวณก่อนบันทึก")),
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

    final genderStr = (_gender == Gender.male) ? "male" : "female";

    try {
      await FirestoreAuthService.instance.updateProfileAndMetrics(
        username: widget.username,
        gender: genderStr,
        age: age,
        weightKg: weightKg,
        heightCm: heightCm,
        bmi: _bmi,
        bmr: _bmr,
      );

      if (!mounted) return;
      Navigator.pop(context, {'bmi': _bmi, 'bmr': _bmr, 'saved': true});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("บันทึกไม่สำเร็จ ลองใหม่อีกครั้ง")),
      );
    }
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: "คำนวณ BMI/BMR",
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    const Text(
                      "เพศ",
                      style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 16),

                    _GenderTile(
                      icon: Icons.male,
                      text: "ชาย",
                      selected: _gender == Gender.male,
                      onTap: () => setState(() => _gender = Gender.male),
                    ),
                    const SizedBox(height: 12),
                    _GenderTile(
                      icon: Icons.female,
                      text: "หญิง",
                      selected: _gender == Gender.female,
                      onTap: () => setState(() => _gender = Gender.female),
                    ),

                    const SizedBox(height: 26),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "อายุ",
                                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 10),
                              _InputPill(
                                controller: _ageCtrl,
                                hint: "อายุ",
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "น้ำหนัก",
                                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 10),
                              _InputPill(
                                controller: _weightCtrl,
                                hint: "น้ำหนักของคุณ (kg)",
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      "ส่วนสูง",
                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),
                    _InputPill(
                      controller: _heightCtrl,
                      hint: "ส่วนสูงของคุณ (cm)",
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 26),

                    _SmallAccentButton(
                      text: "คำนวณ",
                      icon: Icons.edit,
                      onTap: _calculate,
                    ),

                    const SizedBox(height: 26),

                    if (_bmi != null && _bmr != null) ...[
                      _ResultCard(
                        bmi: _bmi!,
                        bmr: _bmr!,
                        bmiLabel: _bmiLabel(_bmi!),
                        bmiLabelColor: _bmiLabelColor(_bmi!),
                      ),
                      const SizedBox(height: 22),
                      _BigAccentButton(
                        text: "บันทึก",
                        icon: Icons.save_outlined,
                        onTap: _save,
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, {'bmi': _bmi, 'bmr': _bmr, 'saved': false}),
                        child: const Text("ไม่บันทึก / กลับ", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
                      ),
                    ],
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

// ===================== UI Parts =====================

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
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class _GenderTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _GenderTile({
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

class _SmallAccentButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _SmallAccentButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 160,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(width: 10),
            Icon(icon, size: 18),
          ],
        ),
      ),
    );
  }
}

class _BigAccentButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _BigAccentButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(width: 10),
            Icon(icon, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final double bmi;
  final double bmr;
  final String bmiLabel;
  final Color bmiLabelColor;

  const _ResultCard({
    required this.bmi,
    required this.bmr,
    required this.bmiLabel,
    required this.bmiLabelColor,
  });

  static const Color kCard = Color(0xFF2C2D33);
  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ค่าดัชนีมวลกาย (BMI)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.monitor_weight_outlined, color: kAccent),
              const SizedBox(width: 10),
              Text(
                bmi.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            bmiLabel,
            style: TextStyle(color: bmiLabelColor, fontWeight: FontWeight.w900, fontSize: 18),
          ),

          const SizedBox(height: 14),
          Divider(color: Colors.white.withOpacity(0.35)),
          const SizedBox(height: 14),

          const Text("พลังงานที่ต้องการต่อวัน (BMR)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.local_fire_department_outlined, color: Color(0xFF2E86FF)),
              const SizedBox(width: 10),
              Text(
                "${bmr.toStringAsFixed(0)}",
                style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 8),
              const Text("kcal/day", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

enum _SaveAction { noSave, save }

class _SaveConfirmDialog extends StatelessWidget {
  final bool canSave;
  const _SaveConfirmDialog({required this.canSave});

  static const Color kBg = Color(0xFF1D1E22);
  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          color: kBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.10)),
          boxShadow: const [
            BoxShadow(color: Color(0x55000000), blurRadius: 30, offset: Offset(0, 18)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "ต้องการบันทึกผลลัพธ์ไหม?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              canSave
                  ? "ถ้าบันทึก ระบบจะอัปเดตค่า BMI/BMR ลงฐานข้อมูล"
                  : "โหมดนี้ไม่สามารถบันทึกลงฐานข้อมูลได้ (ไม่พบ username)",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.70), fontWeight: FontWeight.w700, height: 1.35),
            ),
            const SizedBox(height: 16),

            // ปุ่มบันทึก
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSave ? () => Navigator.pop(context, _SaveAction.save) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSave ? kAccent : Colors.white.withOpacity(0.12),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text("บันทึก", style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 10),

            // ปุ่มไม่บันทึก
            SizedBox(
              height: 52,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, _SaveAction.noSave),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kAccent,
                  side: BorderSide(color: kAccent.withOpacity(0.9)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text("ไม่บันทึก", style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

