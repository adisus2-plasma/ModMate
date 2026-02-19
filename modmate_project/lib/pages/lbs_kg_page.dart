import 'package:flutter/material.dart';

class LbsKgConvertPage extends StatefulWidget {
  const LbsKgConvertPage({super.key});

  @override
  State<LbsKgConvertPage> createState() => _LbsKgConvertPageState();
}

class _LbsKgConvertPageState extends State<LbsKgConvertPage> {
  // false = lbs -> kg (ซ้ายตามภาพ)
  // true  = kg  -> lbs (ขวาตามภาพ)
  bool _reverse = false;
  final TextEditingController _controller = TextEditingController();


double get _value =>
  double.tryParse(_controller.text.trim()) ?? 0;
  static const Color kBg = Colors.black;
  static const Color kCard = Color(0xFF23242A);
  static const Color kCardBorder = Color(0xFF3A3B40);
  static const Color kAccent = Color(0xFFFF7A1A);
  static const Color kTextDim = Color(0xFFB7B7B7);

  double get _result {
    // lbs -> kg : kg = lbs * 0.45359237
    // kg -> lbs : lbs = kg / 0.45359237
    if (!_reverse) return _value * 0.45359237;
    return _value / 0.45359237;
  }

  String get _bigUnit => _reverse ? "kg" : "lbs";
  String get _smallUnit => _reverse ? "lbs" : "kg";

  String get _headline {
    return _reverse
        ? "แปลงหน่วย\nkg(กิโลกรัม) - lbs(ปอนด์)"
        : "แปลงหน่วย\nlbs(ปอนด์) - kg(กิโลกรัม)";
  }

  String get _subline {
    return _reverse
        ? "หน่วย กิโลกรัม (kg) เป็น ปอนด์ (lbs)"
        : "หน่วย ปอนด์ (lbs) เป็น กิโลกรัม (kg)";
  }

  void _toggle() {
    setState(() {
      _reverse = !_reverse;
      _controller.text = "0"; // รีเซ็ตค่าให้เหมือน UX ภาพ
    });
  }

  void _inc() => setState(() => _controller.text = (_value + 1).clamp(0, 999999).toStringAsFixed(0));
  void _dec() => setState(() => _controller.text = (_value - 1).clamp(0, 999999).toStringAsFixed(0));

  

  @override
  Widget build(BuildContext context) {
    final resultText = _value == 0 ? "____" : _result.toStringAsFixed(2);

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Top bar (back + title) =====
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                  ),
                  const Spacer(),
                  const Text(
                    "แปลงหน่วย",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // balance with back button
                ],
              ),
              const SizedBox(height: 10),

              // ===== Logo placeholder (ตามภาพ) =====
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Image.asset(
                  "assets/logo.png",
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, color: Colors.white70),
                ),
              ),

              const SizedBox(height: 18),

              // ===== Headline =====
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  _headline,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
              ),

              const SizedBox(height: 26),

              Center(
                child: Text(
                  _subline,
                  style: const TextStyle(color: kTextDim, fontWeight: FontWeight.w700),
                ),
              ),

              const SizedBox(height: 18),

              // ===== Converter Card =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 22),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: kCardBorder),
                ),
                child: Column(
                  children: [
                    // +/- row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CircleBtn(
                          icon: Icons.remove,
                          onTap: () {
                            final v = _value - 1;
                            _controller.text = (v < 0 ? 0 : v).toStringAsFixed(0);
                            setState(() {});
                          },
                        ),

                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                controller: _controller,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                ),
                                decoration: InputDecoration(
                                  hintText: "0",
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.25),
                                    fontSize: 52,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _bigUnit,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.35),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),

                        _CircleBtn(
                          icon: Icons.add,
                          onTap: () {
                            final v = _value + 1;
                            _controller.text = v.toStringAsFixed(0);
                            setState(() {});
                          },
                        ),
                      ],
                    ),


                    const SizedBox(height: 10),

                    // orange line
                    Container(
                      height: 2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kAccent,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // result text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "ได้เท่ากับ ",
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                        Text(
                          resultText,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                        Text(
                          " $_smallUnit",
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ===== Switch button =====
              Center(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _toggle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    icon: const Icon(Icons.sync, size: 20),
                    label: const Text(
                      "เปลี่ยนหน่วย",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
          color: Colors.transparent,
        ),
        child: Icon(icon, color: Colors.white54),
      ),
    );
  }
}
