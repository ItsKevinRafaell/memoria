// lib/widgets/game_card.dart
// A single memory card with a 3-D flip animation.
//
// Animation approach:
//   • We use an AnimationController + CurvedAnimation for smooth easing.
//   • The card rotates on the Y-axis: 0° = back, 180° = front.
//   • We swap which "face" is rendered at the 90° midpoint (the card is
//     edge-on and invisible, so the swap is seamless).

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/card_model.dart';
import '../utils/app_theme.dart';

class GameCard extends StatefulWidget {
  final CardModel card;
  final VoidCallback onTap;
  final double size;

  const GameCard({
    super.key,
    required this.card,
    required this.onTap,
    this.size = 72,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _flipAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    // Set initial state without animation
    if (widget.card.isFaceUp || widget.card.isMatched) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(GameCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shouldBeUp = widget.card.isFaceUp || widget.card.isMatched;
    final wasUp = oldWidget.card.isFaceUp || oldWidget.card.isMatched;

    if (shouldBeUp && !wasUp) {
      _controller.forward();
    } else if (!shouldBeUp && wasUp) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, _) {
          // At 0.5 the card is edge-on; we switch to the front face after that.
          final showFront = _flipAnimation.value >= 0.5;
          final angle = _flipAnimation.value * math.pi;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(angle),
            child: showFront
                ? Transform( // Counter-rotate so text reads correctly
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: _FrontFace(card: widget.card, size: widget.size),
                  )
                : _BackFace(size: widget.size),
          );
        },
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Front face — shows the emoji icon
// ────────────────────────────────────────────────────────────────────────────

class _FrontFace extends StatelessWidget {
  final CardModel card;
  final double size;

  const _FrontFace({required this.card, required this.size});

  @override
  Widget build(BuildContext context) {
    final isMatched = card.isMatched;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: isMatched
            ? AppTheme.cardMatchedGradient
            : AppTheme.cardFrontGradient,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMatched
              ? AppTheme.matched.withOpacity(0.8)
              : AppTheme.flipped.withOpacity(0.4),
          width: isMatched ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isMatched ? AppTheme.matched : AppTheme.accent)
                .withOpacity(0.35),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          card.content.emoji,
          style: TextStyle(fontSize: size * 0.42),
        )
            .animate(target: isMatched ? 1 : 0)
            .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15))
            .then()
            .scale(begin: const Offset(1.15, 1.15), end: const Offset(1, 1)),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Back face — decorative pattern
// ────────────────────────────────────────────────────────────────────────────

class _BackFace extends StatelessWidget {
  final double size;

  const _BackFace({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.cardBack,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.accent.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withOpacity(0.15),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Corner decorations
          Positioned(
            top: 6, left: 6,
            child: _cornerDot(),
          ),
          Positioned(
            top: 6, right: 6,
            child: _cornerDot(),
          ),
          Positioned(
            bottom: 6, left: 6,
            child: _cornerDot(),
          ),
          Positioned(
            bottom: 6, right: 6,
            child: _cornerDot(),
          ),
          // Centre symbol
          Center(
            child: Text(
              '✦',
              style: TextStyle(
                fontSize: size * 0.32,
                color: AppTheme.accent.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerDot() => Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: AppTheme.accent.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
      );
}
