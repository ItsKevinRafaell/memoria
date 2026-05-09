import 'package:flutter/material.dart';
import 'package:NeuroBob/core/models/onboarding_model.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingAgeScreen extends StatefulWidget {
  final void Function(AgeRange age) onContinue;
  final VoidCallback onBack;

  const OnboardingAgeScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<OnboardingAgeScreen> createState() => _OnboardingAgeScreenState();
}

class _OnboardingAgeScreenState extends State<OnboardingAgeScreen> {
  AgeRange? _selectedAge;

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
                        value: 0.5, // Step 2 of 4
                        backgroundColor: Color(
                          0xFFE2E8F0,
                        ), // Slate 200 equivalent
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
                  'Step 2 of 4',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Headers
              Text(
                'What is your age range?',
                style: AppTextStyles.h1.copyWith(letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'This helps us personalize your daily games and insights.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),

              // Age Range Selectable List
              Expanded(
                child: ListView.separated(
                  itemCount: AgeRange.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final ageOption = AgeRange.values[index];
                    final isSelected = _selectedAge == ageOption;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedAge = ageOption),
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
                              _label(ageOption),
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

              // Bottom Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedAge != null
                      ? () => widget.onContinue(_selectedAge!)
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
                    'Continue',
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

  // Adjusted to match the specific strings in the Figma design.
  // Make sure your AgeRange enum matches these logical groupings.
  String _label(AgeRange a) => switch (a) {
    AgeRange.under18 => 'Under 50', // Re-mapped for the visual example
    AgeRange.age18to29 => '50 - 64',
    AgeRange.age30to44 => '65 - 74',
    AgeRange.age45to59 => '75+',
    AgeRange.age60plus => 'Other',
  };
}
