import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import '../providers/app_providers.dart';
import '../widgets/gradient_button.dart';

/// Cursed Bartender screen - AI-only mode
class BartenderScreen extends ConsumerStatefulWidget {
  const BartenderScreen({super.key});

  @override
  ConsumerState<BartenderScreen> createState() => _BartenderScreenState();
}

class _BartenderScreenState extends ConsumerState<BartenderScreen> {
  final _ingredientsController = TextEditingController();
  String _recipe = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vibrationEnabled = ref.watch(vibrationEnabledProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF059669),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Row(
          children: [
            Icon(Icons.local_drink, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Cursed Bartender',
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
            color: const Color(0xFF047857),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _recipe.isEmpty && !_isLoading
                  ? _buildInputForm(vibrationEnabled)
                  : _buildRecipeResult(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm(bool vibrationEnabled) {
    return Column(
      children: [
        const SizedBox(height: 40),
        
        // Icon and title
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF059669).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_drink,
            color: Color(0xFF059669),
            size: 40,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(delay: 100.ms),
        
        const SizedBox(height: 24),
        
        const Text(
          'What do you have?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(delay: 200.ms),
        
        const SizedBox(height: 8),
        
        const Text(
          'List random leftovers or just a "vibe".',
          style: TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(delay: 300.ms),
        
        const SizedBox(height: 40),
        
        // Ingredients input
        TextField(
          controller: _ingredientsController,
          maxLines: 5,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'e.g. vodka, orange juice, and a single pickle...\nOR "sad rainy day vibe"',
            hintStyle: const TextStyle(color: Color(0xFF6B7280)),
            filled: true,
            fillColor: const Color(0xFF1F2937),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF374151)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF374151)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF059669), width: 2),
            ),
          ),
          onChanged: (_) => setState(() {}),
        )
            .animate()
            .fadeIn(delay: 400.ms)
            .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 32),
        
        // Generate button
        GradientButton(
          text: 'Mix It Up',
          onPressed: _ingredientsController.text.isEmpty
              ? null
              : () async {
                  if (vibrationEnabled && await Vibration.hasVibrator() == true) {
                    Vibration.vibrate(duration: 50);
                  }
                  _generateRecipe();
                },
          gradientColors: const [Color(0xFF059669), Color(0xFF047857)],
          icon: Icons.auto_awesome,
          width: double.infinity,
          height: 64,
        )
            .animate()
            .fadeIn(delay: 500.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildRecipeResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            border: Border.all(
              color: const Color(0xFF059669).withOpacity(0.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _isLoading
              ? Column(
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Shaking...',
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(duration: 600.ms)
                  .then()
                  .fadeOut(duration: 600.ms)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _recipe,
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .scale(delay: 100.ms),
        
        if (!_isLoading) ...[
          const SizedBox(height: 32),
          
          GradientButton(
            text: 'New Order',
            onPressed: () {
              setState(() {
                _recipe = '';
                _ingredientsController.clear();
              });
            },
            gradientColors: const [Color(0xFF374151), Color(0xFF1F2937)],
            width: double.infinity,
            height: 56,
          )
              .animate()
              .fadeIn(delay: 400.ms),
        ],
      ],
    );
  }

  Future<void> _generateRecipe() async {
    setState(() => _isLoading = true);
    
    final gemini = ref.read(geminiServiceProvider);
    final recipe = await gemini.generateCocktail(_ingredientsController.text);
    
    setState(() {
      _recipe = recipe;
      _isLoading = false;
    });
  }
}
