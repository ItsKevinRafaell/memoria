import 'package:flutter/material.dart';
import 'package:memoria/presentation/widgets/layout/top_bar.dart';
import 'package:memoria/presentation/widgets/stats/stats_components.dart';
import '../../../core/theme/app_theme.dart';
// Note: Ensure your file paths match these imports!
import '../../widgets/layout/memoria_bottom_nav.dart';
// Import the new local components file you just made:

class StatsScreen extends StatefulWidget {
  final int currentNavIndex;
  final Function(int)? onNavTap;

  const StatsScreen({super.key, this.currentNavIndex = 2, this.onNavTap});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // 1. Reusable App Bar
      appBar: TopBar(
        onActionTap: () => print("Settings tapped!"),
        actionIcon: Icons.settings_outlined, // Overrides the default bell icon
      ),

      // 2. Main Content
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader('Cognitive Performance'),
            SizedBox(height: 16),
            CognitivePerformanceCard(),
            SizedBox(height: 32),

            SectionHeader('Personal Baseline'),
            SizedBox(height: 16),
            PersonalBaselineCard(),
            SizedBox(height: 32),

            SectionHeader('Focus Areas'),
            SizedBox(height: 16),
            FocusAreasListCard(),
            SizedBox(height: 32),

            SectionHeader('AI Insights'),
            SizedBox(height: 16),
            AIInsightsCard(),
            SizedBox(height: 32),
          ],
        ),
      ),

      // 3. Reusable Bottom Nav
      bottomNavigationBar: MemoriaBottomNav(
        currentIndex: widget.currentNavIndex,
        onTap: widget.onNavTap ?? (index) {},
      ),
    );
  }
}
