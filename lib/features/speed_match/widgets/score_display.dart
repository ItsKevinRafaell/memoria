// widgets/score_display.dart
// Top HUD showing all live metrics.

import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final int score;
  final int streak;
  final String accuracy;
  final int timeLimitMs;
  final int difficultyLevel;

  const ScoreDisplay({
    super.key,
    required this.score,
    required this.streak,
    required this.accuracy,
    required this.timeLimitMs,
    required this.difficultyLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Score (largest metric — most prominent)
          _MetricTile(
            label: 'SCORE',
            value: score.toString(),
            valueColor: const Color(0xFF00D4FF),
            fontSize: 28,
          ),
          // Divider
          _Divider(),
          // Streak
          _MetricTile(
            label: 'STREAK',
            value: streak.toString(),
            valueColor: streak >= 10
                ? const Color(0xFFFFD700)
                : streak >= 5
                    ? const Color(0xFFFFA500)
                    : const Color(0xFFFFFFFF),
          ),
          _Divider(),
          // Accuracy
          _MetricTile(
            label: 'ACCURACY',
            value: accuracy,
            valueColor: const Color(0xFF00FF9F),
          ),
          _Divider(),
          // Speed level
          _MetricTile(
            label: 'LVL',
            value: 'L$difficultyLevel',
            valueColor: const Color(0xFFFF9F00),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withOpacity(0.1),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final double fontSize;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.valueColor,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 2),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: valueColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            shadows: [
              Shadow(color: valueColor.withOpacity(0.4), blurRadius: 12),
            ],
          ),
          child: Text(value),
        ),
      ],
    );
  }
}

/// Countdown progress bar (glows, color changes by urgency)
class TimerProgressBar extends StatelessWidget {
  final double progress; // 0.0 → 1.0
  final int timeLimitMs;

  const TimerProgressBar({
    super.key,
    required this.progress,
    required this.timeLimitMs,
  });

  Color _barColor() {
    if (progress > 0.5) return const Color(0xFF00D4FF);
    if (progress > 0.25) return const Color(0xFFFFB800);
    return const Color(0xFFFF4466);
  }

  @override
  Widget build(BuildContext context) {
    final color = _barColor();
    return Container(
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Stack(
          children: [
            // Background track
            Container(
              color: Colors.white.withOpacity(0.08),
            ),
            // Filled portion
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.6),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Streak fire indicator — shown when streak >= 5
class StreakIndicator extends StatefulWidget {
  final int streak;
  const StreakIndicator({super.key, required this.streak});

  @override
  State<StreakIndicator> createState() => _StreakIndicatorState();
}

class _StreakIndicatorState extends State<StreakIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.streak < 5) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Transform.scale(
        scale: _pulse.value,
        child: Text(
          widget.streak >= 15
              ? '🔥🔥🔥'
              : widget.streak >= 10
                  ? '🔥🔥'
                  : '🔥',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
