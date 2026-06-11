class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.name,
    required this.avatarUrl,
    required this.score,
    required this.eventsAttended,
    this.isCurrentUser = false,
  });

  final int rank;
  final String userId;
  final String name;
  final String avatarUrl;
  final int score;
  final int eventsAttended;
  final bool isCurrentUser;
}
