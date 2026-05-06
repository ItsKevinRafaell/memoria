// lib/models/card_model.dart
// Represents a single card in the memory game.

import 'package:flutter/material.dart';

/// Unique identifiers for card content (emoji icons).
/// Each value appears TWICE in the deck to form a pair.
enum CardContent {
  rocket('🚀'),
  diamond('💎'),
  fire('🔥'),
  star('⭐'),
  rainbow('🌈'),
  crown('👑'),
  lightning('⚡'),
  ghost('👻'),
  alien('👾'),
  dragon('🐉'),
  unicorn('🦄'),
  mushroom('🍄'),
  crystal('🔮'),
  trophy('🏆'),
  compass('🧭'),
  anchor('⚓'),
  butterfly('🦋'),
  phoenix('🦅');

  final String emoji;
  const CardContent(this.emoji);
}

/// The difficulty level controls grid size.
enum Difficulty {
  easy(4, 4, 'Easy'),
  medium(4, 5, 'Medium'),
  hard(6, 6, 'Hard');

  final int columns;
  final int rows;
  final String label;
  const Difficulty(this.columns, this.rows, this.label);

  int get totalCards => columns * rows;
  int get pairs => totalCards ~/ 2;
}

/// State of a single card on the board.
class CardModel {
  final String id;           // Unique instance ID (e.g. "rocket_0", "rocket_1")
  final CardContent content; // What's on the front face
  bool isFaceUp;             // Currently showing front?
  bool isMatched;            // Permanently revealed as a found pair?

  CardModel({
    required this.id,
    required this.content,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  /// Used to animate the card — matched cards get a special highlight color.
  Color get highlightColor {
    if (isMatched) return const Color(0xFF00E676);
    if (isFaceUp) return const Color(0xFF64B5F6);
    return Colors.transparent;
  }

  CardModel copyWith({bool? isFaceUp, bool? isMatched}) {
    return CardModel(
      id: id,
      content: content,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
