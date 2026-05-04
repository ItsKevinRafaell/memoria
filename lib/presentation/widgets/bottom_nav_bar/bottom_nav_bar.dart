// lib/presentation/widgets/bottom_nav_bar/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:memoria/core/theme/app_theme.dart';

/// Navigation item model
class NavItem {
  final IconData icon;
  final String label;

  const NavItem({required this.icon, required this.label});
}

/// The 4 fixed nav items (swap icons for your actual asset icons)
const List<NavItem> _navItems = [
  NavItem(icon: Icons.home_rounded, label: 'Home'),
  NavItem(icon: Icons.model_training_rounded, label: 'Training'),
  NavItem(icon: Icons.bar_chart_rounded, label: 'Stats'),
  NavItem(icon: Icons.person_rounded, label: 'Profile'),
];

/// ─────────────────────────────────────────
///  AppBottomNavBar
///
///  Stateless — receives [currentIndex] and
///  [onTap] from parent (BLoC / Provider).
/// ─────────────────────────────────────────
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
              (index) => _NavBarItem(
                item: _navItems[index],
                isActive: currentIndex == index,
                onTap: () => onTap(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────
///  Single nav item
/// ─────────────────────────────────────────
class _NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.navInactive;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppTextStyles.navLabel.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
