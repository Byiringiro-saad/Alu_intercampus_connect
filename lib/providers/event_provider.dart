import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/user_profile.dart';
import '../services/mock_data.dart';
import '../services/persistence_service.dart';
import '../services/recommendation_service.dart';

/// EventProvider — RSVP, save, filter, and create flows with SharedPreferences persistence.
class EventProvider extends ChangeNotifier {
  List<EventModel> _events = [];
  final Set<String> _savedIds = {};
  final Map<String, String> _rsvpStatuses = {};
  String _searchQuery = '';
  String _activeFilter = 'All';
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _userId;

  List<EventModel> get events => _events;
  Set<String> get savedIds => _savedIds;
  String get searchQuery => _searchQuery;
  String get activeFilter => _activeFilter;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  Future<void> init({String? userId}) async {
    _isLoading = true;
    _userId = userId;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    // Load mock events
    _events = [...MockData.events];

    // Prepend any user-created events (global, visible to all)
    final createdRaw = PersistenceService.createdEvents();
    for (final raw in createdRaw.reversed) {
      try {
        final event = EventModel.fromJson(raw);
        if (!_events.any((e) => e.id == event.id)) {
          _events.insert(0, event);
        }
      } catch (_) {}
    }

    // Restore per-user state
    if (userId != null) {
      _savedIds
        ..clear()
        ..addAll(PersistenceService.savedEventIds(userId));

      _rsvpStatuses
        ..clear()
        ..addAll(PersistenceService.rsvpStatuses(userId));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isRefreshing = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _isRefreshing = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  List<EventModel> filteredEvents({UserProfile? user}) {
    var result = List<EventModel>.from(_events);

    if (_activeFilter != 'All') {
      result = result
          .where(
            (e) =>
                e.category.label.toLowerCase() == _activeFilter.toLowerCase() ||
                e.category.label == _activeFilter,
          )
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where(
            (e) =>
                e.title.toLowerCase().contains(q) ||
                e.organizer.toLowerCase().contains(q) ||
                e.category.label.toLowerCase().contains(q) ||
                e.location.toLowerCase().contains(q),
          )
          .toList();
    }

    if (user != null) {
      result = result
          .map(
            (e) => e.copyWith(
              matchScore: RecommendationService.calculateMatchScore(e, user),
            ),
          )
          .toList();
    }

    return result;
  }

  List<EventModel> recommendedEvents(UserProfile user) =>
      RecommendationService.getRecommended(_events, user);

  EventModel? getById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<EventModel> savedEvents() =>
      _events.where((e) => _savedIds.contains(e.id)).toList();

  List<EventModel> rsvpEvents(String status) =>
      _events.where((e) => _rsvpStatuses[e.id] == status).toList();

  bool isSaved(String eventId) => _savedIds.contains(eventId);

  String rsvpStatus(String eventId) => _rsvpStatuses[eventId] ?? 'none';

  bool isGoing(String eventId) => _rsvpStatuses[eventId] == 'going';
  bool isInterested(String eventId) => _rsvpStatuses[eventId] == 'interested';

  void toggleSave(String eventId) {
    if (_savedIds.contains(eventId)) {
      _savedIds.remove(eventId);
    } else {
      _savedIds.add(eventId);
    }
    _persistSaved();
    notifyListeners();
  }

  String rsvpEvent(String eventId, {bool interested = false}) {
    final status = interested ? 'interested' : 'going';
    final previous = _rsvpStatuses[eventId];

    if (previous == status) return 'already';

    _rsvpStatuses[eventId] = status;

    final event = getById(eventId);
    if (event != null) {
      if (status == 'going') {
        if (previous == 'interested') event.interestedCount--;
        event.participantCount++;
      } else {
        if (previous == 'going') event.participantCount--;
        event.interestedCount++;
      }
    }

    _persistRsvp();
    notifyListeners();
    return status;
  }

  void cancelRsvp(String eventId) {
    final previous = _rsvpStatuses[eventId];
    if (previous == null) return;

    _rsvpStatuses.remove(eventId);
    final event = getById(eventId);
    if (event != null) {
      if (previous == 'going') {
        event.participantCount = (event.participantCount - 1).clamp(0, 999);
      } else if (previous == 'interested') {
        event.interestedCount = (event.interestedCount - 1).clamp(0, 999);
      }
    }

    _persistRsvp();
    notifyListeners();
  }

  void addCreatedEvent(EventModel event) {
    _events.insert(0, event);

    // Persist the created event globally
    final current = PersistenceService.createdEvents();
    current.add(event.toJson());
    PersistenceService.saveCreatedEvents(current);

    notifyListeners();
  }

  List<EventModel> eventsForCommunity(String communityId) =>
      _events.where((e) => e.communityId == communityId).toList();

  void _persistSaved() {
    if (_userId == null) return;
    PersistenceService.saveSavedEventIds(_userId!, _savedIds);
  }

  void _persistRsvp() {
    if (_userId == null) return;
    PersistenceService.saveRsvpStatuses(_userId!, _rsvpStatuses);
  }
}
