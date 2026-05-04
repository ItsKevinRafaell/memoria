// lib/presentation/widgets/progress/progress_bar_top.dart
import 'package:flutter/material.dart';
import 'package:memoria/core/theme/app_theme.dart';

/// ─────────────────────────────────────────
///  ProgressBarTop
///
///  Top navigation progress bar (Step X of Y).
///  Two variants from the design:
///    - standard : no back button
///    - withBack : shows leading back arrow
/// ─────────────────────────────────────────
class ProgressBarTop extends StatelessWidget {
  final int currentStep; // 1-based
  final int totalSteps;
  final bool showBackButton;
  final VoidCallback? onBack;

  const ProgressBarTop({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.showBackButton = false,
    this.onBack,
  }) : assert(currentStep >= 1 && currentStep <= totalSteps);

  double get _progress => currentStep / totalSteps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row: optional back btn + progress bar
          Row(
            children: [
              if (showBackButton) ...[
                GestureDetector(
                  onTap: onBack,
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(child: _LinearProgressBar(progress: _progress)),
            ],
          ),
          const SizedBox(height: 6),

          // Step label (right-aligned)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Step $currentStep of $totalSteps',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Linear Progress Bar ─────────────────
class _LinearProgressBar extends StatelessWidget {
  final double progress; // 0.0 – 1.0

  const _LinearProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0), // Slate 200
            borderRadius: BorderRadius.circular(99),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        );
      },
    );
  }
}
