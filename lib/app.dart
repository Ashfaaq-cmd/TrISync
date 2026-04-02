import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user_profile.dart';
import 'models/workout.dart';
import 'models/badge_model.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/onboarding/name_input_screen.dart';
import 'screens/onboarding/level_assesment_screen.dart';
import 'screens/onboarding/goal_selection_screen.dart';
import 'screens/home_screen.dart';

class TriSync extends StatelessWidget {
  const TriSync({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //Providers for user profile, workouts, and badges
      providers: [
        ChangeNotifierProvider(create: (_) => UserProfile()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => BadgeProvider()),
      ],
      child: MaterialApp(
        title: 'TriSync',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0077B6),
            brightness: Brightness.light,
          ),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),

        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/name-input': (context) => const NameInputScreen(),
          '/level-assessment': (context) => const LevelAssesmentScreen(),
          '/goal-selection': (context) => const GoalSelectionScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
