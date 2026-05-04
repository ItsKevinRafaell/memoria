import 'package:flutter/material.dart';
import 'package:memoria/core/models/onboarding_model.dart';
import 'package:memoria/presentation/widgets/layout/onboarding_template.dart';
import 'package:memoria/presentation/widgets/cards/selection_card.dart';

class OnboardingAgeScreen extends StatefulWidget {
  final void Function(AgeRange age) onContinue;
  final VoidCallback onBack;

  const OnboardingAgeScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<OnboardingAgeScreen> createState() => _OnboardingAgeScreenState();
}

class _OnboardingAgeScreenState extends State<OnboardingAgeScreen> {
  AgeRange? _selectedAge;

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      currentStep: 2,
      onBack: widget.onBack,
      title: 'What is your age range?',
      subtitle: 'This helps us personalize your daily games and insights.',
      isButtonEnabled: _selectedAge != null,
      onContinue: () => widget.onContinue(_selectedAge!),
      child: ListView.separated(
        itemCount: AgeRange.values.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final ageOption = AgeRange.values[index];
          return SelectionCard(
            label: _label(ageOption),
            isSelected: _selectedAge == ageOption,
            onTap: () => setState(() => _selectedAge = ageOption),
          );
        },
      ),
    );
  }

  String _label(AgeRange a) => switch (a) {
    AgeRange.under18 => 'Under 50',
    AgeRange.age18to29 => '50 - 64',
    AgeRange.age30to44 => '65 - 74',
    AgeRange.age45to59 => '75+',
    AgeRange.age60plus => 'Other',
  };
}
