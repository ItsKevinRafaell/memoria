import 'package:flutter/material.dart';
import 'package:memoria/core/models/onboarding_model.dart';
import 'package:memoria/presentation/screens/profile/profile_screen.dart';
import 'package:memoria/presentation/screens/profile/subscription_dialog.dart';
import 'package:memoria/presentation/screens/splash_screen.dart';
import 'package:memoria/presentation/screens/onboarding/onboarding_name_screen.dart';
import 'package:memoria/presentation/screens/onboarding/onboarding_age_screen.dart';
import 'package:memoria/presentation/screens/onboarding/onboarding_memory_screen.dart';
import 'package:memoria/presentation/screens/onboarding/onboarding_exercise_screen.dart';
import 'package:memoria/presentation/screens/home/home_dashboard_screen.dart';
import 'package:memoria/presentation/screens/stats/stats_screen.dart';
import 'package:memoria/presentation/screens/training/game_catalog_screen.dart';
import 'core/theme/app_theme.dart';
import 'package:memoria/presentation/screens/checkin/daily_checkin_sheet.dart';

void main() {
  runApp(const MemoriaApp());
}

class MemoriaApp extends StatelessWidget {
  const MemoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memoria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.background,
        colorSchemeSeed: AppColors.primary,
        useMaterial3: true,
      ),
      home: const AppNavigator(),
    );
  }
}

// ─────────────────────────────────────────────
// Root Navigator — manages app flow state
// ─────────────────────────────────────────────
enum _AppScreen { splash, onboarding, main }

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  _AppScreen _screen = _AppScreen.splash;

  String _userName = '';
  AgeRange? _age;
  MemoryBaseline? _memory;
  ExerciseFrequency? _exercise;
  int _onboardingStep = 1;
  int _navIndex = 0;

  // ADD THIS LINE:
  bool _pendingInitialCheckIn = false;

  void _goToOnboarding() => setState(() {
    _screen = _AppScreen.onboarding;
    _onboardingStep = 1;
  });

  void _goToMain() => setState(() => _screen = _AppScreen.main);

  // ── Onboarding step callbacks ──
  void _onNameContinue(String name) => setState(() {
    _userName = name;
    _onboardingStep = 2;
  });

  void _onAgeContinue(AgeRange age) => setState(() {
    _age = age;
    _onboardingStep = 3;
  });

  void _onMemoryContinue(MemoryBaseline memory) => setState(() {
    _memory = memory;
    _onboardingStep = 4;
  });

  void _onExerciseFinish(ExerciseFrequency exercise) {
    setState(() {
      _exercise = exercise;
      _pendingInitialCheckIn =
          true; // Set flag to true right before going to Main!
      _screen = _AppScreen.main;
    });
  }

  void _onboardingBack() {
    if (_onboardingStep > 1) setState(() => _onboardingStep--);
  }

  @override
  Widget build(BuildContext context) {
    return switch (_screen) {
      _AppScreen.splash => SplashScreen(onStartJourney: _goToOnboarding),
      _AppScreen.onboarding => _buildOnboardingStep(),
      _AppScreen.main => _buildMainShell(),
    };
  }

  Widget _buildOnboardingStep() {
    return switch (_onboardingStep) {
      1 => OnboardingNameScreen(
        onContinue: _onNameContinue,
        onBack: _goToOnboarding,
      ),
      2 => OnboardingAgeScreen(
        onContinue: _onAgeContinue,
        onBack: _onboardingBack,
      ),
      3 => OnboardingMemoryScreen(
        onContinue: _onMemoryContinue,
        onBack: _onboardingBack,
      ),
      4 => OnboardingExerciseScreen(
        onFinish: _onExerciseFinish,
        onBack: _onboardingBack,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildMainShell() {
    return switch (_navIndex) {
      0 => HomeDashboardScreen(
        userName: _userName.isNotEmpty ? _userName : 'Friend',
        streak: 14,
        currentNavIndex: _navIndex,
        onNavTap: (i) => setState(() => _navIndex = i),
        autoShowCheckIn: _pendingInitialCheckIn,
        onCheckIn: () {
          if (_pendingInitialCheckIn) {
            setState(() => _pendingInitialCheckIn = false);
          }

          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => DailyCheckInDialog(
              onSubmit: (MoodLevel mood, SleepDuration sleep) {
                // The dialog handles popping itself.
                // We wait 300ms for the animation to clear, then show the Subs Modal!
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => const SubscriptionDialog(),
                    );
                  }
                });
              },
            ),
          );
        },
      ),
      1 => GameCatalogScreen(
        currentNavIndex: _navIndex,
        onNavTap: (i) => setState(() => _navIndex = i),
      ),
      2 => StatsScreen(
        currentNavIndex: _navIndex,
        onNavTap: (i) => setState(() => _navIndex = i),
      ),
      3 => ProfileScreen(
        userName: _userName.isNotEmpty ? _userName : 'Friend',
        ageRange: '', // Can map your AgeRange enum here later
        // --- FIX: Added these two lines so the navbar works! ---
        currentNavIndex: _navIndex,
        onNavTap: (i) => setState(() => _navIndex = i),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
