import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import '../providers/game_providers.dart';
import '../providers/app_providers.dart';
import '../widgets/animated_game_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/difficulty_selector.dart';

/// Truth or Dare game screen
class TruthDareScreen extends ConsumerWidget {
  const TruthDareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(truthOrDareProvider);
    final notifier = ref.read(truthOrDareProvider.notifier);
    final vibrationEnabled = ref.watch(vibrationEnabledProvider);
    final difficulty = ref.watch(difficultyProvider);
    final difficultyNotifier = ref.read(difficultyProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9333EA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Row(
          children: [
            Icon(Icons.local_fire_department, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Truth or Dare',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 8,
            color: const Color(0xFF7E22CE),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: state.mode == TruthOrDareMode.none
                  ? _buildSelection(context, notifier, vibrationEnabled, difficulty, difficultyNotifier)
                  : _buildResult(context, state, notifier, vibrationEnabled),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelection(BuildContext context, notifier, bool vibrationEnabled, difficulty, difficultyNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Difficulty Selector
        DifficultySelector(
          selectedDifficulty: difficulty,
          onDifficultyChanged: (newDifficulty) {
            difficultyNotifier.setDifficulty(newDifficulty);
          },
        ),
        
        const SizedBox(height: 32),
        
        // Truth buttons
        Row(
          children: [
            Expanded(
              child: _buildChoiceButton(
                'TRUTH',
                const Color(0xFF2563EB),
                Icons.psychology,
                () {
                  _vibrate(vibrationEnabled);
                  notifier.pickTruth();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAIButton(
                'AI Truth',
                const Color(0xFF1E40AF),
                () {
                  _vibrate(vibrationEnabled);
                  notifier.generateAITruth();
                },
                difficulty,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.2, end: 0),
        
        const SizedBox(height: 24),
        
        const Text(
          'OR',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms),
        
        const SizedBox(height: 24),
        
        // Dare buttons
        Row(
          children: [
            Expanded(
              child: _buildChoiceButton(
                'DARE',
                const Color(0xFFDC2626),
                Icons.flash_on,
                () {
                  _vibrate(vibrationEnabled);
                  notifier.pickDare();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAIButton(
                'AI Dare',
                const Color(0xFFB91C1C),
                () {
                  _vibrate(vibrationEnabled);
                  notifier.generateAIDare();
                },
                difficulty,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 100.ms, duration: 400.ms)
            .slideX(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildChoiceButton(String text, Color color, IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIButton(String text, Color color, VoidCallback onPressed, [difficulty]) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, state, notifier, bool vibrationEnabled) {
    final color = state.mode == TruthOrDareMode.truth
        ? const Color(0xFF2563EB)
        : const Color(0xFFDC2626);
    
    return Column(
      children: [
        const Spacer(),
        
        AnimatedGameCard(
          key: ValueKey(state.text),
          text: state.text,
          color: color,
          icon: state.mode == TruthOrDareMode.truth
              ? Icons.psychology
              : Icons.flash_on,
          isLoading: state.isLoading,
          loadingText: state.mode == TruthOrDareMode.truth
              ? 'Thinking of something good...'
              : 'Cooking up a challenge...',
        ),
        
        const Spacer(),
        
        GradientButton(
          text: 'Play Again',
          onPressed: () {
            _vibrate(vibrationEnabled);
            notifier.reset();
          },
          gradientColors: const [Color(0xFF9333EA), Color(0xFF7E22CE)],
          icon: Icons.refresh,
          width: double.infinity,
          height: 56,
        ),
        
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _vibrate(bool enabled) async {
    if (enabled && await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 50);
    }
  }
}
