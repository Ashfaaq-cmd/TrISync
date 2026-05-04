import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'workout.dart';

class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final int targetValue;
  final String unit;
  final Discipline? discipline;
  final IconData icon;
  final Color color;
  bool completed;
  int progress;

  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.unit,
    this.discipline,
    required this.icon,
    required this.color,
    this.completed = false,
    this.progress = 0,
  });
}

class AppBadge {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color iconColor;
  bool earned;
  DateTime? earnedDate;

  AppBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.iconColor = Colors.white,
    this.earned = false,
    this.earnedDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'earned': earned,
    'earnedDate': earnedDate?.toIso8601String(),
  };
}

class BadgeProvider extends ChangeNotifier {
  AppBadge? _newlyEarned;
  int _xp = 0;
  int _level = 1;
  int? _newlyLevelUp;
  DailyChallenge? _todayChallenge;

  AppBadge? get newlyEarned => _newlyEarned;
  int get xp => _xp;
  int get level => _level;
  int? get newlyLevelUp => _newlyLevelUp;
  DailyChallenge? get todayChallenge => _todayChallenge;

  double get levelProgress {
    final nextXp = xpForNextLevel;
    return nextXp == 0 ? 0 : (xp / nextXp).clamp(0.0, 1.0);
  }

  int get xpForNextLevel => _xpThresholdForLevel(_level + 1);

  void clearNewlyEarned() => _newlyEarned = null;
  void clearNewlyLevelUp() => _newlyLevelUp = null;

  final List<AppBadge> _badges = [
    // Swim
    AppBadge(
      id: 'first_swim',
      title: 'First Splash',
      description: 'Log your first swim session',
      icon: Icons.pool,
      color: const Color(0xFF0096C7),
    ),
    AppBadge(
      id: 'swim_1km',
      title: '1K Swimmer',
      description: 'Swim 1 km in a single session',
      icon: Icons.waves,
      color: const Color(0xFF0077B6),
    ),
    AppBadge(
      id: 'swim_2500m',
      title: 'Open Water',
      description: 'Swim 2.5 km in a single session',
      icon: Icons.water,
      color: const Color(0xFF023E8A),
    ),

    // Cycling
    AppBadge(
      id: 'first_ride',
      title: 'First Ride',
      description: 'Log your first cycling session',
      icon: Icons.directions_bike,
      color: const Color(0xFF0096C7),
    ),
    AppBadge(
      id: 'ride_20km',
      title: '20K Rider',
      description: 'Complete a 20 km ride',
      icon: Icons.speed,
      color: const Color(0xFF0077B6),
    ),
    AppBadge(
      id: 'ride_90km',
      title: 'Iron Cyclist',
      description: 'Complete a 90 km ride',
      icon: Icons.bolt,
      color: const Color(0xFF023E8A),
    ),

    // Running
    AppBadge(
      id: 'first_run',
      title: 'First Steps',
      description: 'Log your first run session',
      icon: Icons.directions_run,
      color: const Color(0xFF0096C7),
    ),
    AppBadge(
      id: 'run_5km',
      title: '5K Finisher',
      description: 'Complete a 5 km run',
      icon: Icons.directions_run,
      color: const Color(0xFF0077B6),
    ),
    AppBadge(
      id: 'run_10km',
      title: '10K Warrior',
      description: 'Complete a 10 km run',
      icon: Icons.directions_run,
      color: const Color(0xFF023E8A),
    ),
    AppBadge(
      id: 'run_21km',
      title: 'Half Marathon',
      description: 'Complete a 21.1 km run',
      icon: Icons.military_tech,
      color: const Color(0xFF48CAE4),
      iconColor: const Color(0xFF023E8A),
    ),
    AppBadge(
      id: 'run_42km',
      title: 'Marathon',
      description: 'Complete a 42.2 km run',
      icon: Icons.military_tech,
      color: const Color(0xFFFFB703),
      iconColor: Colors.white,
    ),

    // Consistency
    AppBadge(
      id: 'streak_7',
      title: '7-Day Streak',
      description: 'Train 7 days in a row',
      icon: Icons.local_fire_department,
      color: Colors.deepOrange,
    ),
    AppBadge(
      id: 'all_three',
      title: 'Triathlete',
      description: 'Log all 3 disciplines in one week',
      icon: Icons.workspace_premium,
      color: const Color(0xFFFFB703),
      iconColor: Colors.white,
    ),
  ];

  List<AppBadge> get allBadges => _badges;
  List<AppBadge> get earnedBadges => _badges.where((b) => b.earned).toList();
  List<AppBadge> get unearnedBadges => _badges.where((b) => !b.earned).toList();

  Future<void> loadBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('badges') ?? [];
    final saved = {
      for (var s in raw)
        (jsonDecode(s) as Map<String, dynamic>)['id'] as String:
            jsonDecode(s) as Map<String, dynamic>,
    };
    for (final badge in _badges) {
      if (saved.containsKey(badge.id)) {
        badge.earned = saved[badge.id]!['earned'] ?? false;
        final ds = saved[badge.id]!['earnedDate'];
        badge.earnedDate = ds != null ? DateTime.parse(ds) : null;
      }
    }

    _xp = prefs.getInt('badgeXp') ?? 0;
    _level = prefs.getInt('badgeLevel') ?? 1;

