// widgets/control_buttons.dart
// Big MATCH / NOT MATCH buttons with press animations.

import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final VoidCallback? onMatch;
  final VoidCallback? onNotMatch;
  final bool enabled;

  const ControlButtons({
    super.key,
    required this.onMatch,
    required this.onNotMatch,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // NOT MATCH button
          Expanded(
            child: _GameButton(
              label: 'NOT MATCH',
              icon: Icons.close_rounded,
              color: const Color(0xFFFF4466),
              glowColor: const Color(0xFFFF4466),
              onTap: enabled ? onNotMatch : null,
            ),
          ),
          const SizedBox(width: 16),
          // MATCH button
          Expanded(
            child: _GameButton(
              label: 'MATCH',
              icon: Icons.check_rounded,
              color: const Color(0xFF00FF9F),
              glowColor: const Color(0xFF00FF9F),
              onTap: enabled ? onMatch : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _GameButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color glowColor;
  final VoidCallback? onTap;

  const _GameButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.glowColor,
    required this.onTap,
  });

  @override
  State<_GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<_GameButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onTap != null) _ctrl.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _ctrl.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onTap == null;

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.35 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: widget.color.withOpacity(0.12),
              border: Border.all(
                color: widget.color.withOpacity(0.6),
                width: 2,
              ),
              boxShadow: isDisabled
                  ? null
                  : [
                      BoxShadow(
                        color: widget.glowColor.withOpacity(0.18),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: widget.color, size: 28),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
