import 'package:flutter/material.dart';
import 'exercise_detail_page.dart';
import 'exercise_model.dart';

class ExerciseActionPage extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseActionPage({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// background image
          Image.asset(
            exercise.imagePath,
            fit: BoxFit.cover,
          ),

          /// dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.88),
                  Colors.black,
                ],
                stops: const [0.0, 0.35, 0.72, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  const Spacer(),

                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _bodyPartTag(exercise.bodyPartKey),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Center(
                    child: Text(
                      exercise.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Center(
                    child: Text(
                      exercise.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExerciseDetailPage(
                                    exercise: exercise,
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFFFF7A12),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'ดูข้อมูล',
                              style: TextStyle(
                                color: Color(0xFFFF7A12),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExerciseArPage(
                                    exercise: exercise,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7A12),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'ดู AR ที่นี่',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
}

class ExerciseArPage extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseArPage({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070B16),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'AR Exercise',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text(
          'หน้า AR ของ\n${exercise.title}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}