    _initializeDailyChallenge();
    notifyListeners();
  }

  void _initializeDailyChallenge() {
    _todayChallenge = _generateTodayChallenge();
  }

  DailyChallenge _generateTodayChallenge() {
    final today = DateTime.now().day % 3;
    if (today == 0) {
      return DailyChallenge(
        id: 'daily_swim',
        title: 'Swim Challenge',
        description: 'Swim 500m to complete today\'s challenge',
        targetValue: 500,
        unit: 'm',
        discipline: Discipline.swim,
        icon: Icons.pool,
        color: const Color(0xFF48CAE4),
      );
    } else if (today == 1) {
      return DailyChallenge(
        id: 'daily_bike',
        title: 'Bike Challenge',
        description: 'Ride 10 km to complete today\'s challenge',
        targetValue: 10,
        unit: 'km',
        discipline: Discipline.bike,
        icon: Icons.directions_bike,
        color: const Color(0xFF0096C7),
      );
    } else {
      return DailyChallenge(
        id: 'daily_run',
        title: 'Run Challenge',
        description: 'Run 3 km to complete today\'s challenge',
        targetValue: 3,
        unit: 'km',
        discipline: Discipline.run,
        icon: Icons.directions_run,
        color: const Color(0xFF023E8A),
      );
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'badges',
      _badges.map((b) => jsonEncode(b.toJson())).toList(),
    );
    await prefs.setInt('badgeXp', _xp);
    await prefs.setInt('badgeLevel', _level);
  }

  Future<void> evaluate(List<WorkoutEntry> workouts) async {
    bool changed = false;

    void tryEarn(String id) {
      final badge = _badges.firstWhere((b) => b.id == id);
      if (!badge.earned) {
        badge.earned = true;
        badge.earnedDate = DateTime.now();
        _newlyEarned = badge;
        changed = true;
      }
    }

    final swims = workouts.where((w) => w.discipline == Discipline.swim);
    final rides = workouts.where((w) => w.discipline == Discipline.bike);
    final runs = workouts.where((w) => w.discipline == Discipline.run);

    if (swims.isNotEmpty) tryEarn('first_swim');
    if (swims.any((w) => w.distance >= 1000)) tryEarn('swim_1km');
    if (swims.any((w) => w.distance >= 2500)) tryEarn('swim_2500m');

    if (rides.isNotEmpty) tryEarn('first_ride');
    if (rides.any((w) => w.distance >= 20)) tryEarn('ride_20km');
    if (rides.any((w) => w.distance >= 90)) tryEarn('ride_90km');

    if (runs.isNotEmpty) tryEarn('first_run');
    if (runs.any((w) => w.distance >= 5)) tryEarn('run_5km');
    if (runs.any((w) => w.distance >= 10)) tryEarn('run_10km');
    if (runs.any((w) => w.distance >= 21.1)) tryEarn('run_21km');
    if (runs.any((w) => w.distance >= 42.2)) tryEarn('run_42km');

    // All 3 disciplines in one week
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final thisWeek = workouts.where((w) => w.date.isAfter(weekAgo)).toList();
    if (thisWeek.any((w) => w.discipline == Discipline.swim) &&
        thisWeek.any((w) => w.discipline == Discipline.bike) &&
        thisWeek.any((w) => w.discipline == Discipline.run)) {
      tryEarn('all_three');
    }

    // ── 7-day streak (fixed: deduplicate dates first) ──────
    // Normalise each workout date to midnight so multiple sessions
    // on the same day are treated as a single training day.
    final uniqueDays =
        workouts
            .map((w) => DateTime(w.date.year, w.date.month, w.date.day))
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a)); // newest first

    if (uniqueDays.isNotEmpty) {
      int streak = 1;
      for (int i = 1; i < uniqueDays.length; i++) {
        final diff = uniqueDays[i - 1].difference(uniqueDays[i]).inDays;
        if (diff == 1) {
          streak++;
        } else if (diff > 1) {
          break; // gap found — streak resets
        }
        // diff == 0 can't happen since we've deduplicated
      }
      if (streak >= 7) tryEarn('streak_7');
    }

    if (changed) {
      await _persist();
      notifyListeners();
    }
  }

  Future<void> addXpFromWorkout(WorkoutEntry workout) async {
    final earnedXp = _xpForWorkout(workout);
    _xp += earnedXp;

    bool leveled = false;
    while (_xp >= xpForNextLevel) {
      _level += 1;
      _newlyLevelUp = _level;
      leveled = true;
    }

    // Update daily challenge progress
    if (_todayChallenge != null && !_todayChallenge!.completed) {
      if (_todayChallenge!.discipline == workout.discipline) {
        final addedProgress = workout.discipline == Discipline.swim
            ? workout.distance.toInt()
            : workout.distance.toInt();
        _todayChallenge!.progress += addedProgress;
        if (_todayChallenge!.progress >= _todayChallenge!.targetValue) {
          _todayChallenge!.completed = true;
          _xp += 50; // bonus XP for completing daily challenge
        }
      }
    }

    if (earnedXp > 0 || leveled) {
      await _persist();
      notifyListeners();
    }
  }

  int _xpForWorkout(WorkoutEntry workout) {
    final durationBonus = (workout.durationMinutes / 10).round() * 5;
    final distanceBonus = workout.discipline == Discipline.swim
        ? (workout.distance / 100).round() * 3
        : workout.distance.round() * 2;
    final disciplineBonus = workout.discipline == Discipline.swim
        ? 5
        : workout.discipline == Discipline.bike
        ? 8
        : 6;
    return 20 + durationBonus + distanceBonus + disciplineBonus;
  }

  int _xpThresholdForLevel(int level) => 100 + (level - 1) * 50;
}
