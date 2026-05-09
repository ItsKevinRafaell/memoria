import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/buttons/app_button.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onStartJourney;

  const SplashScreen({super.key, required this.onStartJourney});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // App Icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: AppShadows.card,
                ),
                child: const Center(
                  child: Icon(
                    Icons.psychology_rounded,
                    size: 52,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text('NeuroBob', style: AppTextStyles.h1),
              const SizedBox(height: 12),

              Text(
                'Your personal guide to cognitive health and daily mental wellness.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              AppButton.primaryWithArrow(
                label: 'Start My Journey',
                onPressed: onStartJourney,
              ),
              const SizedBox(height: 12),
              AppButton.secondary(
                label: 'Start My Journey',
                onPressed: onStartJourney,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
