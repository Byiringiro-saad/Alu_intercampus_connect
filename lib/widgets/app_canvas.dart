import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_decorations.dart';

/// Page canvas — whitish wash with whisper-soft brand atmosphere.
class AppCanvas extends StatelessWidget {
  const AppCanvas({
    super.key,
    required this.child,
    this.showAccent = false,
  });

  final Widget child;
  final bool showAccent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppDecorations.pageWash(isDark: isDark),
      ),
      child: Stack(
        children: [
          if (showAccent) ...[
            Positioned(
              top: -100,
              right: -80,
              child: _Orb(
                size: 260,
                color: AppColors.brandBright.withValues(
                  alpha: isDark ? 0.1 : 0.07,
                ),
              ),
            ),
            Positioned(
              top: 180,
              left: -100,
              child: _Orb(
                size: 200,
                color: AppColors.brandSoft.withValues(
                  alpha: isDark ? 0.08 : 0.05,
                ),
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
