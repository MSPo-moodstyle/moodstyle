import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // Импортируем главный экран

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? selectedGender;
  String? selectedAgeGroup;

  final List<String> genders = ['Женский', 'Мужской', 'Не указывать'];
  final List<String> ageGroups = ['16-25', '26-40', '40+'];

  Future<void> _saveAndContinue() async {
    if (selectedGender == null || selectedAgeGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите пол и возраст')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', selectedGender!);
    await prefs.setString('age_group', selectedAgeGroup!);
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MoodScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добро пожаловать!'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Давайте познакомимся, чтобы подбирать стиль точнее',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            const Text(
              'Ваш пол:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: genders.map((gender) {
                return ChoiceChip(
                  label: Text(gender),
                  selected: selectedGender == gender,
                  onSelected: (selected) {
                    setState(() {
                      selectedGender = selected ? gender : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Text(
              'Ваш возраст:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: ageGroups.map((age) {
                return ChoiceChip(
                  label: Text(age),
                  selected: selectedAgeGroup == age,
                  onSelected: (selected) {
                    setState(() {
                      selectedAgeGroup = selected ? age : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Продолжить',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
