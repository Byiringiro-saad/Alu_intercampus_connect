import '../utils/constants.dart';

/// Account roles on ALU Connect — only non-student roles may publish opportunities.
enum UserRole {
  student('Student', 'Browse and participate in campus activities'),
  clubLeader('Club Leader', 'Post events and announcements for your club'),
  eventOrganizer(
    'Event Organizer',
    'Publish workshops, hackathons, and campus events',
  ),
  entrepreneur(
    'Entrepreneur',
    'Share startup initiatives and pitch opportunities',
  ),
  communityLeader(
    'Community Leader',
    'Post community announcements and group activities',
  ),
  academicTeam(
    'Academic Team',
    'Share internships, programs, and academic opportunities',
  );

  const UserRole(this.label, this.description);
  final String label;
  final String description;

  bool get canPostOpportunities => this != UserRole.student;

  static UserRole fromId(String id) {
    if (id == 'organizer') {
      return UserRole.eventOrganizer;
    }
    return UserRole.values.firstWhere(
      (role) => role.name == id,
      orElse: () => UserRole.student,
    );
  }
}

class UserProfile {
  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.program,
    required this.campus,
    required this.avatarUrl,
    this.role = UserRole.student,
    this.leadershipScore = 0,
    this.eventsAttended = 0,
    this.communitiesJoined = 0,
    this.connections = 0,
    this.interests = const [],
    this.participationHistory = const [],
    this.earnedBadgeIds = const [],
  });

  final String id;
  final String name;
  final String email;
  final String program;
  final String campus;
  final String avatarUrl;
  final UserRole role;
  int leadershipScore;
  int eventsAttended;
  int communitiesJoined;
  int connections;
  final List<String> interests;
  final List<String> participationHistory;
  final List<String> earnedBadgeIds;

  bool get isDemoAccount =>
      email.trim().toLowerCase() == AppConstants.demoEmail.toLowerCase();

  /// Demo evaluator can use every feature; others follow role rules.
  bool get canPostOpportunities =>
      isDemoAccount || role.canPostOpportunities;

  String get roleLabel =>
      isDemoAccount ? 'Demo Evaluator' : role.label;

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? program,
    String? campus,
    String? avatarUrl,
    UserRole? role,
    int? leadershipScore,
    int? eventsAttended,
    int? communitiesJoined,
    int? connections,
    List<String>? interests,
    List<String>? participationHistory,
    List<String>? earnedBadgeIds,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      program: program ?? this.program,
      campus: campus ?? this.campus,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      leadershipScore: leadershipScore ?? this.leadershipScore,
      eventsAttended: eventsAttended ?? this.eventsAttended,
      communitiesJoined: communitiesJoined ?? this.communitiesJoined,
      connections: connections ?? this.connections,
      interests: interests ?? this.interests,
      participationHistory: participationHistory ?? this.participationHistory,
      earnedBadgeIds: earnedBadgeIds ?? this.earnedBadgeIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'program': program,
        'campus': campus,
        'avatarUrl': avatarUrl,
        'role': role.name,
        'leadershipScore': leadershipScore,
        'eventsAttended': eventsAttended,
        'communitiesJoined': communitiesJoined,
        'connections': connections,
        'interests': interests,
        'participationHistory': participationHistory,
        'earnedBadgeIds': earnedBadgeIds,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        program: json['program'] as String,
        campus: json['campus'] as String,
        avatarUrl: json['avatarUrl'] as String,
        role: UserRole.fromId(json['role'] as String? ?? 'student'),
        leadershipScore: json['leadershipScore'] as int? ?? 0,
        eventsAttended: json['eventsAttended'] as int? ?? 0,
        communitiesJoined: json['communitiesJoined'] as int? ?? 0,
        connections: json['connections'] as int? ?? 0,
        interests: (json['interests'] as List<dynamic>?)?.cast<String>() ?? [],
        participationHistory:
            (json['participationHistory'] as List<dynamic>?)?.cast<String>() ??
                [],
        earnedBadgeIds:
            (json['earnedBadgeIds'] as List<dynamic>?)?.cast<String>() ?? [],
      );
}
