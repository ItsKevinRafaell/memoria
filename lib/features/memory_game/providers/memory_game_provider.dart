// lib/providers/game_provider.dart
//
// STATE MANAGEMENT CHOICE: Provider + ChangeNotifier
// ─────────────────────────────────────────────────
// We use Provider because:
//  • Simple to understand — minimal boilerplate vs Riverpod/Bloc
//  • ChangeNotifier is built into Flutter; zero extra concepts
//  • Sufficient for a self-contained single-screen game
//  • Easy to test: just call methods on the notifier directly
//
// Separation of concerns:
//  • GameProvider  → all game logic, no UI code
//  • Widgets       → only read state and dispatch events
//  • Models        → pure data, no logic

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/card_model.dart';
import '../models/high_score_model.dart';
import '../utils/high_score_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryGameProvider extends ChangeNotifier {
  // ──────────────────────────────────────────────
  // State
  // ──────────────────────────────────────────────

  Difficulty _difficulty = Difficulty.easy;
  List<CardModel> _cards = [];
  CardModel? _firstFlipped;   // First card of the current turn
  CardModel? _secondFlipped;  // Second card of the current turn
  bool _isChecking = false;   // Lock while mismatch-flip-back delay runs
  int _moves = 0;
  int _matchedPairs = 0;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  bool _isGameOver = false;
  Timer? _timer;
  HighScore? _bestScore;

  // ──────────────────────────────────────────────
  // Getters (read-only surface for UI)
  // ──────────────────────────────────────────────

  Difficulty get difficulty => _difficulty;
  List<CardModel> get cards => List.unmodifiable(_cards);
  int get moves => _moves;
  int get matchedPairs => _matchedPairs;
  int get totalPairs => _difficulty.pairs;
  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => _isRunning;
  bool get isGameOver => _isGameOver;
  HighScore? get bestScore => _bestScore;
  int get columns => _difficulty.columns;

  String get formattedTime {
    final m = _elapsedSeconds ~/ 60;
    final s = _elapsedSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ──────────────────────────────────────────────
  // Initialisation
  // ──────────────────────────────────────────────

  GameProvider() {
    startNewGame();
  }

  Future<void> setDifficulty(Difficulty d) async {
    _difficulty = d;
    await startNewGame();
  }

  Future<void> startNewGame() async {
    _timer?.cancel();
    _firstFlipped = null;
    _secondFlipped = null;
    _isChecking = false;
    _moves = 0;
    _matchedPairs = 0;
    _elapsedSeconds = 0;
    _isRunning = false;
    _isGameOver = false;
    _cards = _buildShuffledDeck(_difficulty);
    _bestScore = await HighScoreStorage.load(_difficulty);
    notifyListeners();
  }

  // ──────────────────────────────────────────────
  // Core gameplay
  // ──────────────────────────────────────────────

  /// Called when the player taps a card.
  Future<void> onCardTap(String cardId) async {
    // Ignore taps while a mismatch animation is running
    if (_isChecking) return;

    final index = _cards.indexWhere((c) => c.id == cardId);
    if (index == -1) return;

    final card = _cards[index];

    // Ignore already-revealed or matched cards
    if (card.isFaceUp || card.isMatched) return;

    // Ignore a third tap when two cards are already face-up
    if (_secondFlipped != null) return;

    // Start the timer on the very first flip
    if (!_isRunning) _startTimer();

    // Flip the card face-up
    _cards[index] = card.copyWith(isFaceUp: true);

    if (_firstFlipped == null) {
      _firstFlipped = _cards[index];
      notifyListeners();
      return;
    }

    // Second card selected — evaluate the pair
    _secondFlipped = _cards[index];
    _moves++;
    notifyListeners();

    await _evaluatePair();
  }

  Future<void> _evaluatePair() async {
    final first = _firstFlipped!;
    final second = _secondFlipped!;

    if (first.content == second.content) {
      // ✅ MATCH — mark both as matched
      _setCardMatched(first.id);
      _setCardMatched(second.id);
      _matchedPairs++;
      _firstFlipped = null;
      _secondFlipped = null;

      if (_matchedPairs == totalPairs) {
        await _onGameComplete();
      } else {
        notifyListeners();
      }
    } else {
      // ❌ MISMATCH — wait, then flip back
      _isChecking = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 900));

      _setCardFaceDown(first.id);
      _setCardFaceDown(second.id);
      _firstFlipped = null;
      _secondFlipped = null;
      _isChecking = false;
      notifyListeners();
    }
  }

  void _setCardMatched(String id) {
    final i = _cards.indexWhere((c) => c.id == id);
    if (i != -1) _cards[i] = _cards[i].copyWith(isMatched: true, isFaceUp: true);
  }

  void _setCardFaceDown(String id) {
    final i = _cards.indexWhere((c) => c.id == id);
    if (i != -1) _cards[i] = _cards[i].copyWith(isFaceUp: false);
  }

  // ──────────────────────────────────────────────
  // Timer
  // ──────────────────────────────────────────────

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _isRunning = false;
  }

  // ──────────────────────────────────────────────
  // Game Over
  // ──────────────────────────────────────────────

  Future<void> _onGameComplete() async {
    _stopTimer();
    _isGameOver = true;

    final score = HighScore(
      moves: _moves,
      seconds: _elapsedSeconds,
      difficulty: _difficulty,
      achievedAt: DateTime.now(),
    );

    // Save only if it's a new best (fewer moves wins; time as tiebreaker)
    final isNewBest = _bestScore == null ||
        _moves < _bestScore!.moves ||
        (_moves == _bestScore!.moves && _elapsedSeconds < _bestScore!.seconds);

    if (isNewBest) {
      await HighScoreStorage.save(score);
      _bestScore = score;
    }

    notifyListeners();
  }

  // ──────────────────────────────────────────────
  // Deck builder
  // ──────────────────────────────────────────────

  static List<CardModel> _buildShuffledDeck(Difficulty d) {
    final allContent = CardContent.values.toList()..shuffle(Random());
    final selected = allContent.take(d.pairs).toList();

    // Create two copies of each selected content item
    final deck = <CardModel>[];
    for (var i = 0; i < selected.length; i++) {
      final content = selected[i];
      deck.add(CardModel(id: '${content.name}_0', content: content));
      deck.add(CardModel(id: '${content.name}_1', content: content));
    }

    deck.shuffle(Random());
    return deck;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
