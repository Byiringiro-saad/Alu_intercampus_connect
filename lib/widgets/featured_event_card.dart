import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../utils/app_colors.dart';
import '../utils/app_decorations.dart';
import 'cover_image.dart';

/// Editor's pick — asymmetric layout, storytelling over poster card.
class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.heroTag,
  });

  final EventModel event;
  final VoidCallback onTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.brand(isDark);
    final dateStr = DateFormat('EEEE, MMM d').format(event.date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
          child: Ink(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.surface,
              borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
              border: Border.all(
                color: accent.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppDecorations.radiusXs),
                        ),
                        child: Text(
                          "EDITOR'S PICK",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style:
                                  Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '$dateStr · ${event.time}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.location,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Hero(
                        tag: heroTag ?? 'featured-${event.id}',
                        child: CoverImage(
                          imagePath: event.imageUrl,
                          width: 100,
                          height: 120,
                          borderRadius:
                              BorderRadius.circular(AppDecorations.radiusMd),
                          placeholderIcon: Icons.event_outlined,
                        ),
                      ),
                    ],
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
