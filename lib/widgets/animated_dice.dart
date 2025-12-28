import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 3D animated dice widget
class AnimatedDice extends StatelessWidget {
  final int value;
  final bool isRolling;
  final Color color;

  const AnimatedDice({
    super.key,
    required this.value,
    required this.isRolling,
    this.color = const Color(0xFFDB2777),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: isRolling ? 720 : _getRotationForValue()),
      duration: Duration(milliseconds: isRolling ? 1000 : 500),
      curve: Curves.easeOut,
      builder: (context, rotation, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(rotation * math.pi / 180)
            ..rotateY(rotation * math.pi / 180)
            ..rotateZ(rotation * math.pi / 180),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  double _getRotationForValue() {
    // Map dice values to rotation angles for realistic 3D effect
    switch (value) {
      case 1:
        return 0;
      case 2:
        return 90;
      case 3:
        return 180;
      case 4:
        return 270;
      case 5:
        return 360;
      case 6:
        return 450;
      default:
        return 0;
    }
  }
}
