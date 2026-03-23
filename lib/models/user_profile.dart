import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  String name = '';
  String email = '';
  String fitnessLevel = '';
  String raceGoal = '';
  bool onboardingCompleted = false;

  void saveProfile({
    required String name,
    required String email,
    required String fitnessLevel,
    required String raceGoal,
  }) {
    this.name = name;
    this.email = email;
    this.fitnessLevel = fitnessLevel;
    this.raceGoal = raceGoal;
    onboardingCompleted = true;
    notifyListeners();
  }
}
