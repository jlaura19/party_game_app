import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/difficulty_level.dart';

/// Service for persisting app data locally
class StorageService {
  static const String _historyKey = 'game_history';
  static const String _favoritesKey = 'favorites';
  static const String _settingsKey = 'settings';
  static const String _difficultyKey = 'difficulty_level';


  late final SharedPreferences _prefs;

  /// Initialize the storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save a card to history
  Future<void> addToHistory(String gameMode, String text) async {
    final history = getHistory(gameMode);
    history.insert(0, text);
    
    // Keep only last 50 items
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }
    
    await _prefs.setStringList('${_historyKey}_$gameMode', history);
  }

  /// Get history for a specific game mode
  List<String> getHistory(String gameMode) {
    return _prefs.getStringList('${_historyKey}_$gameMode') ?? [];
  }

  /// Clear history for a specific game mode
  Future<void> clearHistory(String gameMode) async {
    await _prefs.remove('${_historyKey}_$gameMode');
  }

  /// Add to favorites
  Future<void> addToFavorites(String text) async {
    final favorites = getFavorites();
    if (!favorites.contains(text)) {
      favorites.add(text);
      await _prefs.setStringList(_favoritesKey, favorites);
    }
  }

  /// Get all favorites
  List<String> getFavorites() {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  /// Remove from favorites
  Future<void> removeFromFavorites(String text) async {
    final favorites = getFavorites();
    favorites.remove(text);
    await _prefs.setStringList(_favoritesKey, favorites);
  }

  /// Save settings
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is bool) {
      await _prefs.setBool('${_settingsKey}_$key', value);
    } else if (value is int) {
      await _prefs.setInt('${_settingsKey}_$key', value);
    } else if (value is double) {
      await _prefs.setDouble('${_settingsKey}_$key', value);
    } else if (value is String) {
      await _prefs.setString('${_settingsKey}_$key', value);
    }
  }

  /// Get setting
  T? getSetting<T>(String key) {
    return _prefs.get('${_settingsKey}_$key') as T?;
  }

  /// Save difficulty level preference
  Future<void> saveDifficultyLevel(DifficultyLevel level) async {
    await _prefs.setString(_difficultyKey, level.storageKey);
  }

  /// Get difficulty level preference (default: moderate)
  DifficultyLevel getDifficultyLevel() {
    final value = _prefs.getString(_difficultyKey);
    if (value == null) {
      return DifficultyLevel.moderate; // Default
    }
    return DifficultyLevelExtension.fromString(value);
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
