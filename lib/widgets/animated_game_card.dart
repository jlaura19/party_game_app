import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// An animated card widget for displaying game content
class AnimatedGameCard extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final bool isLoading;
  final String? loadingText;

  const AnimatedGameCard({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
    this.isLoading = false,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        border: Border.all(color: const Color(0xFF374151), width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 40,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .shimmer(
                  duration: 2000.ms,
                  color: color.withOpacity(0.3),
                ),
            
            const SizedBox(height: 24),
            
            // Text content
            if (isLoading)
              Text(
                loadingText ?? 'Loading...',
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(duration: 600.ms)
                  .then()
                  .fadeOut(duration: 600.ms)
            else
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.2, end: 0, duration: 300.ms),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms);
  }
}
