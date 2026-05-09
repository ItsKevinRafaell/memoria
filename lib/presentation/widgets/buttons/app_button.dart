// lib/presentation/widgets/buttons/app_button.dart
import 'package:flutter/material.dart';
import 'package:NeuroBob/core/theme/app_theme.dart';

/// Button visual variants — exactly 3 from design:
///  - primaryWithArrow → solid Blue, white text, trailing arrow icon
///  - primary          → solid Blue, white text, no arrow
///  - secondary        → white bg, gray border, dark text
enum AppButtonVariant { primaryWithArrow, primary, secondary }

/// ─────────────────────────────────────────
///  AppButton
///
///  Pure presentational widget.
///  Connect [onPressed] from your BLoC/Provider.
/// ─────────────────────────────────────────
class AppButton extends StatelessWidget {
  final String label;
  final AppButtonVariant variant;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.onPressed,
  });

  /// Variant 1: Blue + trailing arrow  e.g. "Start My Journey →"
  factory AppButton.primaryWithArrow({
    Key? key,
    required String label,
    VoidCallback? onPressed,
  }) => AppButton(
    key: key,
    label: label,
    variant: AppButtonVariant.primaryWithArrow,
    onPressed: onPressed,
  );

  /// Variant 2: Blue, no arrow
  factory AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
  }) => AppButton(
    key: key,
    label: label,
    variant: AppButtonVariant.primary,
    onPressed: onPressed,
  );

  /// Variant 3: Outline / secondary
  factory AppButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
  }) => AppButton(
    key: key,
    label: label,
    variant: AppButtonVariant.secondary,
    onPressed: onPressed,
  );

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.primaryWithArrow:
        return _PrimaryButton(
          label: label,
          onPressed: onPressed,
          showTrailingArrow: true,
        );
      case AppButtonVariant.primary:
        return _PrimaryButton(
          label: label,
          onPressed: onPressed,
          showTrailingArrow: false,
        );
      case AppButtonVariant.secondary:
        return _SecondaryButton(label: label, onPressed: onPressed);
    }
  }
}

// ─── Primary ──────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool showTrailingArrow;

  const _PrimaryButton({
    required this.label,
    this.onPressed,
    this.showTrailingArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.buttonLabel),
            if (showTrailingArrow) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.white,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Secondary / Outline ──────────────────
class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _SecondaryButton({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.textDisabled, width: 1.5),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonLabel.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// End of AppButton variants
