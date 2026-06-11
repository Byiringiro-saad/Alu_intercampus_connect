import '../models/achievement.dart';
// AchievementCriteriaType is defined in achievement.dart
import '../utils/constants.dart';
import '../models/community.dart';
import '../models/event.dart';
import '../models/leaderboard_entry.dart';
import '../models/notification_item.dart';
import '../models/opportunity_category.dart';
import '../models/user_profile.dart';

/// Local mock data — all app content is seeded from here (no backend/API).
class MockData {
  MockData._();

  static const demoEmail = AppConstants.demoEmail;
  static const demoPassword = 'alu2026';

  static const defaultAvatarUrl =
      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200';

  static final UserProfile demoUser = UserProfile(
    id: 'user-1',
    name: 'Demo User',
    email: demoEmail,
    program: 'BSc Software Engineering',
    campus: 'Rwanda Campus',
    avatarUrl: '',
    role: UserRole.eventOrganizer,
    leadershipScore: 185,
    eventsAttended: 23,
    communitiesJoined: 5,
    connections: 87,
    interests: [
      'Entrepreneurship',
      'AI & Data Science',
      'Leadership',
      'Startups',
    ],
    participationHistory: [
      'Attended AI for Social Impact Workshop',
      'Joined Entrepreneurship Hub',
      'Participated in Sustainable Solutions Hackathon',
      'Leadership Summit 2025',
    ],
    earnedBadgeIds: ['community_builder', 'event_champion'],
  );

