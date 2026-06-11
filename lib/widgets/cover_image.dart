import 'package:flutter/material.dart';
import '../services/local_image_service.dart';
import '../utils/app_decorations.dart';

/// Displays a cover/thumbnail from a local path or legacy URL.
class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderIcon = Icons.image_outlined,
  });

  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final provider = LocalImageService.imageProvider(imagePath);
    final radius =
        borderRadius ?? BorderRadius.circular(AppDecorations.radiusSm);

    if (provider == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppDecorations.mutedSurface(context),
          borderRadius: radius,
          border: Border.all(color: AppDecorations.borderColor(context)),
        ),
        child: Icon(
          placeholderIcon,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.28),
        ),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: Image(
        image: provider,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => Container(
          width: width,
          height: height,
          color: AppDecorations.mutedSurface(context),
          child: Icon(placeholderIcon),
        ),
      ),
    );
  }
}
