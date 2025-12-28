import 'package:flutter/material.dart';

/// Enum for different game modes
enum GameMode {
  neverHaveIEver,
  mostLikelyTo,
  truthOrDare,
  roastMaster,
  debateDuel,
  bartender,
  diceRoller,
}

/// Extension to get display properties for each game mode
extension GameModeExtension on GameMode {
  String get title {
    switch (this) {
      case GameMode.neverHaveIEver:
        return 'Never Have I Ever';
      case GameMode.mostLikelyTo:
        return 'Most Likely To';
      case GameMode.truthOrDare:
        return 'Truth or Dare';
      case GameMode.roastMaster:
        return 'Roast Master';
      case GameMode.debateDuel:
        return 'Debate Duel';
      case GameMode.bartender:
        return 'Cursed Bartender';
      case GameMode.diceRoller:
        return 'Dice Roller';
    }
  }

  String get subtitle {
    switch (this) {
      case GameMode.neverHaveIEver:
        return 'AI Enabled';
      case GameMode.mostLikelyTo:
        return 'AI Enabled';
      case GameMode.truthOrDare:
        return 'AI Enabled';
      case GameMode.roastMaster:
        return 'AI Mode';
      case GameMode.debateDuel:
        return 'AI Mode';
      case GameMode.bartender:
        return 'AI Mode';
      case GameMode.diceRoller:
        return 'For board games';
    }
  }

  IconData get icon {
    switch (this) {
      case GameMode.neverHaveIEver:
        return Icons.local_bar;
      case GameMode.mostLikelyTo:
        return Icons.people;
      case GameMode.truthOrDare:
        return Icons.local_fire_department;
      case GameMode.roastMaster:
        return Icons.mic;
      case GameMode.debateDuel:
        return Icons.gavel;
      case GameMode.bartender:
        return Icons.local_drink;
      case GameMode.diceRoller:
        return Icons.casino;
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case GameMode.neverHaveIEver:
        return [const Color(0xFF4F46E5), const Color(0xFF2563EB)];
      case GameMode.mostLikelyTo:
        return [const Color(0xFFF97316), const Color(0xFFDC2626)];
      case GameMode.truthOrDare:
        return [const Color(0xFF9333EA), const Color(0xFF7E22CE)];
      case GameMode.roastMaster:
        return [const Color(0xFFCA8A04), const Color(0xFFA16207)];
      case GameMode.debateDuel:
        return [const Color(0xFF0891B2), const Color(0xFF0E7490)];
      case GameMode.bartender:
        return [const Color(0xFF059669), const Color(0xFF047857)];
      case GameMode.diceRoller:
        return [const Color(0xFFDB2777), const Color(0xFFBE185D)];
    }
  }

  Color get primaryColor {
    return gradientColors.first;
  }

  bool get hasAI {
    return this != GameMode.diceRoller;
  }

  bool get isAIOnly {
    return this == GameMode.roastMaster ||
        this == GameMode.debateDuel ||
        this == GameMode.bartender;
  }

  int get gridSpan {
    // Roast Master and Debate Duel take 1 column, others take 2
    return (this == GameMode.roastMaster || this == GameMode.debateDuel) ? 1 : 2;
  }
}
