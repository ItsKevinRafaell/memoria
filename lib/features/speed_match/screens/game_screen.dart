import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/speed_match_provider.dart';
import '../models/game_state.dart';
import '../widgets/card_widget.dart';
import '../widgets/control_buttons.dart';
import '../widgets/score_display.dart';
import 'result_screen.dart';

class SpeedMatchGameScreen extends StatefulWidget {
  const SpeedMatchGameScreen({super.key});

  @override
  State<SpeedMatchGameScreen> createState() => _SpeedMatchGameScreenState();
}

class _SpeedMatchGameScreenState extends State<SpeedMatchGameScreen> {
  bool _navigatedToResult = false;

  @override
  void initState() {
    super.initState();

    // ✅ Start game ONLY when screen is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpeedMatchProvider>().startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeedMatchProvider>(
      builder: (context, provider, _) {
        final state = provider.state;

        // ✅ Prevent multiple navigation triggers
        if (state.phase == GamePhase.finished && !_navigatedToResult) {
          _navigatedToResult = true;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ResultScreen(),
                transitionsBuilder: (_, anim, __, child) => FadeTransition(
                  opacity: anim,
                  child: child,
                ),
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          });
        }

        final bool inputEnabled =
            state.phase == GamePhase.showing && state.cardIndex > 1;

        return Scaffold(
          backgroundColor: const Color(0xFF0A0A14),
          body: SafeArea(
            child: Column(
              children: [
                // ── HUD / Score ──────────────────────────────
                ScoreDisplay(
                  score: state.score,
                  streak: state.streak,
                  accuracy: state.accuracyPercent,
                  timeLimitMs: state.timeLimitMs,
                  difficultyLevel: state.difficultyLevel,
                ),

                // ── Timer bar ────────────────────────────────
                TimerProgressBar(
                  progress: state.timerProgress,
                  timeLimitMs: state.timeLimitMs,
                ),

                // ── Streak fire indicator ────────────────────
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: StreakIndicator(streak: state.streak),
                ),

                const Spacer(),

                // ── Previous card ghost ──────────────────────
                if (state.cardIndex > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'PREVIOUS',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.25),
                            fontSize: 9,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        PreviousCardGhost(symbol: state.previousSymbol),
                      ],
                    ),
                  ),

                // ── Main card ────────────────────────────────
                CardWidget(
                  symbol: state.currentSymbol,
                  lastResult: state.lastResult,
                  isFirstCard: state.cardIndex <= 1,
                ),

                // ── Feedback label ───────────────────────────
                SizedBox(
                  height: 48,
                  child: Center(
                    child: _FeedbackLabel(result: state.lastResult),
                  ),
                ),

                // ── First card hint ──────────────────────────
                if (state.cardIndex <= 1 && state.phase == GamePhase.showing)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Remember this card...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 13,
                        letterSpacing: 0.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                const Spacer(),

                // ── Control buttons ──────────────────────────
                ControlButtons(
                  onMatch: () => provider.onMatch(),
                  onNotMatch: () => provider.onNotMatch(),
                  enabled: inputEnabled,
                ),

                const SizedBox(height: 24),

                // ── Quit button ──────────────────────────────
                TextButton(
                  onPressed: () {
                    provider.resetGame();
                    Navigator.of(context).popUntil((route) => route.isFirst); // go back to previous screen
                  },
                  child: Text(
                    'QUIT GAME',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.25),
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Feedback Label
// ─────────────────────────────────────────────

class _FeedbackLabel extends StatelessWidget {
  final ResponseResult? result;
  const _FeedbackLabel({required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) return const SizedBox.shrink();

    final (String text, Color color) = switch (result!) {
      ResponseResult.correct => ('✓  CORRECT', const Color(0xFF00FF9F)),
      ResponseResult.incorrect => ('✗  WRONG', const Color(0xFFFF4466)),
      ResponseResult.timeout => ('⏱  TOO SLOW', const Color(0xFFFF9F00)),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: Text(
        text,
        key: ValueKey(result),
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          shadows: [
            Shadow(color: color.withOpacity(0.6), blurRadius: 12),
          ],
        ),
      ),
    );
  }
}