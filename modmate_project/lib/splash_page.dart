import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _OnboardingPage();
}

class _OnboardingPage extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    // ✅ ตรงนี้ใส่ logic "โหลดก่อนเข้าแอป" ได้จริง เช่น:
    // - อ่าน token / login status
    // - โหลด config จาก server
    // - preload assets
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            // ✅ ถ้ามีโลโก้จริงให้ใช้ Image.asset(...)
            Icon(Icons.local_florist, size: 88),
            SizedBox(height: 24),
            Text("Loading", style: TextStyle(fontSize: 22)),
            SizedBox(height: 16),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}
