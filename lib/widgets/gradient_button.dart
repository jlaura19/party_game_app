import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// An enhanced gradient button with press animations and glow effects
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final List<Color> gradientColors;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double? height;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.gradientColors,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isLoading || widget.onPressed == null;

    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: SizedBox(
        width: widget.width,
        height: widget.height ?? 56,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : widget.onPressed,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: widget.isOutlined
                    ? null
                    : LinearGradient(
                        colors: widget.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                border: widget.isOutlined
                    ? Border.all(
                        color: widget.gradientColors.first,
                        width: 2,
                      )
                    : null,
                borderRadius: BorderRadius.circular(16),
                boxShadow: !widget.isOutlined && !isDisabled
                    ? [
                        BoxShadow(
                          color: widget.gradientColors.first.withOpacity(0.4),
                          blurRadius: _isPressed ? 8 : 16,
                          spreadRadius: _isPressed ? 0 : 2,
                          offset: Offset(0, _isPressed ? 2 : 6),
                        ),
                        BoxShadow(
                          color: widget.gradientColors.last.withOpacity(0.3),
                          blurRadius: _isPressed ? 12 : 20,
                          spreadRadius: _isPressed ? 0 : 1,
                          offset: Offset(0, _isPressed ? 4 : 8),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Animated glow overlay (only for non-outlined buttons)
                  if (!widget.isOutlined && !isDisabled)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(
                                    0.2 * (1 - _controller.value),
                                  ),
                                  Colors.transparent,
                                  Colors.white.withOpacity(
                                    0.1 * _controller.value,
                                  ),
                                ],
                                stops: [
                                  _controller.value * 0.3,
                                  _controller.value * 0.5,
                                  _controller.value,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  
                  // Content
                  Center(
                    child: widget.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.isOutlined
                                    ? widget.gradientColors.first
                                    : Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.icon != null) ...[ 
                                Icon(
                                  widget.icon,
                                  color: widget.isOutlined
                                      ? widget.gradientColors.first
                                      : Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                              ],
                              Text(
                                widget.text,
                                style: TextStyle(
                                  color: widget.isOutlined
                                      ? widget.gradientColors.first
                                      : Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 300.ms);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
