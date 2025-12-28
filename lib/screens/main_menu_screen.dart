import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/game_mode.dart';
import '../constants/app_colors.dart';
import 'card_game_screen.dart';
import 'truth_dare_screen.dart';
import 'roast_master_screen.dart';
import 'debate_duel_screen.dart';
import 'bartender_screen.dart';
import 'dice_roller_screen.dart';

/// Main menu screen with all game modes
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              
              // Title
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF9333EA), Color(0xFFDB2777)],
                ).createShader(bounds),
                child: const Text(
                  'Party Game\nCompanion',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 8),
              
              const Text(
                'Pick a game to start the chaos.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms),
              
              const SizedBox(height: 32),
              
              // Game mode grid
              _buildGameGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context) {
    final modes = GameMode.values;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: modes.length,
      itemBuilder: (context, index) {
        final mode = modes[index];
        final delay = (index * 100).ms;
        
        return _GameModeCard(mode: mode)
            .animate()
            .fadeIn(delay: delay, duration: 400.ms)
            .slideY(begin: 0.3, end: 0, delay: delay, duration: 400.ms);
      },
    );
  }
}

/// Individual game mode card
class _GameModeCard extends StatelessWidget {
  final GameMode mode;

  const _GameModeCard({required this.mode});

  @override
  Widget build(BuildContext context) {
    final isSmall = mode.gridSpan == 1;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToGame(context),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: mode.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: mode.isAIOnly
                ? Border.all(
                    color: mode.gradientColors.first.withOpacity(0.3),
                    width: 1,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: mode.primaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isSmall
                ? _buildSmallCard()
                : _buildLargeCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeCard() {
    return Row(
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            mode.icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mode.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              if (mode.hasAI)
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: AppColors.aiFeature,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          mode.subtitle,
                          style: const TextStyle(
                            color: AppColors.aiFeature,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  mode.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            mode.icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          mode.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        if (mode.hasAI)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFEAB308),
                size: 10,
              ),
              const SizedBox(width: 4),
              Text(
                mode.subtitle,
                style: const TextStyle(
                  color: Color(0xFFEAB308),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _navigateToGame(BuildContext context) {
    Widget screen;
    
    switch (mode) {
      case GameMode.neverHaveIEver:
        screen = CardGameScreen(mode: mode);
        break;
      case GameMode.mostLikelyTo:
        screen = CardGameScreen(mode: mode);
        break;
      case GameMode.truthOrDare:
        screen = const TruthDareScreen();
        break;
      case GameMode.roastMaster:
        screen = const RoastMasterScreen();
        break;
      case GameMode.debateDuel:
        screen = const DebateDuelScreen();
        break;
      case GameMode.bartender:
        screen = const BartenderScreen();
        break;
      case GameMode.diceRoller:
        screen = const DiceRollerScreen();
        break;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
