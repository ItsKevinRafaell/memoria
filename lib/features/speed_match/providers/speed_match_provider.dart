// providers/game_provider.dart
// All game logic lives here. UI layers only read state and call methods.

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

/// How many missed/timeout responses end the game (0 = never ends by misses)
const int _kMaxMisses = 3;

/// Initial time allowed per card
const int _kInitialTimeLimitMs = 1500;

/// Minimum time limit (fastest the game gets)
const int _kMinTimeLimitMs = 400;

/// Reduce time limit by this much every N correct answers
const int _kSpeedReductionMs = 50;
const int _kAnswersPerSpeedUp = 5;

/// Feedback display duration before showing next card
const int _kFeedbackDurationMs = 350;

class SpeedMatchProvider extends ChangeNotifier {
  GameState _state = const GameState();
  GameState get state => _state;

  final Random _rng = Random();

  // Timers
  Timer? _cardTimer;      // counts down the time limit per card
  Timer? _feedbackTimer;  // brief pause to show correct/incorrect flash
  Timer? _clockTimer;     // tracks total game duration (1s tick)
  Timer? _progressTimer;  // 60fps timer progress bar update

  int _sessionStartMs = 0;

  // ── Public API ────────────────────────────────────────────

  /// Start a fresh game session
  Future<void> startGame() async {
    _cancelAllTimers();
    final highScore = await _loadHighScore();
    _sessionStartMs = DateTime.now().millisecondsSinceEpoch;

    _state = GameState(
      phase: GamePhase.showing,
      timeLimitMs: _kInitialTimeLimitMs,
      highScore: highScore,
    );

    _showNextCard(); // show first card
    _startClockTimer();
    notifyListeners();
  }

  /// Player pressed "Match"
  void onMatch() => _handleResponse(playerSaidMatch: true);

  /// Player pressed "Not Match"
  void onNotMatch() => _handleResponse(playerSaidMatch: false);

  /// Reset to idle (home) state
  void resetGame() {
    _cancelAllTimers();
    _state = GameState(highScore: _state.highScore);
    notifyListeners();
  }

  // ── Internal: Card flow ───────────────────────────────────

