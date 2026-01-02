import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// An enhanced animated card widget with flip animation and glassmorphism
class AnimatedGameCard extends StatefulWidget {
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
  State<AnimatedGameCard> createState() => _AnimatedGameCardState();
}

class _AnimatedGameCardState extends State<AnimatedGameCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedGameCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && !widget.isLoading) {
      _flipController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * math.pi;
        final isFront = angle < math.pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isFront ? _buildFrontCard() : _buildBackCard(),
        );
      },
    );
  }

  Widget _buildFrontCard() {
    return _buildCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon with glow
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.color.withOpacity(0.3),
                  widget.color.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              color: widget.color,
              size: 48,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: 2000.ms,
                color: widget.color.withOpacity(0.5),
              )
              .then()
              .shake(duration: 1000.ms, hz: 0.5, rotation: 0.05),

          const SizedBox(height: 32),

          // Text content with better hierarchy
          if (widget.isLoading)
            Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.loadingText ?? 'Loading...',
                  style: TextStyle(
                    color: widget.color.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .fadeIn(duration: 800.ms)
                    .then()
                    .fadeOut(duration: 800.ms),
              ],
            )
          else
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.4,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms)
                .slideY(begin: 0.3, end: 0, duration: 400.ms, delay: 300.ms)
                .shimmer(
                  duration: 1500.ms,
                  delay: 600.ms,
                  color: widget.color.withOpacity(0.3),
                ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: _buildCard(
        child: Center(
          child: Icon(
            widget.icon,
            color: widget.color.withOpacity(0.3),
            size: 80,
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 320),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1F2937).withOpacity(0.9),
                  const Color(0xFF111827).withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.color.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.color.withOpacity(0.05),
                          Colors.transparent,
                          widget.color.withOpacity(0.03),
                        ],
                      ),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), duration: 400.ms);
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }
}
