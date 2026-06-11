import 'package:flutter/material.dart';
import '../services/local_image_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_decorations.dart';
import 'cover_image.dart';

/// Upload area for opportunity / community cover images.
class CoverImagePicker extends StatefulWidget {
  const CoverImagePicker({
    super.key,
    required this.imagePath,
    required this.onChanged,
    this.height = 180,
    this.label = 'Cover image',
  });

  final String imagePath;
  final ValueChanged<String> onChanged;
  final double height;
  final String label;

  @override
  State<CoverImagePicker> createState() => _CoverImagePickerState();
}

class _CoverImagePickerState extends State<CoverImagePicker> {
  bool _isPicking = false;

  Future<void> _upload() async {
    setState(() => _isPicking = true);
    try {
      final path = await LocalImageService.pickFromGallery();
      if (!mounted) return;
      if (path != null) {
        widget.onChanged(path);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('MissingPluginException')
                ? 'Restart the app with "flutter run", then try uploading again.'
                : 'Could not upload image: $e',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = LocalImageService.hasImage(widget.imagePath);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _isPicking ? null : _upload,
          child: Container(
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
              border: Border.all(
                color: hasImage
                    ? AppDecorations.borderColor(context)
                    : AppColors.navyMid.withValues(alpha: 0.35),
                width: hasImage ? 1 : 1.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasImage
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      CoverImage(
                        imagePath: widget.imagePath,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: FilledButton.tonal(
                          onPressed: _isPicking ? null : _upload,
                          child: const Text('Change'),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: _isPicking
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_rounded,
                                size: 40,
                                color: AppColors.navyDeep,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Tap to upload cover image',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Required for all activity types',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                  ),
          ),
        ),
        if (hasImage) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => widget.onChanged(''),
              child: const Text('Remove image'),
            ),
          ),
        ],
      ],
    );
  }
}
