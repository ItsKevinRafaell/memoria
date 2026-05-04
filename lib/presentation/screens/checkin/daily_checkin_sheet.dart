import 'package:flutter/material.dart';

enum MoodLevel { terrible, bad, neutral, good, excellent }

enum SleepDuration { lessThan6, sixToEight, moreThan8 }

class DailyCheckInDialog extends StatefulWidget {
  final void Function(MoodLevel mood, SleepDuration sleep) onSubmit;

  const DailyCheckInDialog({super.key, required this.onSubmit});

  @override
  State<DailyCheckInDialog> createState() => _DailyCheckInDialogState();
}

class _DailyCheckInDialogState extends State<DailyCheckInDialog> {
  MoodLevel? _selectedMood;
  SleepDuration? _selectedSleep;

  @override
  Widget build(BuildContext context) {
    const darkText = Color(0xFF0F172A);
    const primaryBlue = Color(0xFF2563EB);
    const mutedText = Color(0xFF64748B);
    const borderColor = Color(0xFFE2E8F0);

    // Using Dialog instead of Container to make it a floating modal
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      backgroundColor: Colors.white,
      surfaceTintColor:
          Colors.transparent, // Prevents unwanted tinting in Material 3
      insetPadding: const EdgeInsets.symmetric(horizontal: 24), // Outer margins
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Mood Section ---
            const Text(
              'How is your mood\ntoday?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkText,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: MoodLevel.values.map((mood) {
                final isSelected = _selectedMood == mood;
                return GestureDetector(
                  behavior: HitTestBehavior
                      .opaque, // Ensures the whole area is tappable
                  onTap: () => setState(() => _selectedMood = mood),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // FIX: Solid blue when selected, transparent otherwise
                      color: isSelected ? primaryBlue : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getMoodIcon(mood),
                      size: 32,
                      // FIX: White icon when selected, gray when unselected
                      color: isSelected ? Colors.white : mutedText,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
            const Divider(color: borderColor, height: 1),
            const SizedBox(height: 32),

            // --- Sleep Section ---
            const Text(
              'How many hours did\nyou sleep?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkText,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),

            _SleepOptionButton(
              label: 'Less than 6 hours',
              isSelected: _selectedSleep == SleepDuration.lessThan6,
              onTap: () =>
                  setState(() => _selectedSleep = SleepDuration.lessThan6),
            ),
            const SizedBox(height: 16),
            _SleepOptionButton(
              label: '6 - 8 hours',
              isSelected: _selectedSleep == SleepDuration.sixToEight,
              onTap: () =>
                  setState(() => _selectedSleep = SleepDuration.sixToEight),
            ),
            const SizedBox(height: 16),
            _SleepOptionButton(
              label: 'More than 8 hours',
              isSelected: _selectedSleep == SleepDuration.moreThan8,
              onTap: () =>
                  setState(() => _selectedSleep = SleepDuration.moreThan8),
            ),

            const SizedBox(height: 40),

            // --- Submit Button ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (_selectedMood != null && _selectedSleep != null)
                    ? () {
                        widget.onSubmit(_selectedMood!, _selectedSleep!);
                        Navigator.pop(context); // Close the dialog
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  disabledBackgroundColor: primaryBlue.withOpacity(0.3),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                child: const Text(
                  'Save & Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMoodIcon(MoodLevel mood) {
    switch (mood) {
      case MoodLevel.terrible:
        return Icons.sentiment_very_dissatisfied_rounded;
      case MoodLevel.bad:
        return Icons.sentiment_dissatisfied_rounded;
      case MoodLevel.neutral:
        return Icons.sentiment_neutral_rounded;
      case MoodLevel.good:
        return Icons.sentiment_satisfied_rounded;
      case MoodLevel.excellent:
        return Icons.sentiment_very_satisfied_rounded;
    }
  }
}

class _SleepOptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SleepOptionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2563EB);
    const borderColor = Color(0xFFE2E8F0);
    const darkText = Color(0xFF0F172A);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? primaryBlue : borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          // FIX: Text is ALWAYS darkText so it never vanishes
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: darkText,
          ),
        ),
      ),
    );
  }
}
