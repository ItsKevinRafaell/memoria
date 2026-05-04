import 'package:flutter/material.dart';
import 'package:memoria/presentation/widgets/layout/memoria_bottom_nav.dart';
import 'package:memoria/presentation/widgets/layout/top_bar.dart';
import 'package:memoria/presentation/widgets/stats/stat_card.dart';
import '../../../core/theme/app_theme.dart';

class HomeDashboardScreen extends StatefulWidget {
  final String userName;
  final int streak;
  final VoidCallback onCheckIn;
  final bool autoShowCheckIn;
  final int currentNavIndex;
  final Function(int) onNavTap;

  const HomeDashboardScreen({
    super.key,
    required this.userName,
    this.streak = 14,
    required this.onCheckIn,
    this.autoShowCheckIn = false,
    this.currentNavIndex = 0,
    required this.onNavTap,
  });

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.autoShowCheckIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onCheckIn());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TopBar(onActionTap: () => print("Notifications tapped!")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              'Hello, ${widget.userName}!',
              style: AppTextStyles.h1.copyWith(letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready to train your mind?',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 32),

            // Daily Challenge
            _DailyChallengeCard(onPlay: widget.onCheckIn),
            const SizedBox(height: 24),

            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.local_fire_department_rounded,
                    iconBgColor: const Color(0xFFFFF0E0),
                    iconColor: const Color(0xFFD97706),
                    title: 'CURRENT\nSTREAK',
                    value: '${widget.streak} Days',
                    valueColor: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: StatCard(
                    icon: Icons.trending_up_rounded,
                    iconBgColor: Color(0xFFE0F2FE),
                    iconColor: Color(0xFF0284C7),
                    title: 'MEMORY\nBASELINE',
                    value: '+12%',
                    valueColor: AppColors.primary,
                    subtitle: 'vs Last Month',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Focus Areas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your Focus Areas', style: AppTextStyles.h2),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Focus Cards List
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                children: const [
                  FocusCard(
                    icon: Icons.psychology_rounded,
                    iconBgColor: Color(0xFFDBEAFE),
                    iconColor: AppColors.primary,
                    title: 'Memory',
                    subtitle: 'Recall & Retention',
                    progress: 0.65,
                    progressColor: AppColors.primary,
                    level: 'Level 4',
                    percentage: '65%',
                  ),
                  SizedBox(width: 16),
                  FocusCard(
                    icon: Icons.extension_rounded,
                    iconBgColor: Color(0xFFFFF0E0),
                    iconColor: Color(0xFFD97706),
                    title: 'Problem Solving',
                    subtitle: 'Logic & Analysis',
                    progress: 0.35,
                    progressColor: Color(0xFFD97706),
                    level: 'Level 2',
                    percentage: '35%',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: MemoriaBottomNav(
        currentIndex: widget.currentNavIndex,
        onTap: widget.onNavTap,
      ),
    );
  }
}

// Private widget just for the Home Screen
class _DailyChallengeCard extends StatelessWidget {
  final VoidCallback onPlay;

  const _DailyChallengeCard({required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Daily Challenge',
              style: TextStyle(
                color: Color(0xFFD97706),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Today\'s Brain Workout', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 16, color: Colors.blueGrey[600]),
              const SizedBox(width: 6),
              Text(
                '10 mins',
                style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onPlay,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Play Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
