// screens/result_screen.dart
// Shown after the game ends. Displays all session metrics.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/speed_match_provider.dart';
import '../models/game_state.dart';
//import '../providers/game_provider.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<SpeedMatchProvider>().state;
    final isNewHighScore = state.score >= state.highScore && state.score > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),

                  // ── Result header ──────────────────────────
                  if (isNewHighScore) ...[
                    const Text('🏆', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    const Text(
                      'NEW HIGH SCORE!',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                  ] else ...[
                    const Text('⚡', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text(
                      'GAME OVER',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // ── Final score ────────────────────────────
                  Text(
                    state.score.toString(),
                    style: TextStyle(
                      color: const Color(0xFF00D4FF),
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF00D4FF).withOpacity(0.5),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'POINTS',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 12,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Stats grid ─────────────────────────────
                  _StatsGrid(state: state),

                  const Spacer(),

                  // ── Performance grade ──────────────────────
                  _PerformanceBadge(state: state),

                  const SizedBox(height: 28),

                  // ── Action buttons ─────────────────────────
                  _ActionButtons(state: state),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final GameState state;
  const _StatsGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _StatCell(
          label: 'MAX STREAK',
          value: state.maxStreak.toString(),
          icon: '🔥',
          color: const Color(0xFFFF9F00),
        ),
        _StatCell(
          label: 'ACCURACY',
          value: state.accuracyPercent,
          icon: '🎯',
          color: const Color(0xFF00FF9F),
        ),
        _StatCell(
          label: 'AVG REACTION',
          value: state.averageReactionTimeMs > 0
              ? '${state.averageReactionTimeMs}ms'
              : '—',
          icon: '⏱',
          color: const Color(0xFF00D4FF),
        ),
        _StatCell(
          label: 'BEST REACTION',
          value: state.bestReactionTimeMs > 0
              ? '${state.bestReactionTimeMs}ms'
              : '—',
          icon: '⚡',
          color: const Color(0xFFCC00FF),
        ),
        _StatCell(
          label: 'ROUNDS',
          value: state.totalAnswered.toString(),
          icon: '🃏',
          color: Colors.white70,
        ),
        _StatCell(
          label: 'MAX LEVEL',
          value: 'L${state.difficultyLevel}',
          icon: '📈',
          color: const Color(0xFFFFD700),
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;

  const _StatCell({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
        color: color.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color.withOpacity(0.6),
                    fontSize: 8,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceBadge extends StatelessWidget {
  final GameState state;
  const _PerformanceBadge({required this.state});

  (String grade, String label, Color color) _getGrade() {
    final acc = state.accuracy;
    final avgRt = state.averageReactionTimeMs;

    if (acc >= 0.90 && avgRt < 600) {
      return ('S', 'NEURAL LIGHTNING', const Color(0xFFFFD700));
    } else if (acc >= 0.80 && avgRt < 800) {
      return ('A', 'REFLEX MASTER', const Color(0xFF00D4FF));
    } else if (acc >= 0.70 && avgRt < 1000) {
      return ('B', 'SHARP MIND', const Color(0xFF00FF9F));
    } else if (acc >= 0.60) {
      return ('C', 'KEEP TRAINING', const Color(0xFFFF9F00));
    } else {
      return ('D', 'NEEDS WORK', const Color(0xFFFF4466));
    }
  }

  @override
  Widget build(BuildContext context) {
    final (grade, label, color) = _getGrade();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        color: color.withOpacity(0.06),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            grade,
            style: TextStyle(
              color: color,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              shadows: [Shadow(color: color.withOpacity(0.5), blurRadius: 16)],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PERFORMANCE',
                style: TextStyle(
                  color: color.withOpacity(0.5),
                  fontSize: 9,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final GameState state;
  const _ActionButtons({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Play again
        GestureDetector(
          onTap: () async {
            final provider = context.read<SpeedMatchProvider>();
            await provider.startGame();
          },
          child: Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF0080CC), Color(0xFF00D4FF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.3),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'PLAY AGAIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Home button
        GestureDetector(
          onTap: () {
            context.read<SpeedMatchProvider>().resetGame();
            Navigator.of(context).popUntil((r) => r.isFirst);
          },
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            child: Center(
              child: Text(
                'HOME',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
