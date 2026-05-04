import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onStartJourney;

  const SplashScreen({super.key, required this.onStartJourney});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Setup the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 2. Create smooth fade and scale (bounce) effects
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // 3. Start the animation
    _controller.forward();

    // 4. Wait for 3 seconds, then automatically route to Onboarding (or Home)
    Timer(const Duration(seconds: 3), () {
      // Check if the widget is still mounted before navigating
      if (mounted) {
        widget.onStartJourney();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Elevated Logo Container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 56,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // App Name
                    Text(
                      'Memoria',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.primary,
                        fontSize: 40,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      'Train your mind. Enhance your life.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
