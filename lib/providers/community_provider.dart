import 'package:flutter/material.dart';
import '../models/community.dart';
import '../services/mock_data.dart';
import '../services/persistence_service.dart';

/// CommunityProvider — join/leave hub state with SharedPreferences persistence.
class CommunityProvider extends ChangeNotifier {
  List<CommunityModel> _communities = [];
  final Set<String> _joinedIds = {};
  String _activeTab = 'All Clubs';
  bool _isLoading = false;
  String? _userId;

  List<CommunityModel> get communities => _communities;
  String get activeTab => _activeTab;
  bool get isLoading => _isLoading;

  List<CommunityModel> get myCommunities =>
      _communities.where((c) => c.isJoined).toList();

  Future<void> init({String? userId}) async {
    _isLoading = true;
    _userId = userId;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _communities = MockData.communities.map((c) => c.copyWith()).toList();

    // Restore joined IDs and apply them to community objects
    if (userId != null) {
      _joinedIds
        ..clear()
        ..addAll(PersistenceService.joinedCommunityIds(userId));
    }

    for (final community in _communities) {
      community.isJoined = _joinedIds.contains(community.id);
    }

    _isLoading = false;
    notifyListeners();
  }

  void setActiveTab(String tab) {
    _activeTab = tab;
    notifyListeners();
  }

  List<CommunityModel> filteredCommunities() {
    if (_activeTab == 'My Clubs') {
      return _communities.where((c) => c.isJoined).toList();
    }
    return _communities;
  }

  CommunityModel? getById(String id) {
    try {
      return _communities.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  bool isJoined(String communityId) => _joinedIds.contains(communityId);

  bool joinCommunity(String communityId) {
    if (_joinedIds.contains(communityId)) return false;

    _joinedIds.add(communityId);
    final community = getById(communityId);
    if (community != null) {
      community.isJoined = true;
      community.memberCount++;
    }

    _persistJoined();
    notifyListeners();
    return true;
  }

  bool leaveCommunity(String communityId) {
    if (!_joinedIds.contains(communityId)) return false;

    _joinedIds.remove(communityId);
    final community = getById(communityId);
    if (community != null) {
      community.isJoined = false;
      community.memberCount = (community.memberCount - 1).clamp(0, 9999);
    }

    _persistJoined();
    notifyListeners();
    return true;
  }

  int get joinedCount => _joinedIds.length;

  void _persistJoined() {
    if (_userId == null) return;
    PersistenceService.saveJoinedCommunityIds(_userId!, _joinedIds);
  }
}
