import 'package:flutter/material.dart';
import 'package:first_project/screens/splash_screen_first.dart';
void main() {
  runApp(const SmartTrafficApp());
}

class SmartTrafficApp extends StatelessWidget {
  const SmartTrafficApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Traffic Management',
      debugShowCheckedModeBanner: false, // لإزالة شريط "Debug"
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // خلفية كل الصفحات سوداء
        // تحديد اللون الأساسي للتطبيق كالأخضر النيون
        primaryColor: const Color(0xFFCCFF00), 
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFCCFF00),
        ),
        // تخصيص خطوط بيضاء بشكل افتراضي
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const SplashScreen(), // تحديد شاشة البداية
    );
  }
}