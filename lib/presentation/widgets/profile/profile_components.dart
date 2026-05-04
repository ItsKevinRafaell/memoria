import 'package:flutter/material.dart';
import 'package:memoria/presentation/screens/profile/subscription_dialog.dart';

// --- 1. Profile Header (Avatar & Details) ---
class ProfileHeader extends StatelessWidget {
  final String userName;
  final String email;

  const ProfileHeader({super.key, required this.userName, required this.email});

  @override
  Widget build(BuildContext context) {
    const darkText = Color(0xFF0F172A);
    const primaryBlue = Color(0xFF2563EB);

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=47',
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userName.isNotEmpty ? userName : 'Kevin',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: darkText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. Reusable Menu Tile ---
class MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const MenuTile({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF475569)),
          ],
        ),
      ),
    );
  }
}

// --- 3. Upgrade Card (Now triggers the Subscription Dialog!) ---
class UpgradeCard extends StatelessWidget {
  const UpgradeCard({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2563EB);
    const darkText = Color(0xFF0F172A);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Plan: Free',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              Icon(
                Icons.workspace_premium_rounded,
                color: primaryBlue,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Upgrade to unlock all features.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC).withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LOCKED FEATURES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 12),
                _buildLockedItem('Advanced AI Insights'),
                const SizedBox(height: 8),
                _buildLockedItem('All Brain Training Games'),
              ],
            ),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // --- Triggers the Subscription Modal! ---
                showDialog(
                  context: context,
                  builder: (_) => const SubscriptionDialog(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              child: const Text(
                'Upgrade to Premium',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedItem(String text) {
    return Row(
      children: [
        const Icon(
          Icons.lock_outline_rounded,
          color: Color(0xFFDC2626),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}
