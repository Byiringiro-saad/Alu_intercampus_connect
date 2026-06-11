import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_decorations.dart';
import 'profile_avatar.dart';

/// Editorial page greeting — typography-first, not a gradient banner.
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.greeting,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.trailing,
    this.badge,
  });

  final String greeting;
  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final Widget? trailing;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (badge != null) ...[badge!, const SizedBox(height: 10)],
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 26,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (avatarUrl != null)
            ProfileAvatar(avatarUrl: avatarUrl!, radius: 24),
        ],
      ),
    );
  }
}

/// Small campus location pill.
class CampusPill extends StatelessWidget {
  const CampusPill({super.key, required this.campus});

  final String campus;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppDecorations.mutedSurface(context),
        borderRadius: BorderRadius.circular(AppDecorations.radiusXs),
        border: Border.all(color: AppDecorations.borderColor(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 13,
            color: AppColors.brand(isDark),
          ),
          const SizedBox(width: 4),
          Text(
            campus,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.75)
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
