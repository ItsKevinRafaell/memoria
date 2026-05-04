// lib/presentation/screens/stats/widgets/stats_components.dart
import 'package:flutter/material.dart';

// --- Section Header ---
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {super.key});

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

// --- 1. Cognitive Performance Card ---
class CognitivePerformanceCard extends StatelessWidget {
  const CognitivePerformanceCard({super.key});

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
              : const _DottedLine(),
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
  const _DottedLine();
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

// --- 2. Personal Baseline Card ---
class PersonalBaselineCard extends StatelessWidget {
  const PersonalBaselineCard({super.key});

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

// --- 3. Focus Areas List Card ---
class FocusAreasListCard extends StatelessWidget {
  const FocusAreasListCard({super.key});

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

// --- 4. AI Insights Card ---
class AIInsightsCard extends StatelessWidget {
  const AIInsightsCard({super.key});

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
