import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String? _selectedGoal;

  final List<Map<String, dynamic>> _goals = [
    {
      'goal': 'Sprint',
      'distance': 'Short distance (750m swim, 20km bike, 5km run)',
      'description': 'Perfect for beginners and first timers',
      'icon': Icons.bolt,
      'color': Colors.orangeAccent,
    },
    {
      'goal': 'Olympic',
      'distance': 'Standard distance (1500m swim, 40km bike, 10km run)',
      'description': 'The classic triathlon distance',
      'icon': Icons.emoji_events,
      'color': Colors.blueAccent,
    },
    {
      'goal': 'Half Ironman',
      'distance': 'Medium distance (1.9km swim, 90km bike, 21.1km run)',
      'description': 'A challenging step up for experienced triathletes',
      'icon': Icons.whatshot,
      'color': Colors.greenAccent,
    },
    {
      'goal': 'Ironman',
      'distance': 'Long distance (3.8km swim, 180km bike, 42.2km run)',
      'description': 'The ultimate triathlon challenge for dedicated athletes',
      'icon': Icons.military_tech,
      'color': Colors.redAccent,
    },
  ];

  void _selectGoal(String goal) {
    setState(() {
      _selectedGoal = goal;
    });
  }

  void _finish() {
    if (_selectedGoal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a goal'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    final profile = Provider.of<UserProfile>(context, listen: false);
    profile.saveProfile(
      name: profile.name,
      password: profile.password,
      fitnessLevel: profile.fitnessLevel,
      raceGoal: _selectedGoal!,
    );
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Use a Column with a scrollable middle section and a pinned button
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Back button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF0077B6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Step 3 of 3',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'What is your triathlon goal?',
                      style: TextStyle(
                        color: Color(0xFF023E8A),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We will create a training plan based on your goal',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    // Goal cards
                    ..._goals.map((item) {
                      final isSelected = _selectedGoal == item['goal'];
                      return GestureDetector(
                        onTap: () => _selectGoal(item['goal']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? item['color'].withValues(alpha: 0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? item['color']
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? item['color']
                                      : item['color'].withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  item['icon'],
                                  color: isSelected
                                      ? Colors.white
                                      : item['color'],
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['goal'],
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? item['color']
                                            : const Color(0xFF023E8A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item['distance'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item['description'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_circle, color: item['color']),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Pinned finish button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _finish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Let's Go!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
