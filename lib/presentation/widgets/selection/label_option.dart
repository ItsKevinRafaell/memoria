// lib/presentation/widgets/selection/label_option.dart
import 'package:flutter/material.dart';
import 'package:memoria/core/theme/app_theme.dart';

/// ─────────────────────────────────────────
///  LabelOption  (Container_3 + Label Option)
///
///  Pill-shaped selectable option row.
///  Two variants:
///    - text only  (e.g. "Less than 6 hours")
///    - with icon  (e.g. "Sharp as ever" + icon bg)
/// ─────────────────────────────────────────
class LabelOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  // Optional leading icon (for Label Option Image variant)
  final Widget? leadingIcon;
  final Color? leadingBgColor;

  const LabelOption({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.leadingIcon,
    this.leadingBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textDisabled,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            // Leading icon (optional)
            if (leadingIcon != null) ...[
              _LeadingIconBox(
                icon: leadingIcon!,
                bgColor: leadingBgColor ?? AppColors.softLavender,
              ),
              const SizedBox(width: 12),
            ],

            // Label
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),

            // Trailing radio indicator
            _RadioIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

// ─── Leading icon box ─────────────────────
class _LeadingIconBox extends StatelessWidget {
  final Widget icon;
  final Color bgColor;

  const _LeadingIconBox({required this.icon, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: icon),
    );
  }
}

// ─── Radio indicator ──────────────────────
class _RadioIndicator extends StatelessWidget {
  final bool isSelected;

  const _RadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.textDisabled,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.white, size: 14)
          : null,
    );
  }
}

/// ─────────────────────────────────────────
///  LabelOptionGroup
///
///  Renders a list of [LabelOption] with
///  single-select logic built in.
/// ─────────────────────────────────────────
class LabelOptionGroup extends StatelessWidget {
  final List<String> options;
  final int? selectedIndex;
  final ValueChanged<int>? onChanged;
  final List<Widget?>? leadingIcons;
  final List<Color?>? leadingBgColors;

  const LabelOptionGroup({
    super.key,
    required this.options,
    this.selectedIndex,
    this.onChanged,
    this.leadingIcons,
    this.leadingBgColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(options.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LabelOption(
            label: options[i],
            isSelected: selectedIndex == i,
            onTap: () => onChanged?.call(i),
            leadingIcon: leadingIcons != null ? leadingIcons![i] : null,
            leadingBgColor: leadingBgColors != null
                ? leadingBgColors![i]
                : null,
          ),
        );
      }),
    );
  }
}
