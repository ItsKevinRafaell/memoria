import 'package:flutter/material.dart';
import 'package:memoria/core/models/onboarding_model.dart';
import 'package:memoria/presentation/widgets/layout/onboarding_template.dart';
import 'package:memoria/presentation/widgets/cards/selection_card.dart';

class OnboardingExerciseScreen extends StatefulWidget {
  final void Function(ExerciseFrequency exercise) onFinish;
  final VoidCallback onBack;

  const OnboardingExerciseScreen({
    super.key,
    required this.onFinish,
    required this.onBack,
  });

  @override
  State<OnboardingExerciseScreen> createState() =>
      _OnboardingExerciseScreenState();
}

class _OnboardingExerciseScreenState extends State<OnboardingExerciseScreen> {
  ExerciseFrequency? _selectedExercise;

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      currentStep: 4,
      onBack: widget.onBack,
      title: 'How often do you exercise?',
      subtitle:
          'Help us tailor your daily goals by telling us about your current routine.',
      buttonLabel: 'Finish Setup', // Overriding the default "Continue"
      isButtonEnabled: _selectedExercise != null,
      onContinue: () => widget.onFinish(_selectedExercise!),
      child: ListView.separated(
        itemCount: ExerciseFrequency.values.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final exerciseOption = ExerciseFrequency.values[index];
          return SelectionCard(
            label: _label(exerciseOption),
            isSelected: _selectedExercise == exerciseOption,
            onTap: () => setState(() => _selectedExercise = exerciseOption),
          );
        },
      ),
    );
  }

  String _label(ExerciseFrequency e) => switch (e) {
    ExerciseFrequency.never => 'Never',
    ExerciseFrequency.rarely => 'Rarely',
    ExerciseFrequency.sometimes => '1-2 times a week',
    ExerciseFrequency.often => '3+ times a week',
    ExerciseFrequency.daily => 'Daily',
  };
}
