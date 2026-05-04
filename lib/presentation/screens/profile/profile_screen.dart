import 'package:flutter/material.dart';
import 'package:memoria/presentation/widgets/layout/top_bar.dart';
import 'package:memoria/presentation/widgets/profile/profile_components.dart';
import '../../../core/theme/app_theme.dart';

import '../../widgets/layout/memoria_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String email;
  final String ageRange;
  final int currentNavIndex;
  final Function(int)? onNavTap;
  final VoidCallback? onLogOut;

  const ProfileScreen({
    super.key,
    required this.userName,
    this.email = 'kevin@example.com',
    this.ageRange = '',
    this.currentNavIndex = 3,
    this.onNavTap,
    this.onLogOut,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // 1. Reusable App Bar
      appBar: TopBar(
        onActionTap: () => print("Settings tapped!"),
        actionIcon: Icons.settings_outlined,
      ),

      // 2. Main Content
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Extracted Header
            ProfileHeader(userName: userName, email: email),
            const SizedBox(height: 32),

            // Extracted Menu Items
            MenuTile(
              icon: Icons.manage_accounts_rounded,
              iconBgColor: const Color(0xFFE0F2FE),
              iconColor: AppColors.primary,
              title: 'Account Details',
              subtitle: 'Email, Password, Security',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            MenuTile(
              icon: Icons.notifications_none_rounded,
              iconBgColor: const Color(0xFFE0F2FE),
              iconColor: AppColors.primary,
              title: 'Notifications & Reminders',
              subtitle: 'Push, Email, Daily goals',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            MenuTile(
              icon: Icons.help_outline_rounded,
              iconBgColor: const Color(0xFFFFF0E0),
              iconColor: const Color(0xFFD97706),
              title: 'Help & Support',
              subtitle: 'FAQ, Contact us, Guides',
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // Extracted Upgrade Card
            const UpgradeCard(),
            const SizedBox(height: 32),

            // Log Out Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: onLogOut,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626), // Red text
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),

      // 3. Reusable Bottom Nav Bar
      bottomNavigationBar: MemoriaBottomNav(
        currentIndex: currentNavIndex,
        onTap: onNavTap ?? (index) {},
      ),
    );
  }
}
