import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas que Ficam',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.titleLarge,
          displayMedium: AppTextStyles.titleMedium,
          displaySmall: AppTextStyles.titleSmall,
          bodyLarge: AppTextStyles.bodyLarge,
          titleMedium: AppTextStyles.labelMedium,
          titleSmall: AppTextStyles.labelSmall,
          labelLarge: AppTextStyles.rockSaltTitle,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset('assets/images/nqf_logo.png'),
      ),
    );
  }
}
