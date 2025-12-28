/// API Configuration for Gemini AI
class ApiConfig {
  // Gemini API Key - Load from environment variable or Flutter secrets
  // For local development, add your key to a .env file (which is in .gitignore)
  // Never commit API keys to version control!
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'YOUR_API_KEY_HERE_REPLACE_ME',
  );
  
  // API Endpoints
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-1.5-pro';
  
  // System Instructions
  static const String systemInstruction = 
      "You are a witty, fun party game host for a group of 20-somethings. "
      "Keep responses short, punchy, and appropriate for a social setting "
      "(edgy is okay, but keep it safe).";
}
