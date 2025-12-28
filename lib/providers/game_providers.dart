import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_card.dart';
import '../models/difficulty_level.dart';
import '../constants/game_data.dart';
import 'app_providers.dart';

/// Provider for current difficulty level
class DifficultyNotifier extends StateNotifier<DifficultyLevel> {
  final Ref ref;

  DifficultyNotifier(this.ref) : super(DifficultyLevel.moderate) {
    // Load saved difficulty on initialization
    _loadSavedDifficulty();
  }

  void _loadSavedDifficulty() async {
    try {
      final storageAsync = await ref.read(storageServiceProvider.future);
      state = storageAsync.getDifficultyLevel();
    } catch (e) {
      // Ignore errors during initialization
    }
  }

  Future<void> setDifficulty(DifficultyLevel level) async {
    state = level;
    try {
      final storage = await ref.read(storageServiceProvider.future);
      await storage.saveDifficultyLevel(level);
    } catch (e) {
      // Ignore errors
    }
  }
}

/// Provider for difficulty level state
final difficultyProvider =
    StateNotifierProvider<DifficultyNotifier, DifficultyLevel>((ref) {
  return DifficultyNotifier(ref);
});


/// State for card-based games (Never Have I Ever, Most Likely To)
class CardGameState {
  final GameCard currentCard;
  final List<GameCard> history;
  final bool isLoading;
  final String? error;

  CardGameState({
    required this.currentCard,
    this.history = const [],
    this.isLoading = false,
    this.error,
  });

  CardGameState copyWith({
    GameCard? currentCard,
    List<GameCard>? history,
    bool? isLoading,
    String? error,
  }) {
    return CardGameState(
      currentCard: currentCard ?? this.currentCard,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for card-based games
class CardGameNotifier extends StateNotifier<CardGameState> {
  final String gameType; // 'neverHaveIEver' or 'mostLikelyTo'
  final Ref ref;
  final Random _random = Random();

  CardGameNotifier(this.gameType, this.ref)
      : super(CardGameState(
          currentCard: GameCard(
            text: _getInitialCard(gameType, ref),
          ),
        ));

  static String _getInitialCard(String gameType, Ref ref) {
    final difficulty = ref.read(difficultyProvider);
    final dataSource = gameType == 'neverHaveIEver'
        ? GameData.getNeverHaveIEver(difficulty)
        : GameData.getMostLikelyTo(difficulty);
    return dataSource[Random().nextInt(dataSource.length)];
  }

  List<String> _getDataSource() {
    final difficulty = ref.read(difficultyProvider);
    return gameType == 'neverHaveIEver'
        ? GameData.getNeverHaveIEver(difficulty)
        : GameData.getMostLikelyTo(difficulty);
  }

  /// Get next random card from preset data
  void nextCard() {
    final dataSource = _getDataSource();
    String newText;
    do {
      newText = dataSource[_random.nextInt(dataSource.length)];
    } while (newText == state.currentCard.text && dataSource.length > 1);

    final newCard = GameCard(text: newText);
    state = state.copyWith(
      currentCard: newCard,
      history: [state.currentCard, ...state.history],
    );
  }

  /// Generate AI card
  Future<void> generateAICard(Future<String> Function() generator) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final text = await generator();
      final newCard = GameCard(text: text, isAIGenerated: true);
      
      state = state.copyWith(
        currentCard: newCard,
        history: [state.currentCard, ...state.history],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate AI content',
      );
    }
  }
}

/// Provider for Never Have I Ever game
final neverHaveIEverProvider =
    StateNotifierProvider<CardGameNotifier, CardGameState>((ref) {
  return CardGameNotifier('neverHaveIEver', ref);
});

/// Provider for Most Likely To game
final mostLikelyToProvider =
    StateNotifierProvider<CardGameNotifier, CardGameState>((ref) {
  return CardGameNotifier('mostLikelyTo', ref);
});

/// State for Truth or Dare
enum TruthOrDareMode { none, truth, dare }

class TruthOrDareState {
  final TruthOrDareMode mode;
  final String text;
  final bool isLoading;
  final String? error;

  TruthOrDareState({
    this.mode = TruthOrDareMode.none,
    this.text = '',
    this.isLoading = false,
    this.error,
  });

  TruthOrDareState copyWith({
    TruthOrDareMode? mode,
    String? text,
    bool? isLoading,
    String? error,
  }) {
    return TruthOrDareState(
      mode: mode ?? this.mode,
      text: text ?? this.text,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for Truth or Dare
class TruthOrDareNotifier extends StateNotifier<TruthOrDareState> {
  final Ref ref;
  final Random _random = Random();

  TruthOrDareNotifier(this.ref) : super(TruthOrDareState());

  void pickTruth() {
    final difficulty = ref.read(difficultyProvider);
    final truths = GameData.getTruths(difficulty);
    final text = truths[_random.nextInt(truths.length)];
    state = TruthOrDareState(mode: TruthOrDareMode.truth, text: text);
  }

  void pickDare() {
    final difficulty = ref.read(difficultyProvider);
    final dares = GameData.getDares(difficulty);
    final text = dares[_random.nextInt(dares.length)];
    state = TruthOrDareState(mode: TruthOrDareMode.dare, text: text);
  }

  Future<void> generateAITruth() async {
    state = state.copyWith(
      mode: TruthOrDareMode.truth,
      text: '',
      isLoading: true,
      error: null,
    );

    try {
      final gemini = ref.read(geminiServiceProvider);
      final difficulty = ref.read(difficultyProvider);
      final text = await gemini.generateTruth(difficulty);
      state = state.copyWith(text: text, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate truth',
      );
    }
  }

  Future<void> generateAIDare() async {
    state = state.copyWith(
      mode: TruthOrDareMode.dare,
      text: '',
      isLoading: true,
      error: null,
    );

    try {
      final gemini = ref.read(geminiServiceProvider);
      final difficulty = ref.read(difficultyProvider);
      final text = await gemini.generateDare(difficulty);
      state = state.copyWith(text: text, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate dare',
      );
    }
  }

  void reset() {
    state = TruthOrDareState();
  }
}

/// Provider for Truth or Dare
final truthOrDareProvider =
    StateNotifierProvider<TruthOrDareNotifier, TruthOrDareState>((ref) {
  return TruthOrDareNotifier(ref);
});

/// State for Dice Roller
class DiceState {
  final int value;
  final bool isRolling;

  DiceState({
    this.value = 1,
    this.isRolling = false,
  });

  DiceState copyWith({
    int? value,
    bool? isRolling,
  }) {
    return DiceState(
      value: value ?? this.value,
      isRolling: isRolling ?? this.isRolling,
    );
  }
}

/// Notifier for Dice Roller
class DiceNotifier extends StateNotifier<DiceState> {
  final Random _random = Random();

  DiceNotifier() : super(DiceState());

  Future<void> roll() async {
    if (state.isRolling) return;

    state = state.copyWith(isRolling: true);
    
    // Simulate rolling animation
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final newValue = _random.nextInt(6) + 1;
    state = DiceState(value: newValue, isRolling: false);
  }
}

/// Provider for Dice Roller
final diceProvider = StateNotifierProvider<DiceNotifier, DiceState>((ref) {
  return DiceNotifier();
});
