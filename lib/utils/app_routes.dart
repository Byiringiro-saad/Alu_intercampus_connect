import 'package:flutter/material.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/main_shell.dart';
import '../screens/events/event_details_screen.dart';
import '../screens/events/my_rsvps_screen.dart';
import '../screens/events/create_opportunity_screen.dart';
import '../screens/events/create_preview_screen.dart';
import '../screens/communities/community_details_screen.dart';
import '../screens/chat/chat_detail_screen.dart';
import '../screens/chat/new_chat_screen.dart';
import '../screens/chat/create_group_screen.dart';
import '../screens/profile/saved_opportunities_screen.dart';
import '../screens/profile/participation_history_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/notifications_screen.dart';
import '../screens/profile/leaderboard_screen.dart';
import '../screens/profile/impact_dashboard_screen.dart';
import '../screens/profile/achievements_screen.dart';
import '../screens/profile/qr_checkin_screen.dart';
import '../screens/misc/network_unavailable_screen.dart';

/// Named route map — central navigation registry for the entire app.
/// Using named routes keeps screen transitions predictable during demos.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String eventDetails = '/event-details';
  static const String myRsvps = '/my-rsvps';
  static const String createOpportunity = '/create-opportunity';
  static const String createPreview = '/create-preview';
  static const String communityDetails = '/community-details';
  static const String chatDetail = '/chat-detail';
  static const String newChat = '/new-chat';
  static const String createGroup = '/create-group';
  static const String savedOpportunities = '/saved-opportunities';
  static const String participationHistory = '/participation-history';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String notifications = '/notifications';
  static const String leaderboard = '/leaderboard';
  static const String impactDashboard = '/impact-dashboard';
  static const String achievements = '/achievements';
  static const String qrCheckin = '/qr-checkin';
  static const String networkUnavailable = '/network-unavailable';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        onboarding: (_) => const OnboardingScreen(),
        login: (_) => const LoginScreen(),
        signup: (_) => const SignupScreen(),
        main: (_) => const MainShell(),
        eventDetails: (_) => const EventDetailsScreen(),
        myRsvps: (_) => const MyRsvpsScreen(),
        createOpportunity: (_) => const CreateOpportunityScreen(),
        createPreview: (_) => const CreatePreviewScreen(),
        communityDetails: (_) => const CommunityDetailsScreen(),
        chatDetail: (_) => const ChatDetailScreen(),
        newChat: (_) => const NewChatScreen(),
        createGroup: (_) => const CreateGroupScreen(),
        savedOpportunities: (_) => const SavedOpportunitiesScreen(),
        participationHistory: (_) => const ParticipationHistoryScreen(),
        settings: (_) => const SettingsScreen(),
        editProfile: (_) => const EditProfileScreen(),
        notifications: (_) => const NotificationsScreen(),
        leaderboard: (_) => const LeaderboardScreen(),
        impactDashboard: (_) => const ImpactDashboardScreen(),
        achievements: (_) => const AchievementsScreen(),
        qrCheckin: (_) => const QrCheckinScreen(),
        networkUnavailable: (_) => const NetworkUnavailableScreen(),
      };

  /// Returns to the main shell after multi-step flows (e.g. publish) without
  /// signing the user out or popping to splash/login.
  static void popToMain(BuildContext context) {
    final navigator = Navigator.of(context);

    while (context.mounted) {
      final name = ModalRoute.of(context)?.settings.name;
      if (name == main) return;

      if (!navigator.canPop()) break;
      navigator.pop();
    }

    if (context.mounted &&
        ModalRoute.of(context)?.settings.name != main) {
      navigator.pushNamedAndRemoveUntil(main, (_) => false);
    }
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case eventDetails:
      case communityDetails:
      case chatDetail:
      case createPreview:
        return MaterialPageRoute(
          builder: routes[settings.name]!,
          settings: settings,
        );
      default:
        return null;
    }
  }
}
