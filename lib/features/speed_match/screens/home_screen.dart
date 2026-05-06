// screens/home_screen.dart
// Landing screen shown before game starts.

import 'package:flutter/material.dart';
import '../providers/speed_match_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../providers/game_provider.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _highScore = prefs.getInt('speed_match_high_score') ?? 0;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _startGame(BuildContext context) async {
    final provider = context.read<SpeedMatchProvider>();
    await provider.startGame();
    if (!mounted) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SpeedMatchGameScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                // ── Logo / Title ─────────────────────────────
                _GlowText(
                  '⚡',
                  fontSize: 72,
                  color: const Color(0xFF00D4FF),
                ),
                const SizedBox(height: 12),
                const _GlowText(
                  'SPEED\nMATCH',
                  fontSize: 42,
                  color: Colors.white,
                  letterSpacing: 6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Cognitive Speed Training',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // ── High score badge ─────────────────────────
                if (_highScore > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withOpacity(0.4),
                      ),
                      color: const Color(0xFFFFD700).withOpacity(0.06),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            Text(
                              'BEST SCORE',
                              style: TextStyle(
                                color:
                                    const Color(0xFFFFD700).withOpacity(0.6),
                                fontSize: 9,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              _highScore.toString(),
                              style: const TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                ],

                // ── How to play ──────────────────────────────
                _HowToPlayCard(),

                const Spacer(),

                // ── Start button ─────────────────────────────
                _StartButton(onTap: () => _startGame(context)),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HowToPlayCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        color: Colors.white.withOpacity(0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HOW TO PLAY',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 14),
          _Instruction(
            emoji: '👁',
            text: 'Watch the symbols appear one by one',
          ),
          const SizedBox(height: 10),
          _Instruction(
            emoji: '🔄',
            text: 'Does it match the PREVIOUS symbol?',
          ),
          const SizedBox(height: 10),
          _Instruction(
            emoji: '⚡',
            text: 'React fast — speed earns more points',
          ),
          const SizedBox(height: 10),
          _Instruction(
            emoji: '🔥',
            text: 'Build streaks for a score multiplier',
          ),
        ],
      ),
    );
  }
}

class _Instruction extends StatelessWidget {
  final String emoji;
  final String text;

  const _Instruction({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _StartButton extends StatefulWidget {
  final VoidCallback onTap;
  const _StartButton({required this.onTap});

  @override
  State<_StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<_StartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (_, child) => GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF0080CC), Color(0xFF00D4FF)],
            ),
            boxShadow: [
              BoxShadow(
                color:
                    const Color(0xFF00D4FF).withOpacity(_glow.value),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'START GAME',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final double letterSpacing;
  final TextAlign textAlign;

  const _GlowText(
    this.text, {
    required this.fontSize,
    required this.color,
    this.letterSpacing = 0,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        letterSpacing: letterSpacing,
        shadows: [
          Shadow(
            color: color.withOpacity(0.5),
            blurRadius: 20,
          ),
        ],
      ),
    );
  }
}
