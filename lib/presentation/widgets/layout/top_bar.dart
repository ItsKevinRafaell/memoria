import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData actionIcon;
  final VoidCallback onActionTap;

  const TopBar({
    super.key,
    this.title = 'Memoria',
    this.actionIcon = Icons.notifications_none_rounded, // Defaults to the bell
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=47',
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(actionIcon, color: AppColors.textPrimary),
          onPressed: onActionTap,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
