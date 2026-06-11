import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/achievement.dart';
import '../../utils/app_colors.dart';
import '../../widgets/app_canvas.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/community_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/profile_provider.dart';
import '../chat/chat_list_screen.dart';
import '../communities/communities_screen.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  bool _initialized = false;
  ProfileProvider? _profileProviderRef;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initProviders());
  }

  @override
  void dispose() {
    _profileProviderRef?.removeListener(_onProfileChanged);
    super.dispose();
  }

  Future<void> _initProviders() async {
    final auth = context.read<AuthProvider>();
    final userId = auth.user?.id;
    await Future.wait([
      context.read<EventProvider>().init(userId: userId),
      context.read<CommunityProvider>().init(userId: userId),
      context.read<ChatProvider>().init(),
      context.read<NotificationProvider>().init(),
      context.read<ProfileProvider>().init(auth.user),
    ]);
    if (!mounted) return;
    setState(() => _initialized = true);
    // Start listening for achievement unlocks after init
    _profileProviderRef = context.read<ProfileProvider>()
      ..addListener(_onProfileChanged);
  }

  void _onProfileChanged() {
    if (!mounted) return;
    final toasts = context.read<ProfileProvider>().consumeUnlockToasts();
    for (final achievement in toasts) {
      _showUnlockToast(achievement);
    }
  }

  void _showUnlockToast(Achievement achievement) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(achievement.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Achievement unlocked!',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    achievement.title,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final chat = context.watch<ChatProvider>();
    final notif = context.watch<NotificationProvider>();
    final auth = context.watch<AuthProvider>();

    final screens = const [
      HomeScreen(),
      CommunitiesScreen(),
      ChatListScreen(),
      ProfileScreen(),
    ];

    return AppCanvas(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          chatBadge: auth.user == null
              ? 0
              : chat.totalUnreadForUser(auth.user!.id),
          notificationBadge: notif.unreadCount,
        ),
      ),
    );
  }
}