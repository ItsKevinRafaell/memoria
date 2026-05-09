import 'package:NeuroBob/core/models/game_config.dart';
import 'package:provider/provider.dart';
import 'package:NeuroBob/features/memory_game/providers/memory_game_provider.dart';
import 'package:NeuroBob/features/memory_game/screens/game_screen.dart';

import 'package:NeuroBob/features/speed_match/providers/speed_match_provider.dart';
import 'package:NeuroBob/features/speed_match/screens/game_screen.dart';

final List<GameConfig> games = [
  GameConfig(
    title: "Memory Match",
    description: "Train your memory",
    builder: (context) => ChangeNotifierProvider(
      create: (_) => MemoryGameProvider(),
      child: MemoryGameScreen(),
    ),
  ),
  GameConfig(
    title: "Speed Match",
    description: "Train your reaction speed",
    builder: (context) => ChangeNotifierProvider(
      create: (_) => SpeedMatchProvider(),
      child: SpeedMatchGameScreen(),
    ),
  ),
];