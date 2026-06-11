import 'package:flutter/material.dart';
import 'app_canvas.dart';

/// @deprecated Use [AppCanvas] instead.
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.showOrbs = false,
  });

  final Widget child;
  final bool showOrbs;

  @override
  Widget build(BuildContext context) {
    return AppCanvas(showAccent: showOrbs, child: child);
  }
}
