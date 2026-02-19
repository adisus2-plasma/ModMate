import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding/onboarding_page_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _goToIntro();
  }

  void _goToIntro() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6A00), // สีส้ม
      body: SafeArea(
        child: Stack(
          children: [

            /// โลโก้กลางจอ
            Center(
              child: Image.asset(
                "assets/logo.png", // 👈 เปลี่ยนเป็นโลโก้เธอ
                width: 120,
              ),
            ),

            /// Loading ด้านล่าง
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.9),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
