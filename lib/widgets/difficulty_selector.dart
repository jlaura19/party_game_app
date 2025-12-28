import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../models/difficulty_level.dart';

/// A beautiful segmented button widget for selecting difficulty level
class DifficultySelector extends StatelessWidget {
  final DifficultyLevel selectedDifficulty;
  final ValueChanged<DifficultyLevel> onDifficultyChanged;

  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: DifficultyLevel.values.map((difficulty) {
          final isSelected = difficulty == selectedDifficulty;
          
          return Expanded(
            child: GestureDetector(
              onTap: () async {
                if (difficulty != selectedDifficulty) {
                  // Haptic feedback
                  if (await Vibration.hasVibrator() ?? false) {
                    Vibration.vibrate(duration: 50);
                  }
                  onDifficultyChanged(difficulty);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? difficulty.color.withValues(alpha: 0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? difficulty.color
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      difficulty.emoji,
                      style: TextStyle(
                        fontSize: isSelected ? 18 : 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        difficulty.displayName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSelected ? 14 : 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A compact version with just icons for smaller spaces
class CompactDifficultySelector extends StatelessWidget {
  final DifficultyLevel selectedDifficulty;
  final ValueChanged<DifficultyLevel> onDifficultyChanged;

  const CompactDifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: DifficultyLevel.values.map((difficulty) {
          final isSelected = difficulty == selectedDifficulty;
          
          return GestureDetector(
            onTap: () async {
              if (difficulty != selectedDifficulty) {
                // Haptic feedback
                if (await Vibration.hasVibrator() ?? false) {
                  Vibration.vibrate(duration: 50);
                }
                onDifficultyChanged(difficulty);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? difficulty.color.withValues(alpha: 0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? difficulty.color
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Text(
                difficulty.emoji,
                style: TextStyle(
                  fontSize: isSelected ? 20 : 16,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
