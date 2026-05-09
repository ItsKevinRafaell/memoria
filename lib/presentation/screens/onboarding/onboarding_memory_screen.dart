import 'package:flutter/material.dart';
import 'package:NeuroBob/core/models/onboarding_model.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingMemoryScreen extends StatefulWidget {
  final void Function(MemoryBaseline memory) onContinue;
  final VoidCallback onBack;

  const OnboardingMemoryScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<OnboardingMemoryScreen> createState() => _OnboardingMemoryScreenState();
}

class _OnboardingMemoryScreenState extends State<OnboardingMemoryScreen> {
  MemoryBaseline? _selectedMemory;

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
                        value: 0.75, // Step 3 of 4
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
                  'Step 3 of 4',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Headers
              Text(
                'How do you feel about your daily memory?',
                style: AppTextStyles.h1.copyWith(
                  letterSpacing: -0.5,
                  fontSize: 28, // Adjusted slightly to fit the long title well
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This helps us tailor your daily cognitive exercises.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),

              // Memory Baseline Selectable List
              Expanded(
                child: ListView.separated(
                  itemCount: MemoryBaseline.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final memoryOption = MemoryBaseline.values[index];
                    final isSelected = _selectedMemory == memoryOption;
                    final visualConfig = _getVisualConfig(memoryOption);

                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedMemory = memoryOption),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textDisabled,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.cardSm),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            // Custom Pastel Icon Background
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: visualConfig.bgColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                visualConfig.icon,
                                color: visualConfig.iconColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Label
                            Expanded(
                              child: Text(
                                visualConfig.label,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),

                            // Radio Button
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
                  onPressed: _selectedMemory != null
                      ? () => widget.onContinue(_selectedMemory!)
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

  // Maps the enum to the exact labels, icons, and hex colors from the Figma design.
  _MemoryVisualConfig _getVisualConfig(MemoryBaseline m) {
    switch (m) {
      case MemoryBaseline.excellent:
        return _MemoryVisualConfig(
          label: 'Sharp as ever',
          icon: Icons.psychology_outlined,
          bgColor: const Color(0xFFD1FAE5), // Soft Mint
          iconColor: const Color(0xFF059669), // Emerald
        );
      case MemoryBaseline.average:
        return _MemoryVisualConfig(
          label: 'Sometimes forgetful',
          icon: Icons.timer_outlined,
          bgColor: const Color(0xFFFEF3C7), // Soft Orange/Yellow
          iconColor: const Color(0xFFD97706), // Amber
        );
      case MemoryBaseline.poor:
        return _MemoryVisualConfig(
          label: 'Often misplace things',
          icon: Icons.help_outline_rounded,
          bgColor: const Color(0xFFFEE2E2), // Soft Red
          iconColor: const Color(0xFFDC2626), // Red
        );
    }
  }
}

// Simple helper class to keep the configuration clean
class _MemoryVisualConfig {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  _MemoryVisualConfig({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}
