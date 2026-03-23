import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo
              Image.asset(
                'assets/images/logo-bg.png',
                width: 88,
                height: 88,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
              const Spacer(flex: 1),
              const Text(
                'Welcome to TriSync',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023E8A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your personalized triathlon training companion',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey),
              ),
              const Spacer(flex: 2),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 48) / 3;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SportIcon(
                        image: 'assets/images/swim-bg.png',
                        label: 'Swim',
                        width: itemWidth,
                      ),
                      _SportIcon(
                        image: 'assets/images/cycle-bg.png',
                        label: 'Bike',
                        width: itemWidth,
                      ),
                      _SportIcon(
                        image: 'assets/images/run-bg.png',
                        label: 'Run',
                        width: itemWidth,
                      ),
                    ],
                  );
                },
              ),
              const Spacer(flex: 2),
              // Get Started button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/name-input');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _SportIcon extends StatelessWidget {
  final String image;
  final String label;
  final double width;

  const _SportIcon({
    required this.image,
    required this.label,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: const Color(0xFF0077B6).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image_not_supported, color: Colors.grey[400]);
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF023E8A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
