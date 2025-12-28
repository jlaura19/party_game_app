import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';

/// Provider for GeminiService
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

/// Provider for StorageService - initialized asynchronously
final storageServiceProvider = FutureProvider<StorageService>((ref) async {
  final storageService = StorageService();
  await storageService.init();
  return storageService;
});

/// Provider for vibration enabled setting
final vibrationEnabledProvider = StateProvider<bool>((ref) => true);

/// Provider for sound effects enabled setting
final soundEffectsEnabledProvider = StateProvider<bool>((ref) => true);
