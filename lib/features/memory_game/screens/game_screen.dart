// lib/screens/game_screen.dart
// Root screen of the app — composes all widgets and listens for win state.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/memory_game_provider.dart';

import '../utils/app_theme.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/game_board.dart';
import '../widgets/stats_bar.dart';
import '../widgets/win_dialog.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<MemoryGameProvider>();

    // Show win dialog once when the game ends
    if (game.isGameOver && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ChangeNotifierProvider.value(
            value: game,
            child: const WinDialog(),
          ),
        ).then((_) => _dialogShown = false);
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ──────────────────────────────────────
                _Header().animate().fadeIn(duration: 400.ms).slideY(begin: -0.3),

                const SizedBox(height: 16),

                // ── Stats HUD ───────────────────────────────────
                const StatsBar()
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 400.ms),

                const SizedBox(height: 14),

                // ── Difficulty selector ──────────────────────────
                Center(
                  child: const DifficultySelector()
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 400.ms),
                ),

                const SizedBox(height: 16),

                // ── Game board ───────────────────────────────────
                Expanded(
                  child: const GameBoard()
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms),
                ),

                const SizedBox(height: 14),

                // ── Action buttons ───────────────────────────────
                _ActionRow()
                    .animate()
                    .fadeIn(delay: 250.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Header
// ────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Glowing logo mark
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: AppTheme.accentGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withOpacity(0.5),
                blurRadius: 14,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MEMORY',
              style: GoogleFonts.orbitron(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: 3,
              ),
            ),
            Text(
              'PAIRS',
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.accent,
                letterSpacing: 5,
              ),
            ),
          ],
        ),
        const Spacer(),
        // High score chip
        _HighScoreChip(),
      ],
    );
  }
}

class _HighScoreChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final best = context.watch<MemoryGameProvider>().bestScore;
    if (best == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.matched.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: AppTheme.matched, size: 14),
          const SizedBox(width: 4),
          Text(
            '${best.moves}m',
            style: GoogleFonts.orbitron(
              fontSize: 12,
              color: AppTheme.matched,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Action buttons row
// ────────────────────────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Restart button
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('RESTART'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accentLight,
              side: BorderSide(color: AppTheme.accent.withOpacity(0.4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                fontSize: 13,
              ),
            ),
            onPressed: () => context.read<MemoryGameProvider>().startNewGame(),
          ),
        ),
        const SizedBox(width: 12),
        // New game button (same as restart but styled differently)
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('NEW GAME'),
            onPressed: () => context.read<MemoryGameProvider>().startNewGame(),
          ),
        ),
      ],
    );
  }
}
