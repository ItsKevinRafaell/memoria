import 'package:flutter/material.dart';
import 'package:memoria/presentation/widgets/layout/top_bar.dart';
import '../../../core/theme/app_theme.dart';

import '../../widgets/layout/memoria_bottom_nav.dart';
import '../../widgets/cards/game_card.dart';
import 'game_detail_screen.dart'; // The screen we created earlier!

class GameCatalogScreen extends StatefulWidget {
  final int currentNavIndex;
  final Function(int)? onNavTap;

  const GameCatalogScreen({
    super.key,
    this.currentNavIndex = 1, // Default to Training Tab
    this.onNavTap,
  });

  @override
  State<GameCatalogScreen> createState() => _GameCatalogScreenState();
}

class _GameCatalogScreenState extends State<GameCatalogScreen> {
  String _selectedCategory = 'Memory';
  final List<String> _categories = ['All', 'Memory', 'Focus', 'Logic'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // 1. Reusable App Bar
      appBar: TopBar(
        onActionTap: () => print("Settings tapped!"),
        actionIcon: Icons.settings_outlined,
      ),

      // 2. Main Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Brain Training\nLibrary',
              style: AppTextStyles.h1.copyWith(
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Daily exercises to sharpen your mind.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),

            // Filter Chips (Extracted to method below)
            _buildCategoryFilters(),
            const SizedBox(height: 32),

            // Reusable Game Cards List
            GameCard(
              title: 'Shape Recall',
              subtitle: 'Trains: Working Memory',
              icon: Icons.category_rounded,
              bgColor: const Color(0xFFFFF0E0),
              iconColor: AppColors.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameDetailScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            GameCard(
              title: 'Focus Flow',
              subtitle: 'Trains: Attention',
              icon: Icons.psychology_rounded,
              bgColor: const Color(0xFFD1FAE5),
              iconColor: AppColors.primary,
              onTap: () => print("Focus Flow Tapped"),
            ),
            const SizedBox(height: 16),
            GameCard(
              title: 'Logic Link',
              subtitle: 'Trains: Problem Solving',
              icon: Icons.extension_rounded,
              bgColor: const Color(0xFFF3E8FF),
              iconColor: AppColors.primary,
              onTap: () => print("Logic Link Tapped"),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),

      // 3. Reusable Bottom Nav Bar
      bottomNavigationBar: MemoriaBottomNav(
        currentIndex: widget.currentNavIndex,
        onTap: widget.onNavTap ?? (index) {},
      ),
    );
  }

  // Helper method to keep the main build clean
  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
