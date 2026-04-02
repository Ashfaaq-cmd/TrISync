import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'workout.dart';

class Badge {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color iconColor;
  bool earned;
  DateTime? dateEarned;

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.iconColor,
    this.earned = false,
    this.dateEarned,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'earned': earned,
    'dateEarned': dateEarned?.toIso8601String(),
  };
}

class BadgeProvider extends ChangeNotifier {
  //Most recently earned badge
  Badge? _newlyEarned;
  Badge? get newlyEarned => _newlyEarned;
  void clearNewlyEarned() => _newlyEarned = null;
  final List<Badge> _badges = [
    //Swimming badges
    Badge(
      id: 'first_swim',
      title: 'First Splash',
      description: 'Log your first swim workout',
      icon: Icons.pool,
      color: Colors.blueAccent,
      iconColor: Colors.white,
    ),
    Badge(
      id: 'swim_1km',
      title: '1k Swimmer',
      description: 'Swim a total of 1 kilometer',
      icon: Icons.waves,
      color: const Color.fromARGB(255, 16, 80, 189),
      iconColor: Colors.white,
    ),
    Badge(
      id: 'swim_3.8km',
      title: 'Iron Swimmer',
      description: 'Swim a total of 3.8 kilometers',
      icon: Icons.water,
      color: const Color.fromARGB(255, 0, 0, 255),
      iconColor: Colors.white,
    ),
    Badge(
      id: 'swim_5km',
      title: '5k Swimmer',
      description: 'Swim a total of 5 kilometers',
      icon: Icons.water,
      color: const Color.fromARGB(255, 9, 54, 133),
      iconColor: Colors.white,
    ),
    //Cycling badges
    Badge(
      id: 'first_ride',
      title: 'First Ride',
      description: 'Log your first bike workout',
      icon: Icons.directions_bike,
      color: Colors.greenAccent,
      iconColor: Colors.white,
    ),

    Badge(
      id: 'ride_100km',
      title: 'Century Rider',
      description: 'Bike a total of 100 kilometers',
      icon: Icons.bike_scooter,
      color: const Color.fromARGB(255, 0, 128, 0),
      iconColor: Colors.white,
    ),
    Badge(
      id: 'ride_500km',
      title: '500k Rider',
      description: 'Bike a total of 500 kilometers',
      icon: Icons.electric_bike,
      color: const Color.fromARGB(255, 0, 100, 0),
      iconColor: Colors.white,
    ),
    //Running badges
    Badge(
      id: 'first_run',
      title: 'First Run',
      description: 'Log your first run workout',
      icon: Icons.directions_run,
      color: Colors.orangeAccent,
      iconColor: Colors.white,
    ),
    Badge(
      id: 'run_5km',
      title: '5k Finisher',
      description: 'Complete a 5 km run',
      icon: Icons.directions_walk,
      color: const Color.fromARGB(255, 255, 165, 0),
      iconColor: Colors.white,
    ),
    Badge(
      id: 'run_10km',
      title: '10k Warrior',
      description: 'Complete a 10 km run',
      icon: Icons.directions_run,
      color: const Color.fromARGB(255, 255, 140, 0),
      iconColor: Colors.white,
    ),
    Badge(
      id: 'run_21km',
      title: 'Half Marathoner',
      description: 'Complete a 21.1 km run',
      icon: Icons.military_tech,
      color: const Color.fromARGB(255, 255, 69, 0),
      iconColor: Colors.white,
    ),

    Badge(
      id: 'run_42km',
      title: 'Marathoner',
      description: 'Complete a 42.2 km run',
      icon: Icons.emoji_events,
      color: const Color.fromARGB(255, 255, 0, 0),
      iconColor: Colors.white,
    ),
    //Consistency badges
    Badge(
      id: '7_day_streak',
      title: '7-Day Streak',
      description: 'Log workouts 7 days in a row',
      icon: Icons.local_fire_department,
      color: Colors.purpleAccent,
      iconColor: Colors.white,
    ),
    Badge(
      id: 'all_three',
      title: 'Triathlete',
      description: 'Complete at least one workout in each discipline',
      icon: Icons.workspace_premium,
      color: Colors.amberAccent,
      iconColor: Colors.white,
    ),
  ];
  List<Badge> get badges => _badges;
  List<Badge> get earnedBadges => _badges.where((b) => b.earned).toList();
  List<Badge> get unearnedBadges => _badges.where((b) => !b.earned).toList();

  Future<void> loadBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('badges') ?? [];
    final saved = {
      for (var s in raw)
        (jsonDecode(s) as Map<String, dynamic>)['id']:
            jsonDecode(s) as Map<String, dynamic>,
    };
    for (final badge in _badges) {
      if (saved.containsKey(badge.id)) {
        badge.earned = saved[badge.id]!['earned'] ?? false;
        final dateStr = saved[badge.id]!['dateEarned'];
        badge.dateEarned = dateStr != null ? DateTime.parse(dateStr) : null;
      }
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'badges',
      _badges.map((b) => jsonEncode(b.toJson())).toList(),
    );
  }

  //Evaluate if any new badges have been earned based on the user's workouts
  Future<void> evaluate(List<WorkoutEntry> workouts) async {
    bool changed = false;
    void tryEarn(String id) {
      final badge = _badges.firstWhere((b) => b.id == id);
      if (!badge.earned) {
        badge.earned = true;
        badge.dateEarned = DateTime.now();
        _newlyEarned = badge;
        changed = true;
      }
    }

    final swims = workouts.where((w) => w.discipline == Discipline.swim);
    final rides = workouts.where((w) => w.discipline == Discipline.bike);
    final runs = workouts.where((w) => w.discipline == Discipline.run);

    if (swims.isNotEmpty) tryEarn('first_swim');
    if (swims.any((w) => w.distance >= 1000)) tryEarn('swim_1km');
    if (swims.any((w) => w.distance >= 3800)) tryEarn('swim_3.8km');
    if (swims.any((w) => w.distance >= 5000)) tryEarn('swim_5km');
    if (rides.isNotEmpty) tryEarn('first_ride');
    if (rides.any((w) => w.distance >= 100000)) tryEarn('ride_100km');
    if (rides.any((w) => w.distance >= 500000)) tryEarn('ride_500km');
    if (runs.isNotEmpty) tryEarn('first_run');
    if (runs.any((w) => w.distance >= 5000)) tryEarn('run_5km');
    if (runs.any((w) => w.distance >= 10000)) tryEarn('run_10km');
    if (runs.any((w) => w.distance >= 21100)) tryEarn('run_21km');
    if (runs.any((w) => w.distance >= 42200)) tryEarn('run_42km');
    //All three disciplines in one week
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final thisWeek = workouts.where((w) => w.date.isAfter(weekAgo)).toList();
    if (thisWeek.any((w) => w.discipline == Discipline.swim) &&
        thisWeek.any((w) => w.discipline == Discipline.bike) &&
        thisWeek.any((w) => w.discipline == Discipline.run)) {
      tryEarn('all_three');
    }
    //7 day streak
    final dates = workouts.map((w) => w.date).toList()
      ..sort((a, b) => b.compareTo(a));
    if (dates.isNotEmpty) {
      int streak = 1;
      for (int i = 1; i < dates.length; i++) {
        if (dates[i - 1].difference(dates[i]).inDays == 1) {
          streak++;
        } else if (dates[i - 1].difference(dates[i]).inDays > 1) {
          break;
        }
      }
      if (streak >= 7) tryEarn('streak_7');
    }
    if (changed) {
      await _persist();
      notifyListeners();
    }
  }
}
