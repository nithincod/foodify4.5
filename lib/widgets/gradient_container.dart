import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderRadius;
  final double elevation;

  const GradientContainer({
    Key? key,
    required this.child,
    this.gradientColors = const [Color(0xFF4A90E2), Color(0xFF145AE0)], // Default gradient colors
    this.borderRadius = 12.0,
    this.elevation = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: elevation,
            offset: Offset(0, 4), // Subtle shadow below
          ),
        ],
      ),
      child: child,
    );
  }
}
