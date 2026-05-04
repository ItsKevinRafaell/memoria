import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:memoria/presentation/widgets/layout/onboarding_template.dart';

class OnboardingNameScreen extends StatefulWidget {
  final void Function(String name) onContinue;
  final VoidCallback onBack;

  const OnboardingNameScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<OnboardingNameScreen> createState() => _OnboardingNameScreenState();
}

class _OnboardingNameScreenState extends State<OnboardingNameScreen> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasInput = _ctrl.text.trim().isNotEmpty;

    return OnboardingTemplate(
      currentStep: 1,
      onBack: widget.onBack,
      // Passing the custom top icon to the template
      topIcon: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Color(0xFFDBEAFE),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.waving_hand_rounded,
          color: AppColors.primary,
          size: 32,
        ),
      ),
      title: 'What should we call you?',
      subtitle:
          'We\'d love to know your name so we can personalize your Memoria experience.',
      isButtonEnabled: hasInput,
      onContinue: () => widget.onContinue(_ctrl.text.trim()),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _ctrl,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your name',
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 24,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
