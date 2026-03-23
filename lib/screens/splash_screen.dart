import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    //set up fade animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    //start animation
    _controller.forward();
    //navigate to welcome screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); //always clean up animation controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo-bg.png',
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'TriSync',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023E8A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your Ultimate Triathlon Training Companion',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Color(0xFF0077B6),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
