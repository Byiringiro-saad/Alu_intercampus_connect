/// App-wide constants for leadership scoring and navigation.
class AppConstants {
  AppConstants._();

  static const String appName = 'ALU Connect';
  static const String tagline = 'Discover. Connect. Lead.';

  /// Pre-seeded evaluator account (see README).
  static const String demoEmail = 'student@alustudent.com';

  static const int scoreEventAttendance = 15;
  static const int scoreCommunityJoin = 10;
  static const int scoreHackathon = 25;
  static const int scoreWorkshop = 12;
  static const int scoreLeadershipProgram = 20;
  static const int maxLeadershipScore = 500;

  static const List<String> campuses = [
    'Rwanda Campus',
    'Mauritius Campus',
  ];

  static const List<String> filterCategories = [
    'All',
    'Events',
    'Hackathons',
    'Workshops',
    'Startups',
    'Leadership',
    'Internships',
    'Announcements',
  ];

  static const List<String> interestOptions = [
    'Entrepreneurship',
    'AI & Data Science',
    'Leadership',
    'Startups',
    'Climate Action',
    'Software Engineering',
    'Events',
    'Hackathons',
    'Networking',
  ];
}
