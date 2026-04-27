import 'package:flutter/material.dart';
import 'package:modmate_project/pages/workoutPages/exercise_video_page.dart';
import 'exercise_action_page.dart';
import 'exercise_model.dart';
import '../ar/exercise_ar_page.dart';

class ExerciseDetailPage extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseDetailPage({
    super.key,
    required this.exercise,
  });

  static const Color bgColor = Color(0xFF000000);
  static const Color panelColor = Color(0xFF141720);
  static const Color borderColor = Color(0xFF303445);
  static const Color orangeColor = Color(0xFFFF7A12);
  static const Color brownColor = Color(0xFF5C1D00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroTopSection(exercise: exercise),
                  Transform.translate(
                    offset: const Offset(0, -38),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: _FloatingInfoCard(exercise: exercise),
                        ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: _DetailContent(exercise: exercise),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
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

class _HeroTopSection extends StatelessWidget {
  final ExerciseModel exercise;

  const _HeroTopSection({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            exercise.imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.05),
                  Color.fromRGBO(0, 0, 0, 0.15),
                  Color.fromRGBO(0, 0, 0, 0.35),
                  Color.fromRGBO(0, 0, 0, 0.55),
                ],
                stops: [0.0, 0.35, 0.7, 1.0],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      exercise.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingInfoCard extends StatelessWidget {
  final ExerciseModel exercise;

  const _FloatingInfoCard({required this.exercise});

  String _bodyPartTag(String key) {
    switch (key) {
      case 'chest':
        return 'Chest';
      case 'shoulder':
        return 'Shoulder';
      case 'arm':
        return 'Arm';
      case 'back':
        return 'Back';
      case 'leg':
        return 'Leg';
      case 'core':
        return 'Core';
      default:
        return 'Exercise';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: ExerciseDetailPage.panelColor,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: ExerciseDetailPage.borderColor,
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.fitness_center_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _bodyPartTag(exercise.bodyPartKey),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Text(
            exercise.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            exercise.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 58,
                  child: ElevatedButton(
                            onPressed: () {
                              print('🟠 กดปุ่ม AR: ${exercise.arModelPath}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExerciseARPage(
                                    title: exercise.title,
                                    // ✅ ดึง Path แบบ Dynamic จาก Object exercise ของท่านั้นๆ
                                    modelPath: exercise.arModelPath, 
                                  ),
                                ),
                              );
                            },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: ExerciseDetailPage.orangeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'ดู AR ที่นี่',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 58,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseVideoPage(
                            videoUrl: exercise.videoUrl, 
                            title: exercise.title)
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: ExerciseDetailPage.brownColor,
                      foregroundColor: ExerciseDetailPage.orangeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.play_circle_outline_rounded, size: 24),
                    label: const Text(
                      'ตัวอย่าง',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final ExerciseModel exercise;

  const _DetailContent({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          exercise.shortDescription,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'วิธีการเล่น',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        ...exercise.steps.map(
          (step) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                Expanded(
                  child: Text(
                    step,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'บริเวณกล้ามเนื้อที่ทำงาน',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        _MuscleSection(
          muscleImagePath: exercise.muscleImagePath,
          muscles: exercise.targetMuscles,
        ),
        const SizedBox(height: 28),
        const Text(
          'อุปกรณ์ที่ใช้',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
          _EquipmentsSection(equipments: exercise.equipments, equipmentImages: exercise.equipmentImages),
      ],
    );
  }
}

class _MuscleSection extends StatelessWidget {
  final String muscleImagePath;
  final List<String> muscles;

  const _MuscleSection({
    required this.muscleImagePath,
    required this.muscles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF2A2E3A),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              muscleImagePath,
              width: double.infinity,
              height: 190,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(muscles.length, (index) {
            final muscle = muscles[index];
            return Column(
              children: [
                Row(
                  children: [
                    const Text(
                      '•  ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        muscle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 4,
                      backgroundColor: Color(0xFFFF8B25),
                    ),
                  ],
                ),
                if (index != muscles.length - 1)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 1,
                    color: const Color(0xFF2A2E3A),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _EquipmentsSection extends StatelessWidget {
  final List<String> equipments;
  final List<String> equipmentImages;

  const _EquipmentsSection({
    required this.equipments,
    required this.equipmentImages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(equipments.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF141720),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF2A2E3A),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 👇 ICON IMAGE
                  Container(
                    width: 46,
                    height: 46,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      equipmentImages[index],
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Text(
                    equipments[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}