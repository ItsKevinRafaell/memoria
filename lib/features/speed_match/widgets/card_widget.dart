// widgets/card_widget.dart
// Animated card that displays the current symbol.
// Animates in on each new card and flashes on feedback.

import 'package:flutter/material.dart';
import '../models/game_state.dart';

class CardWidget extends StatefulWidget {
  final CardSymbol? symbol;
  final ResponseResult? lastResult;
  final bool isFirstCard;

  const CardWidget({
    super.key,
    required this.symbol,
    required this.lastResult,
    required this.isFirstCard,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  CardSymbol? _displayedSymbol;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _scaleAnim = Tween<double>(begin: 0.70, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );

    _displayedSymbol = widget.symbol;
    if (widget.symbol != null) _ctrl.forward();
  }

  @override
  void didUpdateWidget(CardWidget old) {
    super.didUpdateWidget(old);
    if (widget.symbol != old.symbol) {
      _displayedSymbol = widget.symbol;
      _ctrl.reset();
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _cardColor(BuildContext context) {
    if (widget.lastResult == null) {
      return const Color(0xFF1A1A2E);
    }
    switch (widget.lastResult!) {
      case ResponseResult.correct:
        return const Color(0xFF0D3B2E);
      case ResponseResult.incorrect:
      case ResponseResult.timeout:
        return const Color(0xFF3B0D0D);
    }
  }

  Color _borderColor() {
    if (widget.lastResult == null) {
      return const Color(0xFF00D4FF).withOpacity(0.3);
    }
    switch (widget.lastResult!) {
      case ResponseResult.correct:
        return const Color(0xFF00FF9F);
      case ResponseResult.incorrect:
      case ResponseResult.timeout:
        return const Color(0xFFFF4466);
    }
  }

  Color _symbolColor() {
    if (widget.lastResult == null) return const Color(0xFF00D4FF);
    switch (widget.lastResult!) {
      case ResponseResult.correct:
        return const Color(0xFF00FF9F);
      case ResponseResult.incorrect:
      case ResponseResult.timeout:
        return const Color(0xFFFF4466);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Opacity(
          opacity: _opacityAnim.value,
          child: Transform.scale(
            scale: _scaleAnim.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: _cardColor(context),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: _borderColor(),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _borderColor().withOpacity(0.25),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: _displayedSymbol == null
                    ? const SizedBox.shrink()
                    : AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 100,
                          color: _symbolColor(),
                          shadows: [
                            Shadow(
                              color: _symbolColor().withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Text(_displayedSymbol!.emoji),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Shows the "previous card" as a smaller ghost in the top corner
class PreviousCardGhost extends StatelessWidget {
  final CardSymbol? symbol;

  const PreviousCardGhost({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    if (symbol == null) return const SizedBox.shrink();
    return AnimatedOpacity(
      opacity: symbol != null ? 0.45 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF00D4FF).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            symbol!.emoji,
            style: const TextStyle(
              fontSize: 30,
              color: Color(0xFF5A7A8A),
            ),
          ),
        ),
      ),
    );
  }
}
