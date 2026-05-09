// lib/presentation/widgets/slider/app_slider.dart
import 'package:flutter/material.dart';
import 'package:NeuroBob/core/theme/app_theme.dart';

/// ─────────────────────────────────────────
///  AppSlider
///
///  Custom slider matching design:
///  - Blue filled track left of thumb
///  - Gray track right of thumb
///  - Large circular white thumb with blue border
///  - Tick labels: 4  6  7.5  8  10+
/// ─────────────────────────────────────────
class AppSlider extends StatelessWidget {
  final double value; // 0.0 – 1.0  (maps to min..max)
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final List<String> tickLabels;

  const AppSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 1,
    this.onChanged,
    this.tickLabels = const ['4', '6', '7.5', '8', '10+'],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: const Color(0xFFE2E8F0), // Slate 200
            thumbColor: AppColors.white,
            thumbShape: _CircleThumbShape(
              thumbRadius: 14,
              borderColor: AppColors.primary,
              borderWidth: 3,
            ),
            overlayColor: AppColors.primary.withOpacity(0.12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tickLabels
                .map(
                  (label) => Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

/// Custom thumb: white circle with solid blue border
class _CircleThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final Color borderColor;
  final double borderWidth;

  const _CircleThumbShape({
    required this.thumbRadius,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(thumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // White fill
    canvas.drawCircle(center, thumbRadius, Paint()..color = Colors.white);

    // Blue border
    canvas.drawCircle(
      center,
      thumbRadius,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }
}
