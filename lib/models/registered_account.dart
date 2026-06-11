import 'user_profile.dart';

/// In-memory account record — persisted via SharedPreferences.
class RegisteredAccount {
  RegisteredAccount({
    required this.password,
    required this.profile,
  });

  final String password;
  UserProfile profile;

  Map<String, dynamic> toJson() => {
        'password': password,
        'profile': profile.toJson(),
      };

  factory RegisteredAccount.fromJson(Map<String, dynamic> json) =>
      RegisteredAccount(
        password: json['password'] as String,
        profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      );
}
