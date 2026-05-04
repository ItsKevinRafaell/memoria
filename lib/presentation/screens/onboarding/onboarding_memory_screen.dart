import 'package:flutter/material.dart';
import 'package:memoria/core/models/onboarding_model.dart';
import 'package:memoria/presentation/widgets/layout/onboarding_template.dart';
import 'package:memoria/presentation/widgets/cards/selection_card.dart';

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
    return OnboardingTemplate(
      currentStep: 3,
      onBack: widget.onBack,
      title: 'How do you feel about your daily memory?',
      subtitle: 'This helps us tailor your daily cognitive exercises.',
      isButtonEnabled: _selectedMemory != null,
      onContinue: () => widget.onContinue(_selectedMemory!),
      child: ListView.separated(
        itemCount: MemoryBaseline.values.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final memoryOption = MemoryBaseline.values[index];
          final visualConfig = _getVisualConfig(memoryOption);

          return SelectionCard(
            label: visualConfig.label,
            isSelected: _selectedMemory == memoryOption,
            onTap: () => setState(() => _selectedMemory = memoryOption),
            // Passing the custom icon block to the reusable card
            leadingIcon: Container(
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
          );
        },
      ),
    );
  }

  _MemoryVisualConfig _getVisualConfig(MemoryBaseline m) {
    switch (m) {
      case MemoryBaseline.excellent:
      case MemoryBaseline.good:
        return _MemoryVisualConfig(
          label: 'Sharp as ever',
          icon: Icons.psychology_outlined,
          bgColor: const Color(0xFFD1FAE5),
          iconColor: const Color(0xFF059669),
        );
      case MemoryBaseline.average:
        return _MemoryVisualConfig(
          label: 'Sometimes forgetful',
          icon: Icons.timer_outlined,
          bgColor: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFD97706),
        );
      case MemoryBaseline.belowAverage:
      case MemoryBaseline.poor:
        return _MemoryVisualConfig(
          label: 'Often misplace things',
          icon: Icons.help_outline_rounded,
          bgColor: const Color(0xFFFEE2E2),
          iconColor: const Color(0xFFDC2626),
        );
    }
  }
}

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
