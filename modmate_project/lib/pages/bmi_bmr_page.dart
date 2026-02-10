import 'package:flutter/material.dart';
import 'dart:math';

class BmiBmrPage extends StatefulWidget {
  const BmiBmrPage({super.key});

  @override
  State<BmiBmrPage> createState() => _BmiBmrPageState();
}

class _BmiBmrPageState extends State<BmiBmrPage> {
  String _gender = 'male'; // male / female

  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController(); // cm
  final _weightCtrl = TextEditingController(); // kg

  double? _bmi;
  double? _bmr;

  @override
  void initState() {
    super.initState();
    _ageCtrl.addListener(_calculate);
    _heightCtrl.addListener(_calculate);
    _weightCtrl.addListener(_calculate);
  }

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
      setState(() {
        _bmi = null;
        _bmr = null;
      });
      return;
    }

    // ✅ BMI
    final heightM = heightCm / 100;
    final bmi = weightKg / pow(heightM, 2);

    // ✅ BMR (Mifflin-St Jeor Equation)
    double bmr;
    if (_gender == 'male') {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }

    setState(() {
      _bmi = bmi;
      _bmr = bmr;
    });
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
        title: const Text("BMI/BMR"),
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
                  _calculate();
                }),
                const SizedBox(width: 12),
                _genderButton("หญิง", _gender == 'female', () {
                  setState(() => _gender = 'female');
                  _calculate();
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

            const SizedBox(height: 24),
            _resultBox("ค่า BMI ปัจจุบัน", _bmi?.toStringAsFixed(1)),
            const SizedBox(height: 16),
            _resultBox(
              "ค่า BMR ปัจจุบัน",
              _bmr != null ? _bmr!.toStringAsFixed(0) : null,
            ),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: บันทึกค่า (เชื่อม backend / local storage)
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
          ],
        ),
      ),
    );
  }

  // ---------- Widgets ----------

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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
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
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultBox(String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value ?? "-",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
