/// API Configuration for Gemini AI
class ApiConfig {
  // Gemini API Key - Load from environment variable
  // For development: Add your key to .env file (never commit to version control)
  // For production: Pass via flutter build --dart-define=GEMINI_API_KEY=your_key
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  
  /// Check if API key is properly configured
  static bool get isApiKeyConfigured {
    return geminiApiKey.isNotEmpty && 
           !geminiApiKey.contains('YOUR_API_KEY') &&
           geminiApiKey.startsWith('AIza');
  }
  
  /// Get error message if API key is not configured
  static String get apiKeyErrorMessage {
    if (geminiApiKey.isEmpty) {
      return 'API key not configured. Add GEMINI_API_KEY to .env file.';
    }
    if (geminiApiKey.contains('YOUR_API_KEY')) {
      return 'API key is a placeholder. Replace with actual key from aistudio.google.com/app/apikey';
    }
    return 'API key configuration error.';
  }
  
  // API Endpoints
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-1.5-pro';
  
  // System Instructions
  static const String systemInstruction = 
      "You are a witty, fun party game host for a group of 20-somethings. "
      "Keep responses short, punchy, and appropriate for a social setting "
      "(edgy is okay, but keep it safe).";
}
