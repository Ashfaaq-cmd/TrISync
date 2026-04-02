import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Discipline { swim, bike, run }

extension DisciplineExtension on Discipline {
  String get label {
    switch (this) {
      case Discipline.swim:
        return 'Swimming';
      case Discipline.bike:
        return 'Cycling';
      case Discipline.run:
        return 'Running';
    }
  }

  IconData get icon {
    switch (this) {
      case Discipline.swim:
        return Icons.pool;
      case Discipline.bike:
        return Icons.directions_bike;
      case Discipline.run:
        return Icons.directions_run;
    }
  }

  String get distanceUnit => this == Discipline.swim ? 'm' : 'km';
}

class WorkoutEntry {
  final String id;
  final Discipline discipline;
  final double distance;
  final int durationMinutes;
  final String notes;
  final DateTime date;

  WorkoutEntry({
    required this.id,
    required this.discipline,
    required this.distance,
    required this.durationMinutes,
    required this.notes,
    required this.date,
  });

  // Calculates pace (swim) or speed (bike/run)
  String get paceOrSpeed {
    if (durationMinutes == 0) return '-';
    if (discipline == Discipline.swim) {
      final secPer100m = (durationMinutes * 60) / (distance / 100);
      final mins = secPer100m ~/ 60;
      final secs = (secPer100m % 60).round();
      return '$mins:${secs.toString().padLeft(2, '0')} /100m';
    } else {
      final speed = (distance / durationMinutes) * 60;
      return '${speed.toStringAsFixed(1)} km/h';
    }
  }

  String get distanceDisplay {
    if (discipline == Discipline.swim) {
      return distance >= 1000
          ? '${(distance / 1000).toStringAsFixed(2)} km'
          : '${distance.toStringAsFixed(0)} m';
    }
    return '${distance.toStringAsFixed(2)} km';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'discipline': discipline.index,
    'distance': distance,
    'durationMinutes': durationMinutes,
    'notes': notes,
    'date': date.toIso8601String(),
  };

  factory WorkoutEntry.fromJson(Map<String, dynamic> json) => WorkoutEntry(
    id: json['id'],
    discipline: Discipline.values[json['discipline']],
    distance: (json['distance'] as num).toDouble(),
    durationMinutes: json['durationMinutes'],
    notes: json['notes'],
    date: DateTime.parse(json['date']),
  );
}

class WorkoutProvider extends ChangeNotifier {
  List<WorkoutEntry> _workouts = [];

  List<WorkoutEntry> get workouts => List.unmodifiable(_workouts);

  List<WorkoutEntry> get recentWorkouts {
    final sorted = [..._workouts]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  int get totalWorkouts => _workouts.length;

  List<WorkoutEntry> get weeklyWorkouts {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    return _workouts.where((w) => w.date.isAfter(cutoff)).toList();
  }

  double totalDistanceForDiscipline(Discipline d) {
    return _workouts
        .where((w) => w.discipline == d)
        .fold(
          0.0,
          (sum, w) =>
              sum + (d == Discipline.swim ? w.distance / 1000 : w.distance),
        );
  }

  int totalMinutesForDiscipline(Discipline d) {
    return _workouts
        .where((w) => w.discipline == d)
        .fold(0, (sum, w) => sum + w.durationMinutes);
  }

  Future<void> loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('workouts') ?? [];
    _workouts = raw.map((s) => WorkoutEntry.fromJson(jsonDecode(s))).toList();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'workouts',
      _workouts.map((w) => jsonEncode(w.toJson())).toList(),
    );
  }

  Future<void> addWorkout(WorkoutEntry workout) async {
    _workouts.add(workout);
    await _persist();
    notifyListeners();
  }

  Future<void> deleteWorkout(String id) async {
    _workouts.removeWhere((w) => w.id == id);
    await _persist();
    notifyListeners();
  }
}
