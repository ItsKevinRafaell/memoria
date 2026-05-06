// models/game_state.dart
// Holds the pure data model for a Speed Match game session.
// No Flutter dependencies here — pure Dart.

import 'dart:math';

/// All symbols displayed on cards
enum CardSymbol {
  circle,
  square,
  triangle,
  star,
  diamond,
  hexagon,
  cross,
  moon,
}

/// Emoji/icon representation for each symbol
extension CardSymbolDisplay on CardSymbol {
  String get emoji {
    switch (this) {
      case CardSymbol.circle:
        return '●';
      case CardSymbol.square:
        return '■';
      case CardSymbol.triangle:
        return '▲';
      case CardSymbol.star:
        return '★';
      case CardSymbol.diamond:
        return '◆';
      case CardSymbol.hexagon:
        return '⬡';
      case CardSymbol.cross:
        return '✚';
      case CardSymbol.moon:
        return '☾';
    }
  }

  String get label {
    return name[0].toUpperCase() + name.substring(1);
  }
}

/// Possible states the game can be in
enum GamePhase {
  idle,       // Not started yet
  showing,    // Showing current card, waiting for input
  feedback,   // Brief feedback flash after input
  finished,   // Game over
}

/// Result of a single player response
enum ResponseResult {
  correct,
  incorrect,
  timeout,
}

/// A single round/move record
class RoundRecord {
  final CardSymbol symbol;
  final bool wasMatch;
  final bool? playerSaidMatch; // null = timeout
  final int reactionTimeMs;
  final ResponseResult result;

  const RoundRecord({
    required this.symbol,
    required this.wasMatch,
    required this.playerSaidMatch,
    required this.reactionTimeMs,
    required this.result,
  });

  bool get isCorrect => result == ResponseResult.correct;
}

/// Full snapshot of the game's state — immutable value object
class GameState {
  // ── Card state ──────────────────────────────────────────
  final CardSymbol? currentSymbol;
  final CardSymbol? previousSymbol;
  final int cardIndex; // how many cards shown so far (0 = first card)

  // ── Phase ───────────────────────────────────────────────
  final GamePhase phase;
  final ResponseResult? lastResult; // result of last round (for feedback)

  // ── Timing ──────────────────────────────────────────────
  final int timeLimitMs;       // current ms per card
  final int cardShownAtMs;     // epoch ms when card was shown (for reaction calc)
  final double timerProgress;  // 0.0 → 1.0 (1.0 = full time remaining)

  // ── Score & metrics ─────────────────────────────────────
  final int score;
  final int streak;
  final int maxStreak;
  final int totalAnswered;
  final int correctAnswers;
  final int missedAnswers;       // timeouts
  final List<int> reactionTimes; // history of reaction times in ms
  final List<RoundRecord> rounds;

  // ── Difficulty ──────────────────────────────────────────
  final int difficultyLevel; // increments as speed increases

  // ── Session ─────────────────────────────────────────────
  final int gameDurationSeconds; // total seconds the session ran
  final int highScore;

  const GameState({
    this.currentSymbol,
    this.previousSymbol,
    this.cardIndex = 0,
    this.phase = GamePhase.idle,
    this.lastResult,
    this.timeLimitMs = 1500,
    this.cardShownAtMs = 0,
    this.timerProgress = 1.0,
    this.score = 0,
    this.streak = 0,
    this.maxStreak = 0,
    this.totalAnswered = 0,
    this.correctAnswers = 0,
    this.missedAnswers = 0,
    this.reactionTimes = const [],
    this.rounds = const [],
    this.difficultyLevel = 1,
    this.gameDurationSeconds = 0,
    this.highScore = 0,
  });

  // ── Derived metrics ─────────────────────────────────────

  /// Whether the current card matches the previous one
  bool get isCurrentMatch =>
      currentSymbol != null &&
      previousSymbol != null &&
      currentSymbol == previousSymbol;

