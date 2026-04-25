import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseVideoPage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const ExerciseVideoPage({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<ExerciseVideoPage> createState() => _ExerciseVideoPageState();
}

class _ExerciseVideoPageState extends State<ExerciseVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    
    // 1. จัดการ Path ให้สะอาด (ลบช่องว่าง หรือเครื่องหมาย / ที่อาจเกินมา)
    String targetPath = widget.videoUrl.trim();
    if (targetPath.startsWith('/')) {
      targetPath = targetPath.substring(1);
    }

    print("DEBUG: Trying to load video from: $targetPath");

    // 2. ตรวจสอบเงื่อนไขแบบละเอียด
    if (targetPath.contains('assets/')) {
      print("DEBUG: Detected as ASSET video");
      // ✅ บังคับใช้ .asset
      _controller = VideoPlayerController.asset(targetPath);
    } else {
      print("DEBUG: Detected as NETWORK video");
      // 🌐 ใช้ .networkUrl
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    }

    // 3. Initialize พร้อมดักจับ Error
    _controller.initialize().then((_) {
      print("DEBUG: Video Initialized successfully");
      if (mounted) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true); // เผื่ออยากให้วนลูปท่าออกกำลังกาย
      }
    }).catchError((error) {
      // ถ้ายังพัง ตรงนี้จะบอกชัดเจนว่าพังที่ขั้นตอนนี้
      print("DEBUG: Video Init Error (Detailed): $error");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ฟังก์ชันจัดรูปแบบเวลา (00:00)
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. วิดีโอพื้นหลัง (เต็มจอ)
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(color: Colors.orange),
          ),

          // 2. Overlay ด้านบน (ปุ่มย้อนกลับ + ชื่อท่า)
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white, size: 35),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // เพื่อให้ชื่อเรื่องอยู่กลาง
              ],
            ),
          ),

          // 3. แถบควบคุมด้านล่าง (ตามรูปภาพ)
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // แถบ Progress Bar
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  colors: const VideoProgressColors(
                    playedColor: Colors.white,
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.white10,
                  ),
                ),
                
                // แสดงเวลา
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_controller.value.position),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      "-${_formatDuration(_controller.value.duration - _controller.value.position)}",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),

                // ปุ่ม Play/Pause และ Skip
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ปุ่มย้อนกลับ 10 วิ (Optional) หรือ Skip Back
                    _controlButton(Icons.skip_previous, () {
                      _controller.seekTo(_controller.value.position - const Duration(seconds: 10));
                    }),
                    const SizedBox(width: 25),
                    
                    // ปุ่ม Play/Pause วงกลมส้ม
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying ? _controller.pause() : _controller.play();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF7A1A), // สีส้มตามรูป
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 25),
                    // ปุ่มไปข้างหน้า 10 วิ (Optional) หรือ Skip Forward
                    _controlButton(Icons.skip_next, () {
                      _controller.seekTo(_controller.value.position + const Duration(seconds: 10));
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget ช่วยสร้างปุ่มขนาบข้าง
  Widget _controlButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 1.5),
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}