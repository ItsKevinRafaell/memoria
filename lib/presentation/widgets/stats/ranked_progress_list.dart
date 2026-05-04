// lib/presentation/widgets/stats/ranked_progress_list.dart
import 'package:flutter/material.dart';
import 'package:memoria/core/theme/app_theme.dart';

/// Data model for a single ranked progress item
class RankedProgressItem {
  final double progress; // 0.0 – 1.0
  final int rank; // 1, 2, 3 …
  final String? label;

  const RankedProgressItem({
    required this.progress,
    required this.rank,
    this.label,
  });
}

/// ─────────────────────────────────────────
///  RankedProgressList
///
///  Renders a vertical list of progress bars,
///  each with a 🔥 flame + rank badge on the right.
///  Matches the "Top Header Area (Task-Focused)" design.
/// ─────────────────────────────────────────
class RankedProgressList extends StatelessWidget {
  final List<RankedProgressItem> items;

  const RankedProgressList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _RankedProgressRow(item: item),
            ),
          )
          .toList(),
    );
  }
}

// ─── Single Row ───────────────────────────
class _RankedProgressRow extends StatelessWidget {
  final RankedProgressItem item;

  const _RankedProgressRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Progress bar
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(99),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: item.progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Flame badge
        _FlameBadge(rank: item.rank),
      ],
    );
  }
}

// ─── Flame Badge ──────────────────────────
class _FlameBadge extends StatelessWidget {
  final int rank;

  const _FlameBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED), // Warm peach
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          Text(
            '$rank',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.warning,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
