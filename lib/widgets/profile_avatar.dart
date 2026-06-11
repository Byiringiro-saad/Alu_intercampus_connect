import 'package:flutter/material.dart';
import '../services/profile_image_service.dart';

/// User avatar — empty placeholder until a photo is uploaded.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    this.radius = 24,
    this.backgroundColor,
    this.iconColor,
  });

  final String avatarUrl;
  final double radius;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final provider = ProfileImageService.imageProvider(avatarUrl);

    if (provider == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.person_outline_rounded,
          size: radius * 0.95,
          color: iconColor ??
              Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.38),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: provider,
    );
  }
}
