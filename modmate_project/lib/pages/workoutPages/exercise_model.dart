class ExerciseModel {
  final String id;
  final String bodyPartKey;
  final String title;
  final String subtitle;
  final String imagePath;
  final String description;
  final List<String> steps;
  final String shortDescription;
  final String muscleImagePath;
  final List<String> targetMuscles;
  final List<String> equipments;
  final List<String> equipmentImages;
  final String videoUrl;
  final String arModelPath;

  const ExerciseModel({
    required this.id,
    required this.bodyPartKey,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.description,
    required this.steps,
    required this.shortDescription,
    required this.muscleImagePath,
    required this.targetMuscles,
    required this.equipments,
    required this.equipmentImages,
    required this.videoUrl,
    required this.arModelPath,
  });
}