import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../utils/app_colors.dart';
import '../utils/app_decorations.dart';
import 'cover_image.dart';

/// Editorial opportunity row — date column + content, not a full-bleed poster card.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.onRsvp,
    this.onSave,
    this.onShare,
    this.isSaved = false,
    this.isGoing = false,
    this.showMatchScore = false,
    this.heroTag,
    this.compact = false,
  });

  final EventModel event;
  final VoidCallback onTap;
  final VoidCallback? onRsvp;
  final VoidCallback? onSave;
  final VoidCallback? onShare;
  final bool isSaved;
  final bool isGoing;
  final bool showMatchScore;
  final String? heroTag;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.brand(isDark);
    final day = DateFormat('d').format(event.date);
    final month = DateFormat('MMM').format(event.date).toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
          child: Ink(
            decoration: AppDecorations.surfaceCard(context),
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppDecorations.radiusSm),
                  ),
                  child: Column(
                    children: [
                      Text(
                        month,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                      ),
                      Text(
                        day,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: accent,
                              fontSize: 22,
                              height: 1,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _CategoryTag(label: event.category.label),
                          if (showMatchScore && event.matchScore > 0) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${event.matchScore}% fit',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppColors.success),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: compact ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${event.organizer} · ${event.location}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!compact) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              '${event.participantCount} attending',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const Spacer(),
                            if (onSave != null)
                              IconButton(
                                onPressed: onSave,
                                icon: Icon(
                                  isSaved
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_outline_rounded,
                                  size: 20,
                                  color: isSaved ? AppColors.navyMid : null,
                                ),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            if (onRsvp != null) ...[
                              const SizedBox(width: 12),
                              TextButton(
                                onPressed: onRsvp,
                                style: TextButton.styleFrom(
                                  backgroundColor: isGoing
                                      ? AppColors.success.withValues(alpha: 0.15)
                                      : accent.withValues(alpha: 0.1),
                                  foregroundColor:
                                      isGoing ? AppColors.success : accent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  isGoing ? 'Going' : 'RSVP',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(width: 10),
                  Hero(
                    tag: heroTag ?? 'event-image-${event.id}',
                    child: CoverImage(
                      imagePath: event.imageUrl,
                      width: 64,
                      height: 64,
                      placeholderIcon: Icons.event_outlined,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
    );
  }
}
