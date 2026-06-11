import 'package:flutter/material.dart';
import '../models/registered_account.dart';
import '../models/user_profile.dart';
import '../services/mock_data.dart';
import '../services/persistence_service.dart';

/// Auth state — account registry persisted via SharedPreferences.
class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _load();
  }

  final Map<String, RegisteredAccount> _accounts = {};

  UserProfile? _user;
  bool _isLoading = false;
  String? _error;
  bool _onboardingComplete = false;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get onboardingComplete => _onboardingComplete;

  int get registeredUserCount => _accounts.length;

  void _load() {
    // Restore onboarding flag
    _onboardingComplete = PersistenceService.onboardingDone;

    // Restore account registry
    final saved = PersistenceService.accountsJson;
    if (saved != null && saved.isNotEmpty) {
      for (final entry in saved.entries) {
        try {
          _accounts[entry.key] =
              RegisteredAccount.fromJson(entry.value as Map<String, dynamic>);
        } catch (_) {}
      }
    }

    // Always ensure the demo account exists (seed if missing)
    _seedDemoAccountIfMissing();

    // Restore logged-in session
    final email = PersistenceService.loggedInEmail;
    if (email != null && _accounts.containsKey(email)) {
      _user = _accounts[email]!.profile;
    }
  }

  void _seedDemoAccountIfMissing() {
    final email = MockData.demoEmail.trim().toLowerCase();
    if (_accounts.containsKey(email)) return;

    _accounts[email] = RegisteredAccount(
      password: MockData.demoPassword,
      profile: MockData.demoUser.copyWith(email: email),
    );
  }

  void _persistAccounts() {
    final map = <String, dynamic>{};
    for (final entry in _accounts.entries) {
      map[entry.key] = entry.value.toJson();
    }
    PersistenceService.saveAccounts(map);
  }

  bool isRegisteredEmail(String email) =>
      _accounts.containsKey(email.trim().toLowerCase());

  bool isRegisteredUser(UserProfile? profile) {
    if (profile == null) return false;
    return _accounts.containsKey(profile.email.toLowerCase());
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    PersistenceService.saveOnboardingDone(true);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _seedDemoAccountIfMissing();

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();
    final account = _accounts[normalizedEmail];
    if (account != null && account.password == normalizedPassword) {
      _user = account.profile;
      _isLoading = false;
      PersistenceService.saveLoggedInEmail(normalizedEmail);
      _persistAccounts();
      notifyListeners();
      return true;
    }

    _error = 'Invalid email or password.';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String program,
    required String campus,
    UserRole role = UserRole.student,
    List<String> interests = const [],
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) {
      _error = 'An account with this email already exists. Please log in.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final profile = UserProfile(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim(),
      program: program.trim(),
      campus: campus,
      avatarUrl: '',
      role: role,
      interests: interests,
    );

    _accounts[normalizedEmail] =
        RegisteredAccount(password: password, profile: profile);
    _user = profile;

    _isLoading = false;
    PersistenceService.saveLoggedInEmail(normalizedEmail);
    _persistAccounts();
    notifyListeners();
    return true;
  }

  /// Updates the logged-in user's profile across session and account registry.
  bool updateCurrentUserProfile({
    String? name,
    String? program,
    String? campus,
    String? avatarUrl,
    List<String>? interests,
  }) {
    if (_user == null) return false;

    final updated = _user!.copyWith(
      name: name,
      program: program,
      campus: campus,
      avatarUrl: avatarUrl,
      interests: interests,
    );

    _user = updated;
    final account = _accounts[updated.email.toLowerCase()];
    if (account != null) {
      account.profile = updated;
    }

    _persistAccounts();
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    PersistenceService.saveLoggedInEmail(null);
    notifyListeners();
  }

  List<UserProfile> get allRegisteredUsers =>
      _accounts.values.map((a) => a.profile).toList();

  List<UserProfile> otherRegisteredUsers(String currentUserId) =>
      allRegisteredUsers.where((u) => u.id != currentUserId).toList();

  UserProfile? getUserById(String userId) {
    for (final account in _accounts.values) {
      if (account.profile.id == userId) return account.profile;
    }
    return null;
  }
}
