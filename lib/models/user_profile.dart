import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  String name = '';
  String password = '';
  String fitnessLevel = '';
  String raceGoal = '';
  bool onboardingCompleted = false;

  void saveProfile({
    required String name,
    required String password,
    required String fitnessLevel,
    required String raceGoal,
  }) {
    this.name = name;
    this.password = password;
    this.fitnessLevel = fitnessLevel;
    this.raceGoal = raceGoal;
    onboardingCompleted = true;
    notifyListeners();
  }
}
