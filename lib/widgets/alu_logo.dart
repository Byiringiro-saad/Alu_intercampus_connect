import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

/// ALU Connect wordmark — brand magenta typography.
class AluLogo extends StatelessWidget {
  const AluLogo({super.key, this.size = 80, this.showTagline = false});

  final double size;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brand = AppColors.brand(isDark);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'ALU',
              style: TextStyle(
                fontFamily:
                    Theme.of(context).textTheme.displaySmall?.fontFamily,
                fontSize: size * 0.42,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.2,
                color: brand,
                height: 1,
              ),
            ),
            Container(
              width: 3,
              height: size * 0.34,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.brandMid,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Connect',
              style: TextStyle(
                fontFamily:
                    Theme.of(context).textTheme.displaySmall?.fontFamily,
                fontSize: size * 0.42,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.6,
                color: isDark ? Colors.white : AppColors.navy,
                height: 1,
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 14),
          Text(
            AppConstants.tagline,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  letterSpacing: 0.4,
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
