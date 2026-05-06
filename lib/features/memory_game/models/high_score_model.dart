// lib/models/high_score_model.dart
// Stores best results per difficulty level.

import 'card_model.dart';

class HighScore {
  final int moves;
  final int seconds;
  final Difficulty difficulty;
  final DateTime achievedAt;

  const HighScore({
    required this.moves,
    required this.seconds,
    required this.difficulty,
    required this.achievedAt,
  });

  /// Converts to a JSON-serialisable map for shared_preferences.
  Map<String, dynamic> toMap() => {
        'moves': moves,
        'seconds': seconds,
        'difficulty': difficulty.name,
        'achievedAt': achievedAt.millisecondsSinceEpoch,
      };

  factory HighScore.fromMap(Map<String, dynamic> map) => HighScore(
        moves: map['moves'] as int,
        seconds: map['seconds'] as int,
        difficulty: Difficulty.values.firstWhere(
          (d) => d.name == map['difficulty'],
          orElse: () => Difficulty.easy,
        ),
        achievedAt:
            DateTime.fromMillisecondsSinceEpoch(map['achievedAt'] as int),
      );

  String get formattedTime {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m > 0 ? '${m}m ${s}s' : '${s}s';
  }
}
