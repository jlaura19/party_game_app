import '../models/difficulty_level.dart';
import 'api_service.dart';

/// Service for generating AI content via FastAPI backend
/// This replaces direct Gemini API calls for better security and control
class GeminiService {
  final ApiService _apiService = ApiService();
  
  // Check if backend is available
  Future<bool> get isApiConfigured async => await _apiService.checkHealth();
  
  /// Generate a Never Have I Ever statement
  Future<String> generateNeverHaveIEver([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _apiService.generateNeverHaveIEver(difficulty);
  }

  /// Generate a Most Likely To scenario
  Future<String> generateMostLikelyTo([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _apiService.generateMostLikelyTo(difficulty);
  }

  /// Generate a Truth question
  Future<String> generateTruth([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _apiService.generateTruth(difficulty);
  }

  /// Generate a Dare challenge
  Future<String> generateDare([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _apiService.generateDare(difficulty);
  }

  /// Generate a roast for someone
  Future<String> generateRoast(String name, String trait, [DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _apiService.generateRoast(name, trait, difficulty);
  }

  /// Generate a debate topic
  Future<String> generateDebateTopic([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _apiService.generateDebateTopic(difficulty);
  }

  /// Generate a cocktail recipe
  Future<String> generateCocktail(String ingredients) async {
    return await _apiService.generateCocktail(ingredients);
  }
}
