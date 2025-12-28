import 'package:flutter/material.dart';

/// A gradient button widget matching the HTML version's style
class GradientButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isOutlined
                  ? null
                  : LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              border: isOutlined
                  ? Border.all(color: gradientColors.first, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(12),
              boxShadow: !isOutlined
                  ? [
                      BoxShadow(
                        color: gradientColors.first.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: isOutlined ? gradientColors.first : Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            color: isOutlined ? gradientColors.first : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