  void _showNextCard() {
    _cancelCardTimers();

    final prevSymbol = _state.currentSymbol;

    // Decide whether this card should match previous (~40% match rate feels natural)
    final bool shouldMatch =
        _state.cardIndex > 0 && _rng.nextDouble() < 0.40;

    CardSymbol nextSymbol;
    if (shouldMatch && prevSymbol != null) {
      nextSymbol = prevSymbol; // intentional match
    } else {
      // Pick a different symbol from previous
      final values = CardSymbol.values.toList();
      if (prevSymbol != null) values.remove(prevSymbol);
      nextSymbol = values[_rng.nextInt(values.length)];
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    _state = _state.copyWith(
      currentSymbol: nextSymbol,
      previousSymbol: prevSymbol,
      cardIndex: _state.cardIndex + 1,
      phase: GamePhase.showing,
      cardShownAtMs: now,
      timerProgress: 1.0,
      clearLastResult: true,
    );

    notifyListeners();

    if (_state.cardIndex == 1) {
      // First card — no input required, auto-advance
      _cardTimer = Timer(
        Duration(milliseconds: _state.timeLimitMs),
        _showNextCard,
      );
      return;
    }

    // Start countdown timer for player input
    _cardTimer = Timer(
      Duration(milliseconds: _state.timeLimitMs),
      _handleTimeout,
    );

    // Smooth progress bar update at ~60fps
    _progressTimer =
        Timer.periodic(const Duration(milliseconds: 16), (t) {
      final elapsed =
          DateTime.now().millisecondsSinceEpoch - _state.cardShownAtMs;
      final progress =
          1.0 - (elapsed / _state.timeLimitMs).clamp(0.0, 1.0);
      _state = _state.copyWith(timerProgress: progress);
      notifyListeners();
    });
  }

  void _handleTimeout() {
    _cancelCardTimers();

    final newMisses = _state.missedAnswers + 1;

    // Record the round
    final round = RoundRecord(
      symbol: _state.currentSymbol!,
      wasMatch: _state.isCurrentMatch,
      playerSaidMatch: null,
      reactionTimeMs: _state.timeLimitMs,
      result: ResponseResult.timeout,
    );

    _state = _state.copyWith(
      phase: GamePhase.feedback,
      lastResult: ResponseResult.timeout,
      streak: 0,
      missedAnswers: newMisses,
      totalAnswered: _state.totalAnswered + 1,
      rounds: [..._state.rounds, round],
    );

    _triggerHaptic(HapticFeedbackType.heavy);
    notifyListeners();

    // End game if too many misses
    if (_kMaxMisses > 0 && newMisses >= _kMaxMisses) {
      _endGame();
      return;
    }

    _feedbackTimer = Timer(
      const Duration(milliseconds: _kFeedbackDurationMs),
      _showNextCard,
    );
  }

  void _handleResponse({required bool playerSaidMatch}) {
    if (_state.phase != GamePhase.showing || _state.cardIndex <= 1) return;

    _cancelCardTimers();

    final now = DateTime.now().millisecondsSinceEpoch;
    final reactionMs = now - _state.cardShownAtMs;
    final isCorrect = playerSaidMatch == _state.isCurrentMatch;

    final result =
        isCorrect ? ResponseResult.correct : ResponseResult.incorrect;

    final newStreak = isCorrect ? _state.streak + 1 : 0;
    final newMaxStreak = max(newStreak, _state.maxStreak);
    final newCorrect =
        _state.correctAnswers + (isCorrect ? 1 : 0);
    final newTotal = _state.totalAnswered + 1;
    final newReactionTimes =
        [..._state.reactionTimes, reactionMs];

    // Calculate score delta
    final runningAccuracy =
        newTotal == 0 ? 1.0 : newCorrect / newTotal;
    int scoreDelta = 0;
    if (isCorrect) {
      scoreDelta = GameState.calculateDelta(
        reactionTimeMs: reactionMs,
        timeLimitMs: _state.timeLimitMs,
        runningAccuracy: runningAccuracy,
        currentStreak: newStreak,
        difficultyLevel: _state.difficultyLevel,
      );
    }

    // Speed up every N correct answers
    int newTimeLimit = _state.timeLimitMs;
    int newDifficultyLevel = _state.difficultyLevel;
    if (isCorrect && newCorrect % _kAnswersPerSpeedUp == 0) {
      newTimeLimit =
          max(_kMinTimeLimitMs, _state.timeLimitMs - _kSpeedReductionMs);
      if (newTimeLimit < _state.timeLimitMs) {
        newDifficultyLevel = _state.difficultyLevel + 1;
      }
    }

    // Record round
    final round = RoundRecord(
      symbol: _state.currentSymbol!,
      wasMatch: _state.isCurrentMatch,
      playerSaidMatch: playerSaidMatch,
      reactionTimeMs: reactionMs,
      result: result,
    );

    _state = _state.copyWith(
      phase: GamePhase.feedback,
      lastResult: result,
      score: _state.score + scoreDelta,
      streak: newStreak,
      maxStreak: newMaxStreak,
      totalAnswered: newTotal,
      correctAnswers: newCorrect,
      reactionTimes: newReactionTimes,
      rounds: [..._state.rounds, round],
      timeLimitMs: newTimeLimit,
      difficultyLevel: newDifficultyLevel,
    );

    _triggerHaptic(
        isCorrect ? HapticFeedbackType.light : HapticFeedbackType.heavy);
    notifyListeners();

    _feedbackTimer = Timer(
      const Duration(milliseconds: _kFeedbackDurationMs),
      _showNextCard,
    );
  }

  // ── Internal: Game end ────────────────────────────────────

  void _endGame() {
    _cancelAllTimers();
    final elapsed =
        (DateTime.now().millisecondsSinceEpoch - _sessionStartMs) ~/ 1000;
    _state = _state.copyWith(
      phase: GamePhase.finished,
      gameDurationSeconds: elapsed,
    );
    _saveHighScore(_state.score);
    notifyListeners();
  }

  // ── Internal: Clock ───────────────────────────────────────

  void _startClockTimer() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed =
          (DateTime.now().millisecondsSinceEpoch - _sessionStartMs) ~/ 1000;
      _state = _state.copyWith(gameDurationSeconds: elapsed);
      notifyListeners();
    });
  }

  // ── Internal: Haptics ─────────────────────────────────────

  void _triggerHaptic(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
    }
  }

  // ── Internal: Timer management ────────────────────────────

  void _cancelCardTimers() {
    _cardTimer?.cancel();
    _progressTimer?.cancel();
  }

  void _cancelAllTimers() {
    _cardTimer?.cancel();
    _feedbackTimer?.cancel();
    _clockTimer?.cancel();
    _progressTimer?.cancel();
  }

  // ── Internal: Persistence ─────────────────────────────────

  Future<int> _loadHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('speed_match_high_score') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> _saveHighScore(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getInt('speed_match_high_score') ?? 0;
      if (score > current) {
        await prefs.setInt('speed_match_high_score', score);
        _state = _state.copyWith(highScore: score);
        notifyListeners();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _cancelAllTimers();
    super.dispose();
  }
}

enum HapticFeedbackType { light, medium, heavy }
