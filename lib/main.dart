import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';

void main() {
  runApp(const MoodStyleApp());
}

class MoodStyleApp extends StatelessWidget {
  const MoodStyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodStyle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CheckFirstTime(),
    );
  }
}

class CheckFirstTime extends StatefulWidget {
  const CheckFirstTime({super.key});

  @override
  State<CheckFirstTime> createState() => _CheckFirstTimeState();
}

class _CheckFirstTimeState extends State<CheckFirstTime> {
  bool? showOnboarding;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_completed') ?? false;

    if (mounted) {
      setState(() {
        showOnboarding = !completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showOnboarding == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (showOnboarding == true) {
      return const OnboardingScreen();
    } else {
      return const MoodScreen();
    }
  }
}

// ВРЕМЕННЫЙ ЭКРАН (пока не перенесли ваш старый код)
// СЮДА ПОТОМ ВСТАВИТЕ ВЕСЬ ВАШ КОД С КАРТОЧКАМИ НАСТРОЕНИЙ
class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodStyle'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text(
          'Здесь будет ваш главный экран с настроениями',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
