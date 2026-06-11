import '../models/event.dart';
import '../models/opportunity_category.dart';
import '../models/user_profile.dart';

/// Opportunity Match Score — recommends events based on interests and history.
///
/// Scoring logic (0–100):
/// - Category matches user interest: +40
/// - Same category as past participation: +30
/// - Featured event bonus: +10
/// - Popularity (participants > 30): +10
/// - Upcoming within 7 days: +10
class RecommendationService {
  RecommendationService._();

  static int calculateMatchScore(EventModel event, UserProfile user) {
    var score = 0;

    final categoryLabel = event.category.label.toLowerCase();
    for (final interest in user.interests) {
      if (interest.toLowerCase().contains(categoryLabel) ||
          categoryLabel.contains(interest.toLowerCase())) {
        score += 40;
        break;
      }
    }

    final participatedCategories = _categoriesFromHistory(
      user.participationHistory,
    );
    if (participatedCategories.contains(event.category)) {
      score += 30;
    }

    if (event.isFeatured) score += 10;
    if (event.participantCount > 30) score += 10;

    final daysUntil = event.date.difference(DateTime.now()).inDays;
    if (daysUntil >= 0 && daysUntil <= 7) score += 10;

    return score.clamp(0, 100);
  }

  static List<EventModel> getRecommended(
    List<EventModel> events,
    UserProfile user, {
    int limit = 5,
  }) {
    final scored = events.map((e) {
      final copy = e.copyWith(matchScore: calculateMatchScore(e, user));
      return copy;
    }).toList();

    scored.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    return scored.take(limit).toList();
  }

  static Set<OpportunityCategory> _categoriesFromHistory(
    List<String> history,
  ) {
    final categories = <OpportunityCategory>{};
    for (final item in history) {
      for (final cat in OpportunityCategory.values) {
        if (item.toLowerCase().contains(cat.label.toLowerCase())) {
          categories.add(cat);
        }
      }
    }
    return categories;
  }
}
