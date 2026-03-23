import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';

class LevelAssesmentScreen extends StatefulWidget {
  const LevelAssesmentScreen({super.key});

  @override
  State<LevelAssesmentScreen> createState() => _LevelAssesmentScreenState();
}

class _LevelAssesmentScreenState extends State<LevelAssesmentScreen> {
  String? _selectedLevel;

  final List<Map<String, dynamic>> _levels = [
    {
      'level': 'Beginner',
      'description': 'New to triathlon or just getting started',
      'icon': Icons.directions_walk,
    },
    {
      'level': 'Intermediate',
      'description':
          'Have completed at least one triathlon and train regularly',
      'icon': Icons.directions_run,
    },
    {
      'level': 'Advanced',
      'description':
          'Experienced triathlete with multiple races under your belt',
      'icon': Icons.flash_on,
    },
  ];

  void _selectLevel(String level) {
    setState(() {
      _selectedLevel = level;
    });
  }

  void _continue() {
    if (_selectedLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your fitness level'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    final profile = Provider.of<UserProfile>(context, listen: false);
    profile.fitnessLevel = _selectedLevel!;
    Navigator.pushNamed(context, '/goal-selection');
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProfile>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
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
                      'Step 2 of 3',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hi ${profile.name}!',
                      style: const TextStyle(
                        color: Color(0xFF023E8A),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'What is your current fitness level?',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    ..._levels.map((item) {
                      final isSelected = _selectedLevel == item['level'];
                      return GestureDetector(
                        onTap: () => _selectLevel(item['level']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0077B6).withValues(alpha: 0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0077B6)
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
                                      ? const Color(0xFF0077B6)
                                      : const Color(
                                          0xFF0077B6,
                                        ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  item['icon'],
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF0077B6),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['level'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? const Color(0xFF0077B6)
                                            : const Color(0xFF023E8A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['description'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF0077B6),
                                ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continue',
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
