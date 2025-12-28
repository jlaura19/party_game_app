import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import '../providers/app_providers.dart';
import '../widgets/gradient_button.dart';

/// Debate Duel screen - AI-only mode
class DebateDuelScreen extends ConsumerStatefulWidget {
  const DebateDuelScreen({super.key});

  @override
  ConsumerState<DebateDuelScreen> createState() => _DebateDuelScreenState();
}

class _DebateDuelScreenState extends ConsumerState<DebateDuelScreen> {
  String _topic = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final vibrationEnabled = ref.watch(vibrationEnabledProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0891B2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Row(
          children: [
            Icon(Icons.gavel, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Debate Duel',
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
            color: const Color(0xFF0E7490),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon and title
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0891B2).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.gavel,
                      color: Color(0xFF0891B2),
                      size: 40,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .scale(delay: 100.ms),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Settle the Score',
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
                    'Two friends enter, one leaves (metaphorically).',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 300.ms),
                  
                  const SizedBox(height: 48),
                  
                  // Topic display
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 200),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      border: Border.all(
                        color: const Color(0xFF0891B2).withOpacity(0.3),
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
                    child: Center(
                      child: _isLoading
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF0891B2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Finding a controversial topic...',
                                  style: TextStyle(
                                    color: Color(0xFF0891B2),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                              .animate(onPlay: (controller) => controller.repeat())
                              .fadeIn(duration: 600.ms)
                              .then()
                              .fadeOut(duration: 600.ms)
                          : _topic.isEmpty
                              ? const Text(
                                  'Tap below to generate a topic',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'THE TOPIC',
                                      style: TextStyle(
                                        color: Color(0xFF0891B2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '"$_topic"',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                                  .animate()
                                  .fadeIn(duration: 400.ms)
                                  .slideY(begin: 0.2, end: 0),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .scale(delay: 500.ms),
                  
                  const SizedBox(height: 32),
                  
                  // Generate button
                  GradientButton(
                    text: 'New Debate',
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (vibrationEnabled &&
                                await Vibration.hasVibrator() == true) {
                              Vibration.vibrate(duration: 50);
                            }
                            _generateTopic();
                          },
                    gradientColors: const [Color(0xFF0891B2), Color(0xFF0E7490)],
                    icon: Icons.auto_awesome,
                    width: double.infinity,
                    height: 64,
                    isLoading: _isLoading,
                  )
                      .animate()
                      .fadeIn(delay: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateTopic() async {
    setState(() => _isLoading = true);
    
    final gemini = ref.read(geminiServiceProvider);
    final topic = await gemini.generateDebateTopic();
    
    setState(() {
      _topic = topic;
      _isLoading = false;
    });
  }
}