  static final List<String> avatarPool = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100',
  ];

  static List<EventModel> get events => [
        EventModel(
          id: 'evt-1',
          title: 'ALU Entrepreneurship Pitch Night',
          description:
              'Watch student founders pitch innovative startups to ALU mentors and investors. Network with entrepreneurs and discover the next generation of African leaders.',
          organizer: 'Entrepreneurship Club',
          organizerId: 'org-1',
          date: DateTime.now().add(const Duration(days: 3)),
          time: '6:00 PM',
          location: 'Rwanda Campus - Innovation Hub',
          category: OpportunityCategory.startups,
          imageUrl: '',
          maxParticipants: 120,
          participantCount: 89,
          interestedCount: 34,
          attendeeAvatars: avatarPool.take(4).toList(),
          communityId: 'comm-1',
          isFeatured: true,
        ),
        EventModel(
          id: 'evt-2',
          title: 'AI for Social Impact Workshop',
          description:
              'Learn how to apply machine learning to solve real community challenges. Hands-on sessions with ALU faculty and industry mentors.',
          organizer: 'AI & Data Science Hub',
          organizerId: 'org-2',
          date: DateTime.now().add(const Duration(days: 7)),
          time: '2:00 PM',
          location: 'Mauritius Campus',
          category: OpportunityCategory.workshops,
          imageUrl: '',
          maxParticipants: 60,
          participantCount: 48,
          interestedCount: 12,
          attendeeAvatars: avatarPool.take(5).toList(),
          communityId: 'comm-4',
        ),
        EventModel(
          id: 'evt-3',
          title: 'Sustainable Solutions Challenge',
          description:
              '48-hour hackathon focused on climate action and sustainable development goals. Prizes for top teams.',
          organizer: 'Climate Action Hub',
          organizerId: 'org-3',
          date: DateTime.now().add(const Duration(days: 14)),
          time: '9:00 AM',
          location: 'Rwanda Campus',
          category: OpportunityCategory.hackathons,
          imageUrl: '',
          maxParticipants: 80,
          participantCount: 56,
          interestedCount: 22,
          attendeeAvatars: avatarPool.take(3).toList(),
          communityId: 'comm-3',
        ),
        EventModel(
          id: 'evt-4',
          title: 'Campus Ambassador Program',
          description:
              'Represent ALU at partner institutions. Build leadership skills while expanding the ALU network across Africa.',
          organizer: 'Student Affairs',
          organizerId: 'org-4',
          date: DateTime.now().add(const Duration(days: 21)),
          time: '11:00 AM',
          location: 'Online',
          category: OpportunityCategory.leadership,
          imageUrl: '',
          maxParticipants: 30,
          participantCount: 18,
          interestedCount: 45,
          attendeeAvatars: avatarPool.take(2).toList(),
        ),
        EventModel(
          id: 'evt-5',
          title: 'Tech Startup Internship Fair',
          description:
              'Connect with 15+ African tech startups offering internships for ALU students.',
          organizer: 'Career Services',
          organizerId: 'org-5',
          date: DateTime.now().add(const Duration(days: 10)),
          time: '10:00 AM',
          location: 'Rwanda Campus',
          category: OpportunityCategory.internships,
          imageUrl: '',
          maxParticipants: 200,
          participantCount: 134,
          interestedCount: 67,
          attendeeAvatars: avatarPool,
        ),
        EventModel(
          id: 'evt-6',
          title: 'Women in Leadership Summit',
          description:
              'Inspiring talks, panel discussions, and mentorship sessions for aspiring women leaders at ALU.',
          organizer: 'Women in Leadership Hub',
          organizerId: 'org-6',
          date: DateTime.now().add(const Duration(days: 5)),
          time: '3:00 PM',
          location: 'Mauritius Campus',
          category: OpportunityCategory.leadership,
          imageUrl: '',
          maxParticipants: 100,
          participantCount: 72,
          interestedCount: 28,
          attendeeAvatars: avatarPool.take(4).toList(),
          communityId: 'comm-5',
        ),
        EventModel(
          id: 'evt-7',
          title: 'Debate Society Championship',
          description:
              'Inter-campus debate competition on African policy and governance topics.',
          organizer: 'Debate Society',
          organizerId: 'org-7',
          date: DateTime.now().add(const Duration(days: 12)),
          time: '4:00 PM',
          location: 'Rwanda Campus',
          category: OpportunityCategory.competitions,
          imageUrl: '',
          maxParticipants: 50,
          participantCount: 32,
          interestedCount: 15,
          attendeeAvatars: avatarPool.take(3).toList(),
          communityId: 'comm-6',
        ),
        EventModel(
          id: 'evt-8',
          title: 'Networking Mixer: ALU x Industry',
          description:
              'Casual networking evening with alumni and industry professionals.',
          organizer: 'Alumni Network',
          organizerId: 'org-8',
          date: DateTime.now().add(const Duration(days: 2)),
          time: '7:00 PM',
          location: 'Rwanda Campus',
          category: OpportunityCategory.networking,
          imageUrl: '',
          maxParticipants: 80,
          participantCount: 45,
          interestedCount: 20,
          attendeeAvatars: avatarPool.take(4).toList(),
        ),
      ];

  static List<CommunityModel> get communities => [
        CommunityModel(
          id: 'comm-1',
          name: 'Entrepreneurship',
          description:
              'Build, launch, and scale ventures with fellow ALU entrepreneurs. Weekly pitch sessions and mentor office hours.',
          imageUrl: '',
          category: OpportunityCategory.startups,
          memberCount: 342,
          upcomingActivityIds: ['evt-1'],
          memberAvatars: avatarPool,
        ),
        CommunityModel(
          id: 'comm-2',
          name: 'Software Engineering',
          description:
              'Code reviews, hack nights, and tech talks for ALU developers. From mobile to cloud.',
          imageUrl: '',
          category: OpportunityCategory.academics,
          memberCount: 278,
          upcomingActivityIds: [],
          memberAvatars: avatarPool.take(4).toList(),
        ),
        CommunityModel(
          id: 'comm-3',
          name: 'Climate Action',
          description:
              'Driving sustainability initiatives across ALU campuses. Projects, advocacy, and green tech.',
          imageUrl: '',
          category: OpportunityCategory.leadership,
          memberCount: 156,
          upcomingActivityIds: ['evt-3'],
          memberAvatars: avatarPool.take(3).toList(),
        ),
        CommunityModel(
          id: 'comm-4',
          name: 'AI & Data Science',
          description:
              'Explore machine learning, data analytics, and AI ethics with peers and faculty mentors.',
          imageUrl: '',
          category: OpportunityCategory.workshops,
          memberCount: 198,
          upcomingActivityIds: ['evt-2'],
          memberAvatars: avatarPool.take(5).toList(),
        ),
        CommunityModel(
          id: 'comm-5',
          name: 'Women in Leadership',
          description:
              'Empowering women students to lead with confidence. Mentorship circles and leadership workshops.',
          imageUrl: '',
          category: OpportunityCategory.leadership,
          memberCount: 215,
          upcomingActivityIds: ['evt-6'],
          memberAvatars: avatarPool.take(4).toList(),
        ),
        CommunityModel(
          id: 'comm-6',
          name: 'Debate Society',
          description:
              'Sharpen your argumentation and public speaking. Weekly debates and inter-campus competitions.',
          imageUrl: '',
          category: OpportunityCategory.competitions,
          memberCount: 124,
          upcomingActivityIds: ['evt-7'],
          memberAvatars: avatarPool.take(3).toList(),
        ),
      ];

  static List<NotificationItem> get notifications => [
        NotificationItem(
          id: 'notif-1',
          title: 'Event Reminder',
          body: 'AI for Social Impact Workshop starts in 2 days',
          type: NotificationType.eventReminder,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          relatedId: 'evt-2',
        ),
        NotificationItem(
          id: 'notif-2',
          title: 'RSVP Confirmed',
          body: 'You are going to ALU Entrepreneurship Pitch Night',
          type: NotificationType.rsvpConfirmation,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          relatedId: 'evt-1',
        ),
        NotificationItem(
          id: 'notif-3',
          title: 'Community Invitation',
          body: 'You\'ve been invited to join Climate Action Hub',
          type: NotificationType.communityInvitation,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          relatedId: 'comm-3',
        ),
        NotificationItem(
          id: 'notif-4',
          title: 'New Opportunity',
          body: 'Tech Startup Internship Fair just posted',
          type: NotificationType.newOpportunity,
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
          relatedId: 'evt-5',
        ),
        NotificationItem(
          id: 'notif-5',
          title: 'Achievement Unlocked',
          body: 'You earned the Event Champion badge!',
          type: NotificationType.achievement,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

  static List<Achievement> get achievements => [
        const Achievement(
          id: 'community_builder',
          title: 'Community Builder',
          description: 'Joined 3 or more ALU community hubs',
          icon: '🏗️',
          criteriaType: AchievementCriteriaType.communitiesJoined,
          criteriaValue: 3,
        ),
        const Achievement(
          id: 'startup_explorer',
          title: 'Startup Explorer',
          description: 'Attended 2 startup-related events',
          icon: '🚀',
          criteriaType: AchievementCriteriaType.startupEventsAttended,
          criteriaValue: 2,
        ),
        const Achievement(
          id: 'event_champion',
          title: 'Event Champion',
          description: 'RSVP\'d to 10 or more events',
          icon: '🏆',
          criteriaType: AchievementCriteriaType.eventsAttended,
          criteriaValue: 10,
        ),
        const Achievement(
          id: 'leadership_ambassador',
          title: 'Leadership Ambassador',
          description: 'Reached 300+ leadership score',
          icon: '⭐',
          criteriaType: AchievementCriteriaType.leadershipScore,
          criteriaValue: 300,
        ),
        const Achievement(
          id: 'hackathon_hero',
          title: 'Hackathon Hero',
          description: 'Participated in a campus hackathon',
          icon: '💡',
          criteriaType: AchievementCriteriaType.hackathonsAttended,
          criteriaValue: 1,
        ),
      ];

  static List<LeaderboardEntry> get leaderboard => [
        const LeaderboardEntry(
          rank: 1,
          userId: 'user-10',
          name: 'Kwame Asante',
          avatarUrl:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
          score: 412,
          eventsAttended: 34,
        ),
        const LeaderboardEntry(
          rank: 2,
          userId: 'user-11',
          name: 'Fatima Hassan',
          avatarUrl:
              'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=100',
          score: 378,
          eventsAttended: 29,
        ),
        const LeaderboardEntry(
          rank: 4,
          userId: 'user-12',
          name: 'David Okafor',
          avatarUrl:
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
          score: 167,
          eventsAttended: 19,
        ),
        const LeaderboardEntry(
          rank: 5,
          userId: 'user-13',
          name: 'Amara Diallo',
          avatarUrl:
              'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=100',
          score: 142,
          eventsAttended: 16,
        ),
      ];
}
