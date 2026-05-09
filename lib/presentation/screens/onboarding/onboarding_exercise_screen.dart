import 'package:flutter/material.dart';
import 'package:NeuroBob/core/models/onboarding_model.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingExerciseScreen extends StatefulWidget {
  final void Function(ExerciseFrequency exercise) onFinish;
  final VoidCallback onBack;

  const OnboardingExerciseScreen({
    super.key,
    required this.onFinish,
    required this.onBack,
  });

  @override
  State<OnboardingExerciseScreen> createState() =>
      _OnboardingExerciseScreenState();
}

class _OnboardingExerciseScreenState extends State<OnboardingExerciseScreen> {
  ExerciseFrequency? _selectedExercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Navigation & Progress Bar
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: const LinearProgressIndicator(
                        value: 1.0, // Step 4 of 4 (100%)
                        backgroundColor: Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(
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
                  'Step 4 of 4',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Headers
              Text(
                'How often do you exercise?',
                style: AppTextStyles.h1.copyWith(letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Help us tailor your daily goals by telling us about your current routine.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),

              // Exercise Frequency Selectable List
              Expanded(
                child: ListView.separated(
                  itemCount: ExerciseFrequency.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final exerciseOption = ExerciseFrequency.values[index];
                    final isSelected = _selectedExercise == exerciseOption;

                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedExercise = exerciseOption),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryLight
                              : AppColors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textDisabled,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.cardSm),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _label(exerciseOption),
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            // Radio Button Icon
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textDisabled,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: AppColors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Finish Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedExercise != null
                      ? () => widget.onFinish(_selectedExercise!)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  child: const Text(
                    'Finish Setup',
                    style: AppTextStyles.buttonLabel,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Adjusted labels to closely match the simpler terminology in the Figma design
  // while still mapping to your underlying enum values.
  String _label(ExerciseFrequency e) => switch (e) {
    ExerciseFrequency.never => 'Never',
    ExerciseFrequency.rarely => 'Rarely',
    ExerciseFrequency.sometimes => '1-2 times a week',
    ExerciseFrequency.often => '3+ times a week',
    ExerciseFrequency.daily => 'Daily',
  };
}
