import '../models/event.dart';
import '../models/opportunity_category.dart';
import '../utils/constants.dart';

/// Leadership Journey Score algorithm.
///
/// Points are awarded for meaningful campus engagement:
/// - Event attendance: +15
/// - Community join: +10
/// - Hackathon participation: +25
/// - Workshop: +12
/// - Leadership program: +20
///
/// Score is capped at 500 to keep the progress bar meaningful.
class LeadershipScoreService {
  LeadershipScoreService._();

  static int pointsForEventCategory(OpportunityCategory category) {
    switch (category) {
      case OpportunityCategory.hackathons:
        return AppConstants.scoreHackathon;
      case OpportunityCategory.workshops:
        return AppConstants.scoreWorkshop;
      case OpportunityCategory.leadership:
        return AppConstants.scoreLeadershipProgram;
      default:
        return AppConstants.scoreEventAttendance;
    }
  }

  static int pointsForCommunityJoin() => AppConstants.scoreCommunityJoin;

  static int calculateTotal({
    required int eventsAttended,
    required int communitiesJoined,
    required int hackathonsAttended,
    required int workshopsAttended,
    required int leadershipPrograms,
  }) {
    final total = (eventsAttended * AppConstants.scoreEventAttendance) +
        (communitiesJoined * AppConstants.scoreCommunityJoin) +
        (hackathonsAttended * AppConstants.scoreHackathon) +
        (workshopsAttended * AppConstants.scoreWorkshop) +
        (leadershipPrograms * AppConstants.scoreLeadershipProgram);

    return total.clamp(0, AppConstants.maxLeadershipScore);
  }

  static double progressPercent(int score) =>
      (score / AppConstants.maxLeadershipScore).clamp(0.0, 1.0);

  static String leadershipLevel(int score) {
    if (score >= 400) return 'Leadership Ambassador';
    if (score >= 300) return 'Campus Champion';
    if (score >= 200) return 'Active Contributor';
    if (score >= 100) return 'Emerging Leader';
    if (score >= 50) return 'Explorer';
    return 'Newcomer';
  }

  static int pointsForRsvp(EventModel event) =>
      pointsForEventCategory(event.category);
}
