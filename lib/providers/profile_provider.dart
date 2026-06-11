import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../models/leaderboard_entry.dart';
import '../models/user_profile.dart';
import '../services/leadership_score_service.dart';
import '../services/mock_data.dart';
import '../services/persistence_service.dart';

/// ProfileProvider — leadership score, achievements, and stats with persistence.
class ProfileProvider extends ChangeNotifier {
  UserProfile? _profile;
  List<Achievement> _achievements = [];
  int _hackathonsAttended = 0;
  int _startupEventsAttended = 0;

  // Achievements that just unlocked this session — consumed by MainShell toast.
  final List<Achievement> _pendingToasts = [];

  UserProfile? get profile => _profile;
  List<Achievement> get achievements => _achievements;
  int get hackathonsAttended => _hackathonsAttended;
  int get startupEventsAttended => _startupEventsAttended;

  int get leadershipScore => _profile?.leadershipScore ?? 0;
  double get leadershipProgress =>
      LeadershipScoreService.progressPercent(leadershipScore);
  String get leadershipLevel =>
      LeadershipScoreService.leadershipLevel(leadershipScore);

  /// Returns any achievements that unlocked since the last call, then clears
  /// the list. Called by MainShell to show unlock toasts.
  List<Achievement> consumeUnlockToasts() {
    final copy = List<Achievement>.from(_pendingToasts);
    _pendingToasts.clear();
    return copy;
  }

  /// Current value for [type] — used by the achievements screen progress bar.
  int criteriaProgress(AchievementCriteriaType type) {
    switch (type) {
      case AchievementCriteriaType.leadershipScore:
        return leadershipScore;
      case AchievementCriteriaType.eventsAttended:
        return _profile?.eventsAttended ?? 0;
      case AchievementCriteriaType.communitiesJoined:
        return _profile?.communitiesJoined ?? 0;
      case AchievementCriteriaType.hackathonsAttended:
        return _hackathonsAttended;
      case AchievementCriteriaType.startupEventsAttended:
        return _startupEventsAttended;
    }
  }

  Future<void> init(UserProfile? authUser) async {
    if (authUser == null) {
      _loadAchievements();
      notifyListeners();
      return;
    }

    _profile = authUser;

    final stats = PersistenceService.profileStats(authUser.id);
    if (stats != null) {
      _profile = _profile!.copyWith(
        leadershipScore: stats['leadershipScore'] as int?,
        eventsAttended: stats['eventsAttended'] as int?,
        communitiesJoined: stats['communitiesJoined'] as int?,
        connections: stats['connections'] as int?,
        participationHistory:
            (stats['participationHistory'] as List<dynamic>?)?.cast<String>(),
        earnedBadgeIds:
            (stats['earnedBadgeIds'] as List<dynamic>?)?.cast<String>(),
      );
      _hackathonsAttended = stats['hackathonsAttended'] as int? ?? 0;
      _startupEventsAttended = stats['startupEventsAttended'] as int? ?? 0;
    }

    _loadAchievements();
    notifyListeners();
  }

