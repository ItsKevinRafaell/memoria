import 'package:flutter/material.dart';

class GameConfig {
  final String title;
  final String description;
  final WidgetBuilder builder; // = Widget Function(BuildContext)

  GameConfig({
    required this.title,
    required this.description,
    required this.builder,
  });
}