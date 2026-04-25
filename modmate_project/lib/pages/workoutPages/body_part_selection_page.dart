import 'package:flutter/material.dart';
import 'exercise_list_page.dart';

enum BodyPart {
  shoulder,
  arm,
  chest,
  back,
  leg,
  core,
}

class BodyPartSelectionPage extends StatefulWidget {
  const BodyPartSelectionPage({super.key});

  @override
  State<BodyPartSelectionPage> createState() => _BodyPartSelectionPageState();
}

class _BodyPartSelectionPageState extends State<BodyPartSelectionPage> {
  BodyPart? selectedPart;

  static const Color bgColor = Color(0xFF070B16);
  static const Color borderColor = Color(0xFF2E3550);
  static const Color activeColor = Color(0xFFFF7A12);

  void onSelectPart(BodyPart part) {
    setState(() {
      selectedPart = part;
    });
  }

  String getBodyPartLabel(BodyPart part) {
    switch (part) {
      case BodyPart.shoulder:
        return 'ไหล่';
      case BodyPart.arm:
        return 'แขน';
      case BodyPart.chest:
        return 'อก';
      case BodyPart.back:
        return 'หลัง';
      case BodyPart.leg:
        return 'ขา';
      case BodyPart.core:
        return 'แกนกลางลำตัว';
    }
  }

  String getBodyPartKey(BodyPart part) {
  switch (part) {
    case BodyPart.shoulder:
      return 'shoulder';
    case BodyPart.arm:
      return 'arm';
    case BodyPart.chest:
      return 'chest';
    case BodyPart.back:
      return 'back';
    case BodyPart.leg:
      return 'leg';
    case BodyPart.core:
      return 'core';
  }
}

  String getBodyImage() {
    switch (selectedPart) {
      case BodyPart.shoulder:
        return 'assets/body/shoulder.png';
      case BodyPart.arm:
        return 'assets/body/arm.png';
      case BodyPart.chest:
        return 'assets/body/chest.png';
      case BodyPart.back:
        return 'assets/body/back.png';
      case BodyPart.leg:
        return 'assets/body/leg.png';
      case BodyPart.core:
        return 'assets/body/core.png';
      case null:
        return 'assets/body/fullbody.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canGoNext = selectedPart != null;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              /// top section
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Image.asset(
                'assets/logo.png',
                width: 58,
                height: 58,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 10),

              const Text(
                'ท่าออกกำลังกายเวทเทรนนิ่ง',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'เวทเทรนนิ่ง (Weight training) หรือการฝึกด้วยน้ำหนัก\n'
                  'เป็นการออกกำลังกายที่ใช้แรงต้านจากอุปกรณ์ เช่น ดัมเบลล์\n'
                  'เพื่อกระตุ้นให้กล้ามเนื้อเกิดการปรับตัวอย่างต่อเนื่อง',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// middle section
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// body image
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Image.asset(
                              getBodyImage(),
                              fit: BoxFit.contain,
                              height: constraints.maxHeight * 0.95,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// buttons
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _bodyPartButton(BodyPart.shoulder),
                            const SizedBox(height: 10),
                            _bodyPartButton(BodyPart.arm),
                            const SizedBox(height: 10),
                            _bodyPartButton(BodyPart.chest),
                            const SizedBox(height: 10),
                            _bodyPartButton(BodyPart.back),
                            const SizedBox(height: 10),
                            _bodyPartButton(BodyPart.leg),
                            const SizedBox(height: 10),
                            _bodyPartButton(BodyPart.core, isWide: true),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// bottom button
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 170,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: canGoNext
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExerciseListPage(
                                  bodyPartLabel: getBodyPartLabel(selectedPart!),
                                  bodyPartKey: getBodyPartKey(selectedPart!),
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          canGoNext ? activeColor : Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: canGoNext
                              ? activeColor
                              : Colors.white.withOpacity(0.85),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'ถัดไป',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_rounded, size: 28),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyPartButton(BodyPart part, {bool isWide = false}) {
    final bool isSelected = selectedPart == part;

    return SizedBox(
      width: isWide ? 150 : 92,
      height: 52,
      child: OutlinedButton(
        onPressed: () => onSelectPart(part),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor:
              isSelected ? activeColor.withOpacity(0.18) : Colors.transparent,
          side: BorderSide(
            color: isSelected ? activeColor : borderColor,
            width: 1.8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Text(
          getBodyPartLabel(part),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? activeColor : Colors.white,
            fontSize: isWide ? 14 : 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}