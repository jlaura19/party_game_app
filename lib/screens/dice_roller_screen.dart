import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import '../providers/game_providers.dart';
import '../providers/app_providers.dart';
import '../widgets/animated_dice.dart';
import '../widgets/gradient_button.dart';

/// Dice Roller screen with 3D animated dice
class DiceRollerScreen extends ConsumerWidget {
  const DiceRollerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diceProvider);
    final notifier = ref.read(diceProvider.notifier);
    final vibrationEnabled = ref.watch(vibrationEnabledProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDB2777),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Row(
          children: [
            Icon(Icons.casino, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Dice Roller',
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
            color: const Color(0xFFBE185D),
          ),
          
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Dice
                AnimatedDice(
                  value: state.value,
                  isRolling: state.isRolling,
                  color: const Color(0xFFDB2777),
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(delay: 100.ms),
                
                const SizedBox(height: 48),
                
                // Result number (when not rolling)
                if (!state.isRolling)
                  Text(
                    state.value.toString(),
                    style: const TextStyle(
                      color: Color(0xFFDB2777),
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                        duration: 300.ms,
                        curve: Curves.elasticOut,
                      ),
                
                const Spacer(),
                
                // Roll button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: GradientButton(
                    text: state.isRolling ? 'Rolling...' : 'Roll Dice',
                    onPressed: state.isRolling
                        ? null
                        : () async {
                            if (vibrationEnabled &&
                                await Vibration.hasVibrator() == true) {
                              Vibration.vibrate(duration: 100);
                            }
                            notifier.roll();
                          },
                    gradientColors: const [Color(0xFFDB2777), Color(0xFFBE185D)],
                    icon: Icons.casino,
                    width: double.infinity,
                    height: 64,
                    isLoading: state.isRolling,
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