  /// Running accuracy 0.0–1.0
  double get accuracy =>
      totalAnswered == 0 ? 1.0 : correctAnswers / totalAnswered;

  /// Accuracy as a percentage string
  String get accuracyPercent =>
      '${(accuracy * 100).toStringAsFixed(0)}%';

  /// Average reaction time across all non-timeout rounds
  int get averageReactionTimeMs {
    if (reactionTimes.isEmpty) return 0;
    return (reactionTimes.reduce((a, b) => a + b) / reactionTimes.length)
        .round();
  }

  /// Fastest reaction time this session
  int get bestReactionTimeMs =>
      reactionTimes.isEmpty ? 0 : reactionTimes.reduce(min);

  // ── Scoring helpers ──────────────────────────────────────

  /// Base points awarded per correct answer
  static const int basePoints = 100;

  /// Calculate score delta for a correct answer
  static int calculateDelta({
    required int reactionTimeMs,
    required int timeLimitMs,
    required double runningAccuracy,
    required int currentStreak,
    required int difficultyLevel,
  }) {
    // speed_factor: 1.0 when answered instantly, 0.0 when answered at deadline
    final double speedFactor =
        1.0 - (reactionTimeMs / timeLimitMs).clamp(0.0, 1.0);

    // accuracy_factor: linear multiplier 0.5–1.5
    final double accuracyFactor = 0.5 + runningAccuracy;

    // streak_multiplier: +10% every 5 correct answers, capped at 3×
    final double streakMultiplier =
        (1.0 + (currentStreak ~/ 5) * 0.1).clamp(1.0, 3.0);

    // difficulty_multiplier: 1× at level 1, grows with level
    final double difficultyMultiplier = 1.0 + (difficultyLevel - 1) * 0.15;

    final double raw = basePoints *
        (0.4 + speedFactor * 0.6) * // speed is 60% of base
        accuracyFactor *
        streakMultiplier *
        difficultyMultiplier;

    return raw.round().clamp(1, 9999);
  }

  // ── Immutable copy helpers ───────────────────────────────

  GameState copyWith({
    CardSymbol? currentSymbol,
    CardSymbol? previousSymbol,
    int? cardIndex,
    GamePhase? phase,
    ResponseResult? lastResult,
    int? timeLimitMs,
    int? cardShownAtMs,
    double? timerProgress,
    int? score,
    int? streak,
    int? maxStreak,
    int? totalAnswered,
    int? correctAnswers,
    int? missedAnswers,
    List<int>? reactionTimes,
    List<RoundRecord>? rounds,
    int? difficultyLevel,
    int? gameDurationSeconds,
    int? highScore,
    bool clearLastResult = false,
    bool clearPreviousSymbol = false,
  }) {
    return GameState(
      currentSymbol: currentSymbol ?? this.currentSymbol,
      previousSymbol:
          clearPreviousSymbol ? null : (previousSymbol ?? this.previousSymbol),
      cardIndex: cardIndex ?? this.cardIndex,
      phase: phase ?? this.phase,
      lastResult: clearLastResult ? null : (lastResult ?? this.lastResult),
      timeLimitMs: timeLimitMs ?? this.timeLimitMs,
      cardShownAtMs: cardShownAtMs ?? this.cardShownAtMs,
      timerProgress: timerProgress ?? this.timerProgress,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      maxStreak: maxStreak ?? this.maxStreak,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      missedAnswers: missedAnswers ?? this.missedAnswers,
      reactionTimes: reactionTimes ?? this.reactionTimes,
      rounds: rounds ?? this.rounds,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      gameDurationSeconds: gameDurationSeconds ?? this.gameDurationSeconds,
      highScore: highScore ?? this.highScore,
    );
  }

  @override
  String toString() =>
      'GameState(phase: $phase, score: $score, streak: $streak, '
      'accuracy: $accuracyPercent, level: $difficultyLevel)';
}
