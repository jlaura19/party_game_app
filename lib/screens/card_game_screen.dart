import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import '../models/game_mode.dart';
import '../providers/game_providers.dart';
import '../providers/app_providers.dart';
import '../widgets/animated_game_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/particle_effect.dart';

/// Generic card game screen for Never Have I Ever and Most Likely To
class CardGameScreen extends ConsumerStatefulWidget {
  final GameMode mode;

  const CardGameScreen({
    super.key,
    required this.mode,
  });

  @override
  ConsumerState<CardGameScreen> createState() => _CardGameScreenState();
}

class _CardGameScreenState extends ConsumerState<CardGameScreen> {
  bool _showParticles = false;

  @override
  Widget build(BuildContext context) {
    // Select the appropriate provider based on game mode
    final provider = widget.mode == GameMode.neverHaveIEver
        ? neverHaveIEverProvider
        : mostLikelyToProvider;
    
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    final gemini = ref.read(geminiServiceProvider);
    final vibrationEnabled = ref.watch(vibrationEnabledProvider);
    final difficulty = ref.watch(difficultyProvider);
    final difficultyNotifier = ref.read(difficultyProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: widget.mode.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Icon(widget.mode.icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              widget.mode.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Colored header extension
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.mode.gradientColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Difficulty Selector
                      DifficultySelector(
                        selectedDifficulty: difficulty,
                        onDifficultyChanged: (newDifficulty) {
                          difficultyNotifier.setDifficulty(newDifficulty);
                          // Refresh card with new difficulty
                          notifier.nextCard();
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      const Spacer(),
                      
                      // Game card
                      AnimatedGameCard(
                        key: ValueKey(state.currentCard.text),
                        text: state.currentCard.text,
                        color: widget.mode.primaryColor,
                        icon: widget.mode.icon,
                        isLoading: state.isLoading,
                        loadingText: 'Consulting the party gods...',
                      ),
                      
                      const Spacer(),
                      
                      // Buttons
                      Column(
                        children: [
                          // Next Card button
                          GradientButton(
                            text: 'Next Card',
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    _vibrate(vibrationEnabled);
                                    notifier.nextCard();
                                  },
                            gradientColors: widget.mode.gradientColors,
                            width: double.infinity,
                            height: 64,
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // AI Remix button
                          GradientButton(
                            text: 'AI Remix ✨',
                            onPressed: state.isLoading
                                ? null
                                : () async {
                                    _vibrate(vibrationEnabled);
                                    await _generateAI(notifier, gemini, difficulty);
                                    // Trigger particle effect
                                    setState(() => _showParticles = true);
                                    Future.delayed(const Duration(milliseconds: 100), () {
                                      if (mounted) {
                                        setState(() => _showParticles = false);
                                      }
                                    });
                                  },
                            gradientColors: const [
                              Color(0xFFEAB308),
                              Color(0xFFCA8A04),
                            ],
                            icon: Icons.auto_awesome,
                            width: double.infinity,
                            height: 56,
                            isOutlined: true,
                            isLoading: state.isLoading,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Particle effect overlay
          ParticleEffect(
            isActive: _showParticles,
            particleCount: 40,
            type: ParticleType.confetti,
          ),
        ],
      ),
    );
  }

  Future<void> _generateAI(notifier, gemini, difficulty) async {
    if (widget.mode == GameMode.neverHaveIEver) {
      await notifier.generateAICard(() => gemini.generateNeverHaveIEver(difficulty));
    } else {
      await notifier.generateAICard(() => gemini.generateMostLikelyTo(difficulty));
    }
  }

  Future<void> _vibrate(bool enabled) async {
    if (enabled && await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 50);
    }
  }
}
