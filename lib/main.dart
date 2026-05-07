import 'package:flutter/material.dart';

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
      home: const MoodScreen(),
    );
  }
}

class Mood {
  final String name;
  final IconData icon;
  final Color color;
  final bool isPaid;

  Mood({required this.name, required this.icon, required this.color, required this.isPaid});
}

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final List<Mood> freeMoods = [
    Mood(name: 'Радость', icon: Icons.emoji_emotions, color: Colors.amber, isPaid: false),
    Mood(name: 'Спокойствие', icon: Icons.spa, color: Colors.green, isPaid: false),
    Mood(name: 'Энергия', icon: Icons.bolt, color: Colors.orange, isPaid: false),
  ];

  final List<Mood> paidMoods = [
    Mood(name: 'Романтика', icon: Icons.favorite, color: Colors.pink, isPaid: true),
    Mood(name: 'Уверенность', icon: Icons.verified, color: Colors.blue, isPaid: true),
    Mood(name: 'Творчество', icon: Icons.brush, color: Colors.purple, isPaid: true),
  ];

  bool _hasSubscription = false;

  String _getFallbackRecommendation(String mood) {
    switch (mood) {
      case 'Радость':
        return '👗 Яркое летнее платье с цветочным принтом, солнечные очки и босоножки. Цвета: жёлтый, оранжевый.';
      case 'Спокойствие':
        return '🧘‍♀️ Льняной костюм оверсайз, деревянные бусы и удобные slip-on\'ы. Цвета: небесно-голубой, песочный.';
      case 'Энергия':
        return '🏃‍♂️ Худи с леггинсами, кепка и кроссовки. Цвета: красный, ярко-синий.';
      case 'Романтика':
        return '🌸 Воздушное платье макси, тонкая цепочка и босоножки. Цвета: розовая пудра, лавандовый.';
      case 'Уверенность':
        return '👔 Костюм-двойка, массивные часы и лоферы. Цвета: чёрный, бордовый.';
      case 'Творчество':
        return '🎨 Необычное сочетание цветов, оверсайз, яркие аксессуары. Цвета: фуксия, оранжевый.';
      default:
        return 'Классический образ: джинсы, футболка, кеды.';
    }
  }

  Future<String> _getAIRecommendation(String mood) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getFallbackRecommendation(mood);
  }

  void _showOutfitRecommendation(Mood mood) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('${mood.name} ✨'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Подбираем идеальный образ...'),
          ],
        ),
      ),
    );

    String recommendation = await _getAIRecommendation(mood.name);

    if (mounted) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('${mood.name} ✨'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Вот что тебе подойдёт:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(recommendation),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отлично!'),
            ),
          ],
        ),
      );
    }
  }

  void _showPaywall() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🌟 Премиум-доступ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Открой все 6 настроений и получай персональные рекомендации:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('✓ Романтика'),
            Text('✓ Уверенность'),
            Text('✓ Творчество'),
            SizedBox(height: 10),
            Text('🎁 7 дней бесплатно', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            Text('💳 199 ₽/мес', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Позже'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showDemoPurchase();
            },
            child: const Text('Попробовать 7 дней бесплатно'),
          ),
        ],
      ),
    );
  }

  void _showDemoPurchase() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ℹ️ Демо-режим'),
        content: const Text('В реальном приложении здесь будет оформление подписки через Google Play. Сейчас это демонстрация.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  void _onMoodTap(Mood mood) {
    if (mood.isPaid && !_hasSubscription) {
      _showPaywall();
    } else {
      _showOutfitRecommendation(mood);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodStyle'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (!_hasSubscription)
            TextButton(
              onPressed: _showPaywall,
              child: const Text('Премиум', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Как ты себя чувствуешь?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Бесплатные настроения',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemCount: freeMoods.length,
              itemBuilder: (context, index) {
                final mood = freeMoods[index];
                return _MoodCard(
                  mood: mood,
                  onTap: () => _onMoodTap(mood),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Премиум-настроения',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemCount: paidMoods.length,
              itemBuilder: (context, index) {
                final mood = paidMoods[index];
                return _MoodCard(
                  mood: mood,
                  onTap: () => _onMoodTap(mood),
                  isLocked: !_hasSubscription,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  final Mood mood;
  final VoidCallback onTap;
  final bool isLocked;

  const _MoodCard({
    required this.mood,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: mood.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    mood.icon,
                    size: 40,
                    color: isLocked ? Colors.grey : mood.color,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mood.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isLocked ? Colors.grey : null,
                    ),
                  ),
                ],
              ),
              if (isLocked)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.lock,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}