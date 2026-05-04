import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../models/workout.dart';
import '../models/badge_model.dart';
import '../services/notification_service.dart';
import 'log_workout_screen.dart';
import 'plan_screen.dart';
import 'progress_screen.dart';
import 'badges_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Capture providers before async gap to avoid BuildContext warnings
    final workoutProvider = context.read<WorkoutProvider>();
    final badgeProvider = context.read<BadgeProvider>();
    Future.microtask(() {
      workoutProvider.loadWorkouts();
      badgeProvider.loadBadges();
    });
  }

  void navigateTo(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    // IndexedStack keeps all screens alive so state is not lost when switching tabs
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeDashboard(onNavigate: navigateTo),
          const PlanScreen(),
          const LogWorkoutScreen(),
          const ProgressScreen(),
          const BadgesScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0077B6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium_outlined),
            activeIcon: Icon(Icons.workspace_premium),
            label: 'Badges',
          ),
        ],
      ),
    );
  }
}

//  Home Dashboard
class _HomeDashboard extends StatelessWidget {
  final void Function(int) onNavigate;
  const _HomeDashboard({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfile>();
    final workouts = context.watch<WorkoutProvider>();
    final badges = context.watch<BadgeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${profile.name}!',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF023E8A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ready to crush your next workout?',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF023E8A),
                    child: Text(
                      profile.name.isNotEmpty
                          ? profile.name[0].toUpperCase()
                          : 'T',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Motivate with a daily quote
              const _DailyMotivationCard(),

              const SizedBox(height: 16),
              const _GamificationCard(),

              const SizedBox(height: 16),
              const _DailyChallengeCard(),

              const SizedBox(height: 20),

              // ── Profile card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF023E8A), Color(0xFF0077B6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Training Profile',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${profile.raceGoal} Triathlon',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _chip(profile.fitnessLevel),
                        const SizedBox(width: 8),
                        _chip('${workouts.totalWorkouts} sessions'),
                        const SizedBox(width: 8),
                        _chip('${badges.earnedBadges.length} badges'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── This week summary
              const Text(
                'This Week',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023E8A),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: Discipline.values.map((d) {
                  final count = workouts.weeklyWorkouts
                      .where((w) => w.discipline == d)
                      .length;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: d != Discipline.run ? 10 : 0,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            d.icon,
                            color: const Color(0xFF0077B6),
                            size: 22,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF023E8A),
                            ),
                          ),
                          Text(
                            d.label.split('').take(4).join(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // ── Quick actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023E8A),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.add_circle,
                      label: 'Log Workout',
                      color: const Color(0xFF0096C7),
                      onTap: () => onNavigate(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.calendar_today,
                      label: 'My Plan',
                      color: const Color(0xFF023E8A),
                      onTap: () => onNavigate(1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.bar_chart,
                      label: 'Progress',
                      color: const Color(0xFF0077B6),
                      onTap: () => onNavigate(3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.workspace_premium,
                      label: 'Badges',
                      color: const Color(0xFF48CAE4),
                      onTap: () => onNavigate(4),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Recent workouts ──────────────────────────
              const Text(
                'Recent Workouts',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023E8A),
                ),
              ),
              const SizedBox(height: 12),

              if (workouts.recentWorkouts.isEmpty)
                _EmptyWorkouts(onTap: () => onNavigate(2))
              else
                ...workouts.recentWorkouts.map(
                  (w) => _RecentWorkoutTile(workout: w),
                ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _GamificationCard extends StatelessWidget {
  const _GamificationCard();

  @override
  Widget build(BuildContext context) {
    final badges = context.watch<BadgeProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF48CAE4).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFF48CAE4),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Training Level',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Level ${badges.level}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023E8A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '${badges.xp} XP • ${badges.xpForNextLevel} XP to Level ${badges.level + 1}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: badges.levelProgress,
              minHeight: 10,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF48CAE4),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            badges.levelProgress >= 1.0
                ? 'Ready for the next level!'
                : 'Keep training to reach the next milestone.',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _DailyChallengeCard extends StatelessWidget {
  const _DailyChallengeCard();

  @override
  Widget build(BuildContext context) {
    final badges = context.watch<BadgeProvider>();
    final challenge = badges.todayChallenge;

    if (challenge == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: challenge.color.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: challenge.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(challenge.icon, color: challenge.color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today\'s Challenge',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      challenge.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF023E8A),
                      ),
                    ),
                  ],
                ),
              ),
              if (challenge.completed)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            challenge.description,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: (challenge.progress / challenge.targetValue).clamp(
                      0.0,
                      1.0,
                    ),
                    minHeight: 12,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(challenge.color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${challenge.progress}/${challenge.targetValue}${challenge.unit}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023E8A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyMotivationCard extends StatefulWidget {
  const _DailyMotivationCard();

  @override
  State<_DailyMotivationCard> createState() => _DailyMotivationCardState();
}

class _DailyMotivationCardState extends State<_DailyMotivationCard> {
  late Future<String> _quoteFuture;

  @override
  void initState() {
    super.initState();
    _quoteFuture = NotificationService.instance.getDailyQuote();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _quoteFuture,
      builder: (context, snapshot) {
        final quote = snapshot.data;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF48CAE4), Color(0xFF023E8A)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Today’s Motivation',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (snapshot.connectionState == ConnectionState.waiting)
                const SizedBox(
                  height: 72,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              else
                Text(
                  quote ??
                      'Fuel your day with a strong swim, a smooth ride, and a fast run. The grind pays off.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ── Empty state when no workouts logged yet ───────────────
class _EmptyWorkouts extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyWorkouts({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF0077B6).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.fitness_center, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            const Text(
              'No workouts logged yet',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap here to log your first session',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single recent workout row ─────────────────────────────
class _RecentWorkoutTile extends StatelessWidget {
  final WorkoutEntry workout;
  const _RecentWorkoutTile({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF0077B6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              workout.discipline.icon,
              color: const Color(0xFF0077B6),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.discipline.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023E8A),
                  ),
                ),
                Text(
                  '${workout.distanceDisplay} · ${workout.durationMinutes} min',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${workout.date.day}/${workout.date.month}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ── Quick action card ─────────────────────────────────────
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF023E8A),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