  void syncFromAuth(UserProfile user) {
    final stats = _profile;
    _profile = user.copyWith(
      leadershipScore: stats?.leadershipScore ?? user.leadershipScore,
      eventsAttended: stats?.eventsAttended ?? user.eventsAttended,
      communitiesJoined: stats?.communitiesJoined ?? user.communitiesJoined,
      connections: stats?.connections ?? user.connections,
      participationHistory:
          stats?.participationHistory ?? user.participationHistory,
      earnedBadgeIds: stats?.earnedBadgeIds ?? user.earnedBadgeIds,
    );
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? program,
    String? campus,
    String? avatarUrl,
    List<String>? interests,
  }) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(
      name: name,
      program: program,
      campus: campus,
      avatarUrl: avatarUrl,
      interests: interests,
    );
    _persistStats();
    notifyListeners();
  }

  void addLeadershipPoints(int points, {String? activity}) {
    if (_profile == null) return;

    final newScore = (_profile!.leadershipScore + points).clamp(0, 500);
    final history = List<String>.from(_profile!.participationHistory);
    if (activity != null) history.insert(0, activity);

    _profile = _profile!.copyWith(
      leadershipScore: newScore,
      participationHistory: history,
    );

    _checkAchievements();
    _persistStats();
    notifyListeners();
  }

  void incrementEventsAttended() {
    if (_profile == null) return;
    _profile = _profile!.copyWith(eventsAttended: _profile!.eventsAttended + 1);
    _checkAchievements();
    _persistStats();
    notifyListeners();
  }

  void incrementCommunitiesJoined() {
    if (_profile == null) return;
    _profile = _profile!.copyWith(
      communitiesJoined: _profile!.communitiesJoined + 1,
    );
    _checkAchievements();
    _persistStats();
    notifyListeners();
  }

  void incrementHackathonsAttended() {
    _hackathonsAttended++;
    _checkAchievements();
    _persistStats();
    notifyListeners();
  }

  void incrementStartupEventsAttended() {
    _startupEventsAttended++;
    _checkAchievements();
    _persistStats();
    notifyListeners();
  }

  // ── Achievement logic ────────────────────────────────────────────────────

  void _loadAchievements() {
    _achievements = MockData.achievements.map((a) => Achievement(
          id: a.id,
          title: a.title,
          description: a.description,
          icon: a.icon,
          criteriaType: a.criteriaType,
          criteriaValue: a.criteriaValue,
          isEarned: _evaluateCriteria(a),
        )).toList();
  }

  void _checkAchievements() {
    final prevEarnedIds =
        _achievements.where((a) => a.isEarned).map((a) => a.id).toSet();

    _achievements = _achievements.map((a) => Achievement(
          id: a.id,
          title: a.title,
          description: a.description,
          icon: a.icon,
          criteriaType: a.criteriaType,
          criteriaValue: a.criteriaValue,
          isEarned: _evaluateCriteria(a),
        )).toList();

    // Queue toasts for badges that just unlocked
    for (final a in _achievements) {
      if (a.isEarned && !prevEarnedIds.contains(a.id)) {
        _pendingToasts.add(a);
      }
    }
  }

  bool _evaluateCriteria(Achievement a) {
    switch (a.criteriaType) {
      case AchievementCriteriaType.leadershipScore:
        return leadershipScore >= a.criteriaValue;
      case AchievementCriteriaType.eventsAttended:
        return (_profile?.eventsAttended ?? 0) >= a.criteriaValue;
      case AchievementCriteriaType.communitiesJoined:
        return (_profile?.communitiesJoined ?? 0) >= a.criteriaValue;
      case AchievementCriteriaType.hackathonsAttended:
        return _hackathonsAttended >= a.criteriaValue;
      case AchievementCriteriaType.startupEventsAttended:
        return _startupEventsAttended >= a.criteriaValue;
    }
  }

  // ── Leaderboard & metrics ────────────────────────────────────────────────

  List<LeaderboardEntry> get leaderboard {
    // Build peer list — exclude any entry flagged as the current user placeholder.
    final peers = MockData.leaderboard
        .where((e) => !e.isCurrentUser)
        .map((e) => LeaderboardEntry(
              rank: e.rank,
              userId: e.userId,
              name: e.name,
              avatarUrl: e.avatarUrl,
              score: e.score,
              eventsAttended: e.eventsAttended,
            ))
        .toList();

    if (_profile != null) {
      peers.add(LeaderboardEntry(
        rank: 0, // will be overwritten after sort
        userId: _profile!.id,
        name: _profile!.name,
        avatarUrl: _profile!.avatarUrl,
        score: leadershipScore,
        eventsAttended: _profile!.eventsAttended,
        isCurrentUser: true,
      ));
    }

    // Sort descending by score, assign ranks.
    peers.sort((a, b) => b.score.compareTo(a.score));
    return List.generate(peers.length, (i) {
      final e = peers[i];
      return LeaderboardEntry(
        rank: i + 1,
        userId: e.userId,
        name: e.name,
        avatarUrl: e.avatarUrl,
        score: e.score,
        eventsAttended: e.eventsAttended,
        isCurrentUser: e.isCurrentUser,
      );
    });
  }

  Map<String, int> get impactMetrics => {
        'Events Attended': _profile?.eventsAttended ?? 0,
        'Communities Joined': _profile?.communitiesJoined ?? 0,
        'Leadership Score': leadershipScore,
        'Connections': _profile?.connections ?? 0,
      };

  // ── Persistence ───────────────────────────────────────────────────────────

  void _persistStats() {
    if (_profile == null) return;
    PersistenceService.saveProfileStats(_profile!.id, {
      'leadershipScore': _profile!.leadershipScore,
      'eventsAttended': _profile!.eventsAttended,
      'communitiesJoined': _profile!.communitiesJoined,
      'connections': _profile!.connections,
      'participationHistory': _profile!.participationHistory,
      'earnedBadgeIds': _profile!.earnedBadgeIds,
      'hackathonsAttended': _hackathonsAttended,
      'startupEventsAttended': _startupEventsAttended,
    });
  }
}
