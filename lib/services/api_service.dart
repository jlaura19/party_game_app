import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/difficulty_level.dart';

/// Service for communicating with the FastAPI backend
class ApiService {
  // Base URL - change this based on environment
  // Use your computer's IP address for mobile devices (not localhost)
  static const String _devBaseUrl = 'http://192.168.100.15:8000';
  static const String _prodBaseUrl = 'https://your-backend-url.onrender.com'; // Update after deployment
  
  // Use dev URL by default, can be configured
  static String baseUrl = _devBaseUrl;
  
  // Timeout duration
  static const Duration _timeout = Duration(seconds: 30);
  
  /// Check if the API is healthy
  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/health'),
          )
          .timeout(_timeout);
      
      return response.statusCode == 200;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }
  
  /// Generate a Never Have I Ever statement
  Future<String> generateNeverHaveIEver([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _generateContent(
      '/api/generate/never-have-i-ever',
      {'difficulty': _difficultyToString(difficulty)},
    );
  }
  
  /// Generate a Most Likely To scenario
  Future<String> generateMostLikelyTo([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _generateContent(
      '/api/generate/most-likely-to',
      {'difficulty': _difficultyToString(difficulty)},
    );
  }
  
  /// Generate a Truth question
  Future<String> generateTruth([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _generateContent(
      '/api/generate/truth',
      {'difficulty': _difficultyToString(difficulty)},
    );
  }
  
  /// Generate a Dare challenge
  Future<String> generateDare([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _generateContent(
      '/api/generate/dare',
      {'difficulty': _difficultyToString(difficulty)},
    );
  }
  
  /// Generate a roast for someone
  Future<String> generateRoast(String name, String trait, [DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _generateContent(
      '/api/generate/roast',
      {
        'name': name,
        'trait': trait,
        'difficulty': _difficultyToString(difficulty),
      },
    );
  }
  
  /// Generate a debate topic
  Future<String> generateDebateTopic([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    return await _generateContent(
      '/api/generate/debate',
      {'difficulty': _difficultyToString(difficulty)},
    );
  }
  
  /// Generate a cocktail recipe
  Future<String> generateCocktail(String ingredients) async {
    return await _generateContent(
      '/api/generate/cocktail',
      {'ingredients': ingredients},
    );
  }
  
  /// Private method to make API requests
  Future<String> _generateContent(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'] as String;
      } else if (response.statusCode == 429) {
        return "Rate limit exceeded. Please wait a moment and try again.";
      } else if (response.statusCode == 503) {
        return "Backend service unavailable. Please check your connection.";
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return "Couldn't generate content. Please try again.";
      }
    } catch (e) {
      print('Network Error: $e');
      
      if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        return "Cannot connect to server. Make sure the backend is running.";
      } else if (e.toString().contains('TimeoutException')) {
        return "Request timed out. Please try again.";
      }
      
      return "Network error. Please check your connection.";
    }
  }
  
  /// Convert DifficultyLevel enum to string
  String _difficultyToString(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.mild:
        return 'mild';
      case DifficultyLevel.moderate:
        return 'moderate';
      case DifficultyLevel.spicy:
        return 'spicy';
    }
  }
  
  /// Set base URL (useful for switching between dev and prod)
  static void setBaseUrl(String url) {
    baseUrl = url;
  }
  
  /// Use production URL
  static void useProductionUrl() {
    baseUrl = _prodBaseUrl;
  }
  
  /// Use development URL
  static void useDevelopmentUrl() {
    baseUrl = _devBaseUrl;
  }
}
