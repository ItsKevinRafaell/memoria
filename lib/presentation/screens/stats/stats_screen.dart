import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  final int currentNavIndex;
  final Function(int)? onNavTap;

  const StatsScreen({
    super.key,
    this.currentNavIndex = 2, // Default to 2 (Stats)
    this.onNavTap,
  });

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF8FAFC);
    const darkText = Color(0xFF0F172A);
    const primaryBlue = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'),
            ),
            const Text(
              'Memoria',
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: darkText),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _SectionTitle('Cognitive Performance'),
            SizedBox(height: 16),
            _CognitivePerformanceCard(),
            SizedBox(height: 32),

            _SectionTitle('Personal Baseline'),
            SizedBox(height: 16),
            _PersonalBaselineCard(),
            SizedBox(height: 32),

            _SectionTitle('Focus Areas'),
            SizedBox(height: 16),
            _FocusAreasCard(),
            SizedBox(height: 32),

            _SectionTitle('AI Insights'),
            SizedBox(height: 16),
            _AIInsightsCard(),
            SizedBox(height: 32),
          ],
        ),
      ),
      // --- ADDED BOTTOM NAV BAR HERE ---
      bottomNavigationBar: _MemoriaBottomNav(
        currentIndex: widget.currentNavIndex,
        onTap: widget.onNavTap ?? (index) {},
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sub-Widgets for StatsScreen
// ─────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
        letterSpacing: -0.5,
      ),
    );
  }
}

class _CognitivePerformanceCard extends StatelessWidget {
  const _CognitivePerformanceCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildChartRow('Excellent', true),
          const SizedBox(height: 40),
          _buildChartRow('Great', true),
          const SizedBox(height: 40),
          _buildChartRow('Good', false, isLast: true),
        ],
      ),
    );
  }

  Widget _buildChartRow(
    String label,
    bool showDottedLine, {
    bool isLast = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: isLast
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DayLabel('Mon'),
                    _DayLabel('Tue'),
                    _DayLabel('Wed'),
                    _DayLabel('Thu'),
                    _DayLabel('Fri'),
                    _DayLabel('Sat'),
                    _DayLabel('Sun'),
                  ],
                )
              : _DottedLine(),
        ),
      ],
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String day;
  const _DayLabel(this.day);
  @override
  Widget build(BuildContext context) {
    return Text(
      day,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF475569),
      ),
    );
  }
}

class _DottedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / 8).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(
            dashCount,
            (_) => const SizedBox(
              width: 4,
              height: 1.5,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFE2E8F0)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PersonalBaselineCard extends StatelessWidget {
  const _PersonalBaselineCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBaselineRow(
            icon: Icons.psychology_rounded,
            iconBg: const Color(0xFFFFF0E0),
            iconColor: const Color(0xFFD97706),
            title: 'Memory Recall',
            trend: '+12%',
            trendColor: const Color(0xFF059669),
            showDivider: true,
          ),
          _buildBaselineRow(
            icon: Icons.bolt_rounded,
            iconBg: const Color(0xFFD1FAE5),
            iconColor: const Color(0xFF059669),
            title: 'Processing Speed',
            trend: '+8%',
            trendColor: const Color(0xFF059669),
            showDivider: true,
          ),
          _buildBaselineRow(
            icon: Icons.extension_rounded,
            iconBg: const Color(0xFFF3E8FF),
            iconColor: const Color(0xFF9333EA),
            title: 'Problem Solving',
            trend: '+2%',
            trendColor: const Color(0xFFD97706),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildBaselineRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String trend,
    required Color trendColor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    trendColor == const Color(0xFF059669)
                        ? Icons.trending_up_rounded
                        : Icons.trending_flat_rounded,
                    color: trendColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: trendColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFF1F5F9)),
      ],
    );
  }
}

class _FocusAreasCard extends StatelessWidget {
  const _FocusAreasCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressRow('Memory', 0.85, '85%'),
          const SizedBox(height: 20),
          _buildProgressRow('Processing Speed', 0.70, '70%'),
          const SizedBox(height: 20),
          _buildProgressRow('Logic', 0.92, '92%'),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String title, double progress, String percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFD1FAE5),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}

class _AIInsightsCard extends StatelessWidget {
  const _AIInsightsCard();
  @override
  Widget build(BuildContext context) {
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
            children: [
              Icon(
                Icons.psychology_outlined,
                color: Color(0xFF4F46E5),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Weekly Review',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Based on your recent training patterns, focusing on spatial memory exercises in the morning could further enhance your performance metrics.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF4F46E5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4F46E5),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Plan',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Ensure bottom navigation is available here
class _MemoriaBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _MemoriaBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.psychology_outlined,
                label: 'Training',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.insights_rounded,
                label: 'Stats',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? const Color(0xFF2563EB)
        : const Color(0xFF94A3B8);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
