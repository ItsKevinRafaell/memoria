// lib/presentation/widgets/mood/emoji_mood_picker.dart
import 'package:flutter/material.dart';
import 'package:NeuroBob/core/theme/app_theme.dart';

/// 5 mood levels matching the emoji grid design
enum MoodLevel {
  veryBad, // ╳ eyes
  bad, // sad
  neutral, // flat
  good, // smile
  great, // big grin
}

/// ─────────────────────────────────────────
///  EmojiMoodPicker
///
///  Renders a horizontal row of 5 emoji mood
///  buttons. Selected item gets a blue filled
///  circle background; others are outlined gray.
/// ─────────────────────────────────────────
class EmojiMoodPicker extends StatelessWidget {
  final MoodLevel? selectedMood;
  final ValueChanged<MoodLevel>? onChanged;

  const EmojiMoodPicker({super.key, this.selectedMood, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: MoodLevel.values.map((mood) {
        final isSelected = mood == selectedMood;
        return _EmojiItem(
          mood: mood,
          isSelected: isSelected,
          onTap: () => onChanged?.call(mood),
        );
      }).toList(),
    );
  }
}

// ─── Single Emoji Item ───────────────────
class _EmojiItem extends StatelessWidget {
  final MoodLevel mood;
  final bool isSelected;
  final VoidCallback onTap;

  static const Map<MoodLevel, String> _emojis = {
    MoodLevel.veryBad: '😵',
    MoodLevel.bad: '😟',
    MoodLevel.neutral: '😐',
    MoodLevel.good: '🙂',
    MoodLevel.great: '😄',
  };

  const _EmojiItem({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.primary : AppColors.background,
          border: isSelected
              ? null
              : Border.all(color: AppColors.textDisabled, width: 1.5),
        ),
        child: Center(
          child: Text(
            _emojis[mood] ?? '',
            style: TextStyle(fontSize: isSelected ? 26 : 22),
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────
///  Convenience: wrap in a Card
/// ─────────────────────────────────────────
class EmojiMoodCard extends StatelessWidget {
  final MoodLevel? selectedMood;
  final ValueChanged<MoodLevel>? onChanged;
  final String? title;

  const EmojiMoodCard({
    super.key,
    this.selectedMood,
    this.onChanged,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(title!, style: AppTextStyles.h2),
            const SizedBox(height: 16),
          ],
          EmojiMoodPicker(selectedMood: selectedMood, onChanged: onChanged),
        ],
      ),
    );
  }
}
