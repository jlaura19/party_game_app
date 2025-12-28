import 'package:google_generative_ai/google_generative_ai.dart';
import '../constants/api_config.dart';
import '../models/difficulty_level.dart';

/// Service for interacting with Google's Gemini AI
class GeminiService {
  late final GenerativeModel _model;
  
  // Cache to store generated content and avoid duplicate requests
  final Map<String, String> _cache = {};
  
  // Rate limiting: track last request time
  DateTime? _lastRequestTime;
  static const int _minRequestDelayMs = 500; // Minimum delay between requests
  
  // Retry configuration
  static const int _maxRetries = 3;
  static const int _baseDelayMs = 1000;
  
  GeminiService() {
    _model = GenerativeModel(
      model: ApiConfig.geminiModel,
      apiKey: ApiConfig.geminiApiKey,
      systemInstruction: Content.system(ApiConfig.systemInstruction),
    );
  }

  /// Generate a Never Have I Ever statement
  Future<String> generateNeverHaveIEver([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    final intensityGuide = _getDifficultyGuide(difficulty);
    final prompt = 
        "Generate a single, unique, creative, and funny 'Never Have I Ever' "
        "statement for a group of 20-year-olds. $intensityGuide "
        "Keep it short (under 20 words). Do not include quotes or numbering.";
    
    return await _generateContent(prompt);
  }

  /// Generate a Most Likely To scenario
  Future<String> generateMostLikelyTo([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    final intensityGuide = _getDifficultyGuide(difficulty);
    final prompt = 
        "Generate a single, unique, creative, and funny 'Most Likely To' "
        "statement for a group of 20-year-olds. $intensityGuide "
        "Keep it short (under 20 words). Do not include quotes or numbering.";
    
    return await _generateContent(prompt);
  }

  /// Generate a Truth question
  Future<String> generateTruth([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    final intensityGuide = _getDifficultyGuide(difficulty);
    final prompt = 
        "Generate a Truth question for a party game for young adults. "
        "$intensityGuide Keep it short.";
    
    return await _generateContent(prompt);
  }

  /// Generate a Dare challenge
  Future<String> generateDare([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    final intensityGuide = _getDifficultyGuide(difficulty);
    final prompt = 
        "Generate a Dare challenge for a party game for young adults. "
        "$intensityGuide Physical or social. Keep it short.";
    
    return await _generateContent(prompt);
  }

  /// Generate a roast for someone
  Future<String> generateRoast(String name, String trait, [DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    final intensityGuide = _getRoastIntensity(difficulty);
    final prompt = 
        "Write a $intensityGuide roast for a friend "
        "named $name who is known for: ${trait.isEmpty ? 'being basic' : trait}. "
        "Keep it under 2 sentences. Direct address (use 'You').";
    
    return await _generateContent(prompt);
  }

  /// Generate a debate topic
  Future<String> generateDebateTopic([DifficultyLevel difficulty = DifficultyLevel.moderate]) async {
    final intensityGuide = _getDebateIntensity(difficulty);
    final prompt = 
        "Generate a $intensityGuide debate topic for two friends. "
        "Examples: 'Is a hotdog a sandwich?' or 'Would you rather have fingers "
        "for toes or toes for fingers?'. Keep it short.";
    
    return await _generateContent(prompt);
  }

  /// Generate a cocktail recipe
  Future<String> generateCocktail(String ingredients) async {
    final prompt = 
        "Invent a creative, funny, or weird cocktail recipe based on these "
        "ingredients/vibe: \"$ingredients\". Give it a cool name. "
        "Keep instructions short.";
    
    return await _generateContent(prompt);
  }

  /// Get difficulty-appropriate content guidance
  String _getDifficultyGuide(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.mild:
        return 'Keep it family-friendly and safe for all audiences.';
      case DifficultyLevel.moderate:
        return 'Make it fun and slightly cheeky, appropriate for a standard party.';
      case DifficultyLevel.spicy:
        return 'Make it bold, daring, and adult-oriented. Push boundaries.';
    }
  }

  /// Get roast intensity based on difficulty
  String _getRoastIntensity(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.mild:
        return 'playful and lighthearted';
      case DifficultyLevel.moderate:
        return 'witty and slightly savage';
      case DifficultyLevel.spicy:
        return 'brutal, savage, and hilariously mean';
    }
  }

  /// Get debate topic intensity
  String _getDebateIntensity(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.mild:
        return 'silly and wholesome';
      case DifficultyLevel.moderate:
        return 'silly, absurd, or funny';
      case DifficultyLevel.spicy:
        return 'controversial, provocative, or hilariously inappropriate';
    }
  }

  /// Enforce rate limiting - wait if necessary
  Future<void> _enforceRateLimit() async {
    if (_lastRequestTime != null) {
      final elapsed = DateTime.now().difference(_lastRequestTime!).inMilliseconds;
      if (elapsed < _minRequestDelayMs) {
        await Future.delayed(Duration(milliseconds: _minRequestDelayMs - elapsed));
      }
    }
  }

  /// Private method to generate content with retry logic and caching
  Future<String> _generateContent(String prompt) async {
    // Check cache first
    if (_cache.containsKey(prompt)) {
      return _cache[prompt]!;
    }

    // Enforce rate limiting
    await _enforceRateLimit();
    _lastRequestTime = DateTime.now();

    int retryCount = 0;
    dynamic lastError;

    while (retryCount < _maxRetries) {
      try {
        final content = [Content.text(prompt)];
        final response = await _model.generateContent(content);
        
        if (response.text == null || response.text!.isEmpty) {
          return "Couldn't think of one! Try again.";
        }
        
        final result = response.text!.trim();
        
        // Cache the result
        _cache[prompt] = result;
        
        return result;
      } catch (e) {
        lastError = e;
        print('Gemini API Error (attempt ${retryCount + 1}/$_maxRetries): $e');
        
        // Check if it's a rate limit error
        if (e.toString().contains('429') || e.toString().contains('rate')) {
          retryCount++;
          if (retryCount < _maxRetries) {
            // Exponential backoff
            final delayMs = _baseDelayMs * (1 << (retryCount - 1));
            print('Rate limited. Retrying in ${delayMs}ms...');
            await Future.delayed(Duration(milliseconds: delayMs));
          }
        } else {
          // For non-rate-limit errors, don't retry
          break;
        }
      }
    }

    // Handle final error
    print('Gemini API Final Error: $lastError');
    if (lastError.toString().contains('401') || lastError.toString().contains('Unauthorized')) {
      return "API key invalid. Please check your API key.";
    } else if (lastError.toString().contains('429') || lastError.toString().contains('rate')) {
      return "Rate limit exceeded. Try again later.";
    }
    return "Couldn't generate content. Please try again.";
  }
}
