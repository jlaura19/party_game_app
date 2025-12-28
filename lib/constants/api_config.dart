import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API Configuration for Gemini AI
class ApiConfig {
  // Gemini API Key - Load from .env file or environment variable
  // For development: Add your key to .env file (which is in .gitignore)
  // For production: Pass via flutter build --dart-define=GEMINI_API_KEY=your_key
  static String get geminiApiKey {
    return dotenv.env['GEMINI_API_KEY'] ?? 
           const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  }
  
  /// Check if API key is properly configured
  static bool get isApiKeyConfigured {
    final key = geminiApiKey;
    return key.isNotEmpty && 
           !key.contains('YOUR_API_KEY') &&
           key.startsWith('AIza');
  }
  
  /// Get error message if API key is not configured
  static String get apiKeyErrorMessage {
    final key = geminiApiKey;
    if (key.isEmpty) {
      return 'API key not configured. Add GEMINI_API_KEY to .env file.';
    }
    if (key.contains('YOUR_API_KEY')) {
      return 'API key is a placeholder. Replace with actual key from aistudio.google.com/app/apikey';
    }
    return 'API key configuration error.';
  }
  
  // API Endpoints
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-pro';  // Use gemini-pro instead of gemini-1.5-pro for free tier
  
  // System Instructions
  static const String systemInstruction = 
      "You are a witty, fun party game host for a group of 20-somethings. "
      "Keep responses short, punchy, and appropriate for a social setting "
      "(edgy is okay, but keep it safe).";
}
