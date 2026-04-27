import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

  Future<String> _copyAssetToLocal(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final dir = await getTemporaryDirectory();

    final file = File('${dir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

    return file.path;
  }

  // Future<void> _addModel() async {
  //   try {
  //     print('🔵 asset path: ${widget.modelPath}');

  //     final localPath = await _copyAssetToLocal(widget.modelPath);

  //     print('📁 local path: $localPath');

  //     final node = ARKitReferenceNode(
  //       url: localPath,
  //       position: vector.Vector3(0, -5, -6),
  //       scale: vector.Vector3(1, 1, 1),
  //       eulerAngles: vector.Vector3(0, 5, 0), // เอา Z ออกก่อน
  //     );

  //     await arkitController?.add(node);


  //     print('✅ เพิ่ม node สำเร็จ');
  //   } catch (e) {
  //     print('❌ Error: $e');
  //   }
  // }

  String? currentNodeName;

  Future<void> _addModelOnPlane(Matrix4 transform) async {
    final localPath = await _copyAssetToLocal(widget.modelPath);

    if (currentNodeName != null) {
      arkitController?.remove(currentNodeName!);
    }

    currentNodeName = 'exercise_model';

    final position = vector.Vector3(
      transform.storage[12],
      transform.storage[13] - 0.08,
      transform.storage[14],
    );

    final node = ARKitReferenceNode(
      name: currentNodeName,
      url: localPath,
      position: position,
      scale: vector.Vector3(0.8, 0.8, 0.8),
      eulerAngles: vector.Vector3(0, 5, 0),
    );

    await arkitController?.add(node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ARKitSceneView(
        planeDetection: ARPlaneDetection.horizontal,
        enableTapRecognizer: true,

        showFeaturePoints: false,
        showStatistics: false,
        showWorldOrigin: false,
        onARKitViewCreated: (controller) {
          arkitController = controller;

          arkitController?.onARTap = (hits) {
            final planeHits = hits.where(
              (hit) => hit.type == ARKitHitTestResultType.existingPlaneUsingExtent,
            );

            if (planeHits.isNotEmpty) {
              _addModelOnPlane(planeHits.first.worldTransform);
            }
          };
        },
      )
    );
  }
}