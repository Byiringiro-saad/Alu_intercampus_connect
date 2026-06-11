import 'package:flutter/material.dart';

/// Overlapping avatar row for event attendees display.
class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    required this.avatarUrls,
    this.size = 32,
    this.maxDisplay = 4,
    this.overflowText,
  });

  final List<String> avatarUrls;
  final double size;
  final int maxDisplay;
  final String? overflowText;

  @override
  Widget build(BuildContext context) {
    final display = avatarUrls.take(maxDisplay).toList();
    final remaining = avatarUrls.length - display.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size + (display.length - 1) * (size * 0.65),
          height: size,
          child: Stack(
            children: List.generate(display.length, (i) {
              return Positioned(
                left: i * (size * 0.65),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: size / 2,
                    backgroundImage: NetworkImage(display[i]),
                  ),
                ),
              );
            }),
          ),
        ),
        if (overflowText != null) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              overflowText!,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ] else if (remaining > 0) ...[
          const SizedBox(width: 4),
          Text(
            '+$remaining',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
