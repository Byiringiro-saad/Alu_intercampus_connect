import 'package:flutter/material.dart';
import '../models/community.dart';
import '../utils/app_colors.dart';
import '../utils/app_decorations.dart';
import 'cover_image.dart';

/// Community hub row — editorial list item.
class CommunityCard extends StatelessWidget {
  const CommunityCard({
    super.key,
    required this.community,
    required this.onTap,
    required this.onJoinToggle,
  });

  final CommunityModel community;
  final VoidCallback onTap;
  final VoidCallback onJoinToggle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.brand(isDark);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
          child: Ink(
            decoration: AppDecorations.surfaceCard(context),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CoverImage(
                  imagePath: community.imageUrl,
                  width: 56,
                  height: 56,
                  placeholderIcon: Icons.groups_outlined,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${community.memberCount} members',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        community.category.label.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onJoinToggle,
                  style: TextButton.styleFrom(
                    backgroundColor: community.isJoined
                        ? AppColors.success.withValues(alpha: 0.12)
                        : accent.withValues(alpha: 0.1),
                    foregroundColor:
                        community.isJoined ? AppColors.success : accent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    community.isJoined ? 'Joined' : 'Join',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
