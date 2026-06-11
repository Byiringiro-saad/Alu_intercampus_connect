enum AchievementCriteriaType {
  leadershipScore,
  eventsAttended,
  communitiesJoined,
  hackathonsAttended,
  startupEventsAttended,
}

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.criteriaType,
    required this.criteriaValue,
    this.isEarned = false,
  });

  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementCriteriaType criteriaType;
  final int criteriaValue;
  final bool isEarned;

  String progressLabel(int current) {
    final remaining = (criteriaValue - current).clamp(0, criteriaValue);
    switch (criteriaType) {
      case AchievementCriteriaType.leadershipScore:
        return '$remaining pts to go';
      case AchievementCriteriaType.eventsAttended:
        return '$remaining more RSVP${remaining == 1 ? '' : 's'} needed';
      case AchievementCriteriaType.communitiesJoined:
        return '$remaining more hub${remaining == 1 ? '' : 's'} to join';
      case AchievementCriteriaType.hackathonsAttended:
        return 'Join any hackathon to earn this';
      case AchievementCriteriaType.startupEventsAttended:
        return '$remaining more startup event${remaining == 1 ? '' : 's'} needed';
    }
  }
}
