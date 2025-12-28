import 'package:flutter/material.dart';

/// Enum for content difficulty/intensity levels
enum DifficultyLevel {
  mild,     // Family-friendly, safe for all audiences
  moderate, // Standard party content
  spicy,    // Bold, adult-oriented content
}

/// Extension to get display properties for each difficulty level
extension DifficultyLevelExtension on DifficultyLevel {
  String get displayName {
    switch (this) {
      case DifficultyLevel.mild:
        return 'Mild';
      case DifficultyLevel.moderate:
        return 'Moderate';
      case DifficultyLevel.spicy:
        return 'Spicy';
    }
  }

  String get emoji {
    switch (this) {
      case DifficultyLevel.mild:
        return '🟢';
      case DifficultyLevel.moderate:
        return '🟡';
      case DifficultyLevel.spicy:
        return '🔴';
    }
  }

  Color get color {
    switch (this) {
      case DifficultyLevel.mild:
        return const Color(0xFF10B981); // Green
      case DifficultyLevel.moderate:
        return const Color(0xFFF59E0B); // Amber
      case DifficultyLevel.spicy:
        return const Color(0xFFEF4444); // Red
    }
  }

  String get description {
    switch (this) {
      case DifficultyLevel.mild:
        return 'Family-friendly content';
      case DifficultyLevel.moderate:
        return 'Standard party vibes';
      case DifficultyLevel.spicy:
        return 'Bold & daring content';
    }
  }

  String get storageKey {
    return name; // 'mild', 'moderate', or 'spicy'
  }

  static DifficultyLevel fromString(String value) {
    switch (value) {
      case 'mild':
        return DifficultyLevel.mild;
      case 'moderate':
        return DifficultyLevel.moderate;
      case 'spicy':
        return DifficultyLevel.spicy;
      default:
        return DifficultyLevel.moderate; // Default fallback
    }
  }
}
