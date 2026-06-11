import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_decorations.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF1F2630) : const Color(0xFFE8E4DD);
    final highlight = isDark
        ? const Color(0xFF2A3340)
        : const Color(0xFFF5F3EF);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 100),
        itemCount: itemCount,
        itemBuilder: (_, _) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDecorations.radiusLg),
          ),
        ),
      ),
    );
  }
}
