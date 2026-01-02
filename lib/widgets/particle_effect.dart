import 'dart:math';
import 'package:flutter/material.dart';

/// Particle for confetti/sparkle effects
class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double rotation;
  double rotationSpeed;
  double opacity;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    this.opacity = 1.0,
  });
}

/// Particle effect widget for celebrations
class ParticleEffect extends StatefulWidget {
  final bool isActive;
  final int particleCount;
  final Duration duration;
  final ParticleType type;

  const ParticleEffect({
    super.key,
    required this.isActive,
    this.particleCount = 50,
    this.duration = const Duration(seconds: 2),
    this.type = ParticleType.confetti,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

enum ParticleType {
  confetti,
  sparkle,
  stars,
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        setState(() {
          _updateParticles();
        });
      });
  }

  @override
  void didUpdateWidget(ParticleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _initParticles();
      _controller.forward(from: 0);
    }
  }

  void _initParticles() {
    _particles.clear();
    final size = MediaQuery.of(context).size;

    for (int i = 0; i < widget.particleCount; i++) {
      final color = _getRandomColor();
      final startX = size.width / 2;
      final startY = size.height / 2;

      _particles.add(Particle(
        position: Offset(startX, startY),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 400,
          -_random.nextDouble() * 300 - 100,
        ),
        color: color,
        size: _random.nextDouble() * 8 + 4,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
      ));
    }
  }

  Color _getRandomColor() {
    switch (widget.type) {
      case ParticleType.confetti:
        final colors = [
          const Color(0xFFEF4444),
          const Color(0xFFF59E0B),
          const Color(0xFF10B981),
          const Color(0xFF3B82F6),
          const Color(0xFF8B5CF6),
          const Color(0xFFEC4899),
        ];
        return colors[_random.nextInt(colors.length)];
      case ParticleType.sparkle:
        return const Color(0xFFFFD700);
      case ParticleType.stars:
        return Colors.white;
    }
  }

  void _updateParticles() {
    final progress = _controller.value;
    final gravity = 500.0;

    for (var particle in _particles) {
      // Update position
      particle.position = Offset(
        particle.position.dx + particle.velocity.dx * 0.016,
        particle.position.dy + particle.velocity.dy * 0.016,
      );

      // Apply gravity
      particle.velocity = Offset(
        particle.velocity.dx * 0.99,
        particle.velocity.dy + gravity * 0.016,
      );

      // Update rotation
      particle.rotation += particle.rotationSpeed * 0.016;

      // Fade out
      particle.opacity = 1.0 - progress;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive && _particles.isEmpty) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: CustomPaint(
        painter: _ParticlePainter(_particles),
        size: Size.infinite,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw confetti as rectangles
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: particle.size,
        height: particle.size * 1.5,
      );
      canvas.drawRect(rect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}
