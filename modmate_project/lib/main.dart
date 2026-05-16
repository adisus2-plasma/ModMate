import 'package:flutter/material.dart';
import 'splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final fadeTransitions = PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        for (final p in TargetPlatform.values) p: const _FadePageTransitionsBuilder(),
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(pageTransitionsTheme: fadeTransitions),
      home: const SplashPage(), // ✅ หน้าแรก
    );
  }
}

class _FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const _FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
