import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../models/training_plan.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  int _selectedWeek = 0;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfile>();
    final plan = PlanRepository.getPlan(profile.fitnessLevel, profile.raceGoal);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Training Plan',
          style: TextStyle(
            color: Color(0xFF023E8A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan description
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${plan.level} · ${plan.goal} Triathlon',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023E8A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plan.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Week selector tabs
          Container(
            color: Colors.white,
            child: SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: plan.weeks.length,
                itemBuilder: (context, i) {
                  final isSelected = _selectedWeek == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedWeek = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8, bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0077B6)
                            : const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0077B6)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        'Week ${i + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF023E8A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Session list for selected week
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Week theme label
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF023E8A).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.flag_outlined,
                        size: 16,
                        color: Color(0xFF023E8A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        plan.weeks[_selectedWeek].theme,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF023E8A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...plan.weeks[_selectedWeek].sessions.asMap().entries.map(
                  (e) => _SessionCard(day: e.key + 1, session: e.value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final int day;
  final TrainingSession session;
  const _SessionCard({required this.day, required this.session});

  Color get _color {
    switch (session.discipline) {
      case 'Swim':
        return const Color(0xFF48CAE4);
      case 'Bike':
        return const Color(0xFF0096C7);
      case 'Run':
        return const Color(0xFF023E8A);
      default:
        return Colors.grey;
    }
  }

  IconData get _icon {
    switch (session.discipline) {
      case 'Swim':
        return Icons.pool;
      case 'Bike':
        return Icons.directions_bike;
      case 'Run':
        return Icons.directions_run;
      default:
        return Icons.self_improvement;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: session.isRest ? const Color(0xFFF5F7FA) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: session.isRest
              ? Colors.grey.shade200
              : _color.withValues(alpha: 0.3),
        ),
        boxShadow: session.isRest
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          // Day number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: session.isRest
                  ? Colors.grey.shade200
                  : _color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'D$day',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: session.isRest ? Colors.grey : _color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Discipline icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: session.isRest
                  ? Colors.grey.shade200
                  : _color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _icon,
              color: session.isRest ? Colors.grey : _color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.isRest ? 'Rest Day' : session.discipline,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: session.isRest
                        ? Colors.grey
                        : const Color(0xFF023E8A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  session.description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Distance and duration
          if (!session.isRest)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  session.distance,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _color,
                  ),
                ),
                Text(
                  session.duration,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
