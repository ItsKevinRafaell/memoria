import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SelectionCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? leadingIcon; // Optional, for the Memory screen's pastel icons

  const SelectionCard({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textDisabled,
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
            // Optional leading icon
            if (leadingIcon != null) ...[
              leadingIcon!,
              const SizedBox(width: 16),
            ],

            // Label
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // Custom Radio Checkmark
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textDisabled,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: AppColors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
