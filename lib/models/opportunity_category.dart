/// Categories used across events, opportunities, and filter chips.
enum OpportunityCategory {
  events('Events', 'events'),
  internships('Internships', 'internships'),
  workshops('Workshops', 'workshops'),
  hackathons('Hackathons', 'hackathons'),
  leadership('Leadership', 'leadership'),
  startups('Startups', 'startups'),
  competitions('Competitions', 'competitions'),
  networking('Networking', 'networking'),
  clubs('Clubs', 'clubs'),
  academics('Academics', 'academics'),
  announcements('Announcements', 'announcements');

  const OpportunityCategory(this.label, this.id);
  final String label;
  final String id;

  String get description {
    switch (this) {
      case OpportunityCategory.events:
        return 'Campus events and gatherings';
      case OpportunityCategory.hackathons:
        return 'Innovation and coding challenges';
      case OpportunityCategory.workshops:
        return 'Skills-building sessions';
      case OpportunityCategory.startups:
        return 'Startup initiatives and pitch nights';
      case OpportunityCategory.leadership:
        return 'Leadership programs and summits';
      case OpportunityCategory.internships:
        return 'Internship and career openings';
      case OpportunityCategory.announcements:
        return 'Community announcements and updates';
      case OpportunityCategory.competitions:
        return 'Competitions and challenges';
      case OpportunityCategory.networking:
        return 'Networking sessions';
      case OpportunityCategory.clubs:
        return 'Club activities';
      case OpportunityCategory.academics:
        return 'Academic programs and teams';
    }
  }

  /// Categories authorized users can publish when creating opportunities.
  static List<OpportunityCategory> get publishable => [
        events,
        hackathons,
        workshops,
        startups,
        leadership,
        internships,
        announcements,
        competitions,
        networking,
      ];

  static OpportunityCategory? fromId(String id) {
    for (final c in OpportunityCategory.values) {
      if (c.id == id) return c;
    }
    return null;
  }
}
