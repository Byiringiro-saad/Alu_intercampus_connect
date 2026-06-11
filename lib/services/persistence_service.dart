import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Typed wrapper around SharedPreferences.
/// Call [PersistenceService.init()] once in main() before runApp.
class PersistenceService {
  PersistenceService._();

  static late SharedPreferences _p;

  static Future<void> init() async {
    _p = await SharedPreferences.getInstance();
  }

  // ── Theme ─────────────────────────────────────────────────────────────────
  static const _kThemeDark = 'theme_dark_mode';

  static bool get isDarkMode => _p.getBool(_kThemeDark) ?? false;

  static void saveTheme(bool isDark) => _p.setBool(_kThemeDark, isDark);

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const _kLoggedInEmail = 'auth_logged_in_email';
  static const _kAccountsJson = 'auth_accounts_v1';
  static const _kOnboardingDone = 'auth_onboarding_done';

  static String? get loggedInEmail => _p.getString(_kLoggedInEmail);

  static void saveLoggedInEmail(String? email) {
    if (email == null) {
      _p.remove(_kLoggedInEmail);
    } else {
      _p.setString(_kLoggedInEmail, email);
    }
  }

  static bool get onboardingDone => _p.getBool(_kOnboardingDone) ?? false;

  static void saveOnboardingDone(bool done) =>
      _p.setBool(_kOnboardingDone, done);

  static Map<String, dynamic>? get accountsJson {
    final s = _p.getString(_kAccountsJson);
    if (s == null || s.isEmpty) return null;
    try {
      return jsonDecode(s) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static void saveAccounts(Map<String, dynamic> accounts) =>
      _p.setString(_kAccountsJson, jsonEncode(accounts));

  // ── Events (per user) ─────────────────────────────────────────────────────
  static String _savedIdsKey(String uid) => 'events_saved_$uid';
  static String _rsvpKey(String uid) => 'events_rsvp_$uid';
  static const _kCreatedEvents = 'events_created_v1';

  static List<String> savedEventIds(String uid) =>
      _p.getStringList(_savedIdsKey(uid)) ?? [];

  static void saveSavedEventIds(String uid, Set<String> ids) =>
      _p.setStringList(_savedIdsKey(uid), ids.toList());

  static Map<String, String> rsvpStatuses(String uid) {
    final s = _p.getString(_rsvpKey(uid));
    if (s == null || s.isEmpty) return {};
    try {
      return (jsonDecode(s) as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, v as String),
      );
    } catch (_) {
      return {};
    }
  }

  static void saveRsvpStatuses(String uid, Map<String, String> statuses) =>
      _p.setString(_rsvpKey(uid), jsonEncode(statuses));

  static List<Map<String, dynamic>> createdEvents() {
    final s = _p.getString(_kCreatedEvents);
    if (s == null || s.isEmpty) return [];
    try {
      return (jsonDecode(s) as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  static void saveCreatedEvents(List<Map<String, dynamic>> events) =>
      _p.setString(_kCreatedEvents, jsonEncode(events));

  // ── Communities (per user) ────────────────────────────────────────────────
  static String _joinedIdsKey(String uid) => 'communities_joined_$uid';

  static List<String> joinedCommunityIds(String uid) =>
      _p.getStringList(_joinedIdsKey(uid)) ?? [];

  static void saveJoinedCommunityIds(String uid, Set<String> ids) =>
      _p.setStringList(_joinedIdsKey(uid), ids.toList());

  // ── Profile stats (per user) ──────────────────────────────────────────────
  static String _profileKey(String uid) => 'profile_stats_$uid';

  static Map<String, dynamic>? profileStats(String uid) {
    final s = _p.getString(_profileKey(uid));
    if (s == null || s.isEmpty) return null;
    try {
      return jsonDecode(s) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static void saveProfileStats(String uid, Map<String, dynamic> stats) =>
      _p.setString(_profileKey(uid), jsonEncode(stats));
}
