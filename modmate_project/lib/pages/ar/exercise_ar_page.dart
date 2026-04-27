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
  String? currentNodeName;
  bool _showInstructions = true;

  @override
  void initState() {
    super.initState();
    // ซ่อน instruction หลัง 5 วิ
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _showInstructions = false);
    });
  }

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

  Future<void> _addModelOnPlane(Matrix4 transform) async {
    final localPath = await _copyAssetToLocal(widget.modelPath);
    if (currentNodeName != null) {
      arkitController.remove(currentNodeName!);
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
    await arkitController.add(node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // AR View
          ARKitSceneView(
            planeDetection: ARPlaneDetection.horizontal,
            enableTapRecognizer: true,
            showFeaturePoints: false,
            showStatistics: false,
            showWorldOrigin: false,
            onARKitViewCreated: (controller) {
              arkitController = controller;
              arkitController.onARTap = (hits) {
                final planeHits = hits.where(
                  (hit) => hit.type == ARKitHitTestResultType.existingPlaneUsingExtent,
                );
                if (planeHits.isNotEmpty) {
                  _addModelOnPlane(planeHits.first.worldTransform);
                }
              };
            },
          ),

          // ชื่อท่า ด้านบน center ไม่มีแทบดำ
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ],
            ),
          ),

          // Instruction text ตอนเข้ามา 5 วิ
          if (_showInstructions)
            Positioned(
              bottom: 80,
              left: 24,
              right: 24,
              child: AnimatedOpacity(
                opacity: _showInstructions ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFF7A12).withOpacity(0.8),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.videocam_rounded, color: Color(0xFFFF7A12), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'โปรดถือกล้องให้นิ่ง',
                            style: TextStyle(
                              color: Color(0xFFFF7A12),
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.touch_app_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'จิ้มตามสิ่งแวดล้อมเพื่อดู AR 3D model',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}