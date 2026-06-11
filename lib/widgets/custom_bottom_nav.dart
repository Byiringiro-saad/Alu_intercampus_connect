import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_decorations.dart';

/// Minimal dock navigation — four destinations, no floating FAB.
class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.chatBadge = 0,
    this.notificationBadge = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int chatBadge;
  final int notificationBadge;

  static const _items = [
    (icon: Icons.explore_outlined, active: Icons.explore_rounded, label: 'Discover'),
    (icon: Icons.hub_outlined, active: Icons.hub_rounded, label: 'Hubs'),
    (icon: Icons.forum_outlined, active: Icons.forum_rounded, label: 'Messages'),
    (icon: Icons.account_circle_outlined, active: Icons.account_circle_rounded, label: 'You'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDecorations.radiusXl),
          border: Border.all(color: AppDecorations.borderColor(context)),
          boxShadow: AppDecorations.softShadow(context),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          destinations: List.generate(_items.length, (i) {
            final item = _items[i];
            final badge = i == 2 ? chatBadge : (i == 3 ? notificationBadge : 0);
            return NavigationDestination(
              icon: _BadgedIcon(
                icon: item.icon,
                badge: badge,
                isDark: isDark,
              ),
              selectedIcon: _BadgedIcon(
                icon: item.active,
                badge: badge,
                isDark: isDark,
                selected: true,
              ),
              label: item.label,
            );
          }),
        ),
      ),
    );
  }
}

class _BadgedIcon extends StatelessWidget {
  const _BadgedIcon({
    required this.icon,
    required this.badge,
    required this.isDark,
    this.selected = false,
  });

  final IconData icon;
  final int badge;
  final bool isDark;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: badge > 0,
      label: Text('$badge'),
      backgroundColor: AppColors.navyMid,
      child: Icon(icon, size: 22),
    );
  }
}
