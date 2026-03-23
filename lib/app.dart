import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'models/user_profile.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/onboarding/name_input_screen.dart';

class TriSync extends StatelessWidget {
  const TriSync({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProfile(),
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
        },

        home: const SplashScreen(),
      ),
    );
  }
}
