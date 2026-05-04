import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingTemplate extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final Widget? topIcon; // Optional icon above the title (like the waving hand)
  final String title;
  final String subtitle;
  final Widget child; // The middle content (TextField or List)
  final String buttonLabel;
  final bool isButtonEnabled;
  final VoidCallback onContinue;

  const OnboardingTemplate({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
    required this.onBack,
    this.topIcon,
    required this.title,
    required this.subtitle,
    required this.child,
    this.buttonLabel = 'Continue',
    required this.isButtonEnabled,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress (e.g., Step 2 of 4 = 0.5)
    final progress = currentStep / totalSteps;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Navigation & Progress Bar
              Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Step $currentStep of $totalSteps',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 2. Optional Top Icon (for Name Screen)
              if (topIcon != null) ...[
                Center(child: topIcon!),
                const SizedBox(height: 24),
              ],

              // 3. Headers
              Text(
                title,
                textAlign: topIcon != null ? TextAlign.center : TextAlign.left,
                style: AppTextStyles.h1.copyWith(letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                textAlign: topIcon != null ? TextAlign.center : TextAlign.left,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),

              // 4. The Dynamic Content
              Expanded(child: child),

              // 5. Bottom Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isButtonEnabled ? onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  child: Text(buttonLabel, style: AppTextStyles.buttonLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
