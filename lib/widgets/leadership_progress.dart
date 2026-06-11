import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_decorations.dart';
import '../utils/app_routes.dart';

/// Compact leadership journey card — narrative, not a progress bar widget.
class LeadershipProgress extends StatelessWidget {
  const LeadershipProgress({
    super.key,
    required this.score,
    required this.progress,
    required this.level,
    this.compact = false,
  });

  final int score;
  final double progress;
  final String level;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.brand(isDark);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 22),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.impactDashboard),
          borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: AppDecorations.surfaceCard(context),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDecorations.radiusSm),
                  ),
                  child: Icon(
                    Icons.auto_graph_rounded,
                    color: accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Leadership journey',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        level,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (!compact) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 5,
                            backgroundColor: AppDecorations.mutedSurface(context),
                            color: accent,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$score',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: accent,
                          ),
                    ),
                    Text(
                      'pts',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
