import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart'; // ถ้าตัวนี้ไม่แดง ที่เหลือจะไม่แดงครับ
import 'package:vector_math/vector_math_64.dart' as vector;

class ExerciseARPage extends StatefulWidget {
  final String title;
  final String modelPath;

  const ExerciseARPage({super.key, required this.title, required this.modelPath});

  @override
  State<ExerciseARPage> createState() => _ExerciseARPageState();
}

class _ExerciseARPageState extends State<ExerciseARPage> {
  late ARKitController arkitController;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ARKitSceneView(
        planeDetection: ARPlaneDetection.horizontalAndVertical,
        onARKitViewCreated: (controller) {
          arkitController = controller;
        },
      ),
    );
  }
}