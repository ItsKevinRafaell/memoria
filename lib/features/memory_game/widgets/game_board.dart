// lib/widgets/game_board.dart
// Renders the grid of GameCard widgets.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/memory_game_provider.dart';

//import '../providers/game_provider.dart';
import 'game_card.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<MemoryGameProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = game.columns;
        // Card size: fit inside available width with spacing
        final spacing = 8.0;
        final totalSpacing = spacing * (cols - 1);
        final cardSize = (constraints.maxWidth - totalSpacing) / cols;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 1.0,
          ),
          itemCount: game.cards.length,
          itemBuilder: (context, index) {
            final card = game.cards[index];
            return GameCard(
              key: ValueKey(card.id),
              card: card,
              size: cardSize,
              onTap: () => context.read<MemoryGameProvider>().onCardTap(card.id),
            );
          },
        );
      },
    );
  }
}
