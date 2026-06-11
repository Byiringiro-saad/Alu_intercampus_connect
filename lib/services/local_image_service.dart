import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Picks and resolves locally uploaded images (profile, covers, etc.).
class LocalImageService {
  LocalImageService._();

  static final ImagePicker _picker = ImagePicker();

  static bool hasImage(String path) => path.trim().isNotEmpty;

  static ImageProvider? imageProvider(String path) {
    final value = path.trim();
    if (value.isEmpty) return null;

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return NetworkImage(value);
    }

    if (kIsWeb) {
      return NetworkImage(value);
    }

    final file = File(value);
    if (file.existsSync()) {
      return FileImage(file);
    }

    return null;
  }

  static Future<String?> pickFromGallery({
    double maxWidth = 1600,
    double maxHeight = 1200,
    int imageQuality = 85,
  }) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    if (picked == null) return null;

    final path = picked.path;
    if (path.isEmpty) return null;

    return path;
  }
}
