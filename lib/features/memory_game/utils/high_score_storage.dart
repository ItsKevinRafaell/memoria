// lib/utils/high_score_storage.dart
// Thin wrapper around shared_preferences for persisting best scores.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/card_model.dart';
import '../models/high_score_model.dart';

class HighScoreStorage {
  static String _key(Difficulty d) => 'high_score_${d.name}';

  static Future<void> save(HighScore score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(score.difficulty), jsonEncode(score.toMap()));
  }

  static Future<HighScore?> load(Difficulty difficulty) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key(difficulty));
      if (raw == null) return null;
      return HighScore.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final d in Difficulty.values) {
      await prefs.remove(_key(d));
    }
  }
}
