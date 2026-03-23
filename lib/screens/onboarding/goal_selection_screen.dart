import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  //Tracks the selected goal
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
      'description': 'The classic triathlon distance ',
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
      email: '', // TODO: Add email input
      fitnessLevel: profile.fitnessLevel,
      raceGoal: _selectedGoal!,
    );
    //go to home screen and clear entire navigation stack so user can't go back to onboarding
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0077B6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Back button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
              // Step indicator
              const Text(
                'Step 3 of 3',
                style: TextStyle(fontSize: 14, color: Colors.white60),
              ),
              const SizedBox(height: 8),
              //Title
              Text(
                'What is your triathlon goal?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We will create a training plan based on your goal',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              //Goal options
              ..._goals.map((item) {
                final isSelected = _selectedGoal == item['goal'];
                return GestureDetector(
                  onTap: () => _selectGoal(item['goal']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white12,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white30,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isSelected ? item['color'] : Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item['icon'],
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Goal name
                              Text(
                                item['goal'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? item['color']
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              //Distance
                              Text(
                                item['distance'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.black54
                                      : Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              //Description
                              Text(
                                item['description'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.black45
                                      : Colors.white60,
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
              const Spacer(),
              //Finish button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _finish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0077B6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Let\'s Go!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
