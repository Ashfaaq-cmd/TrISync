import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;

  // Fade-in animation for the text below the Lottie
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _lottieController.forward();
    _fadeController.forward();

    // When the Lottie finishes, load profile and navigate
    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateAfterSplash();
      }
    });
  }

  Future<void> _navigateAfterSplash() async {
    // Load saved user data from SharedPreferences
    final profile = context.read<UserProfile>();
    await profile.loadProfile();

    // Safety check — widget might have been removed during the await
    if (!mounted) return;

    // Route to home if onboarding is done, otherwise start onboarding
    if (profile.onboardingCompleted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    _lottieController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 280,
              height: 280,
              child: Lottie.asset(
                'assets/animations/trisplash.json',
                controller: _lottieController,
                fit: BoxFit.contain,
                repeat: false,
                errorBuilder: (context, error, stack) {
                  return Image.asset(
                    'assets/images/logo-bg.png',
                    width: 150,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.directions_run,
                        size: 100,
                        color: Color(0xFF0077B6),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Text(
                    'TriSync',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023E8A),
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your Ultimate Triathlon Training Companion',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
