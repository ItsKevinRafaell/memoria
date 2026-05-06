// lib/widgets/win_dialog.dart
// Celebratory modal shown when all pairs are matched.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/memory_game_provider.dart';

//import '../providers/game_provider.dart';
import '../utils/app_theme.dart';

class WinDialog extends StatelessWidget {
  const WinDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<MemoryGameProvider>();
    final best = game.bestScore;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF2D1B69)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.accent.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accent.withOpacity(0.3),
              blurRadius: 40,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy
            Text('🏆', style: const TextStyle(fontSize: 64))
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                  duration: 700.ms,
                )
                .then()
                .shake(hz: 2, duration: 300.ms),

            const SizedBox(height: 12),

            Text(
              'PUZZLE SOLVED!',
              style: GoogleFonts.orbitron(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.matched,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),

            const SizedBox(height: 24),

            // Stats
            _ResultRow(
              label: 'Moves',
              value: game.moves.toString(),
              icon: Icons.touch_app_rounded,
              color: AppTheme.flipped,
            ),
            const SizedBox(height: 10),
            _ResultRow(
              label: 'Time',
              value: game.formattedTime,
              icon: Icons.timer_rounded,
              color: AppTheme.accentLight,
            ),
            const SizedBox(height: 10),
            _ResultRow(
              label: 'Difficulty',
              value: game.difficulty.label,
              icon: Icons.bar_chart_rounded,
              color: AppTheme.accent,
            ),

            if (best != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.matched.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.matched.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, color: AppTheme.matched, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Best: ${best.moves} moves · ${best.formattedTime}',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.matched,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Same'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.accentLight,
                      side: BorderSide(color: AppTheme.accent.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<MemoryGameProvider>().startNewGame();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: const Text('New'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<MemoryGameProvider>().startNewGame();
                    },
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
