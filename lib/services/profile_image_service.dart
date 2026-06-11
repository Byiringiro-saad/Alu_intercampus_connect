import 'package:flutter/material.dart';
import 'local_image_service.dart';

/// Profile photo helpers — delegates to [LocalImageService].
class ProfileImageService {
  ProfileImageService._();

  static bool hasAvatar(String avatarUrl) =>
      LocalImageService.hasImage(avatarUrl);

  static ImageProvider? imageProvider(String avatarUrl) =>
      LocalImageService.imageProvider(avatarUrl);

  static Future<String?> pickAndSaveFromGallery() =>
      LocalImageService.pickFromGallery(maxWidth: 1200, maxHeight: 1200);
}
