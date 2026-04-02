import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends ChangeNotifier {
  String _name = '';
  String _password = '';
  String _fitnessLevel = '';
  String _raceGoal = '';
  bool _onboardingCompleted = false;

  String get name => _name;
  String get password => _password;
  String get fitnessLevel => _fitnessLevel;
  String get raceGoal => _raceGoal;
  bool get onboardingCompleted => _onboardingCompleted;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set fitnessLevel(String value) {
    _fitnessLevel = value;
    notifyListeners();
  }

  set raceGoal(String value) {
    _raceGoal = value;
    notifyListeners();
  }

  //Load from SharedPreferences
  // Called when the app starts (in splash screen).
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString('name') ?? '';
    _password = prefs.getString('password') ?? '';
    _fitnessLevel = prefs.getString('fitnessLevel') ?? '';
    _raceGoal = prefs.getString('raceGoal') ?? '';
    _onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    notifyListeners();
  }

  //Save to SharedPreferences
  Future<void> saveProfile({
    required String name,
    required String password,
    required String fitnessLevel,
    required String raceGoal,
  }) async {
    _name = name;
    _password = password;
    _fitnessLevel = fitnessLevel;
    _raceGoal = raceGoal;
    _onboardingCompleted = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('password', password);
    await prefs.setString('fitnessLevel', fitnessLevel);
    await prefs.setString('raceGoal', raceGoal);
    await prefs.setBool('onboardingCompleted', true);

    notifyListeners();
  }

  Future<void> clearProfile() async {
    _name = '';
    _password = '';
    _fitnessLevel = '';
    _raceGoal = '';
    _onboardingCompleted = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }
}
