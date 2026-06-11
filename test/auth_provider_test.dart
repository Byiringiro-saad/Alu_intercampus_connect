import 'package:flutter_test/flutter_test.dart';
import 'package:aluintercampusconnect/providers/auth_provider.dart';
import 'package:aluintercampusconnect/services/mock_data.dart';

void main() {
  test('demo account login succeeds with README credentials', () async {
    final auth = AuthProvider();

    final success = await auth.login(
      MockData.demoEmail,
      MockData.demoPassword,
    );

    expect(success, isTrue);
    expect(auth.isLoggedIn, isTrue);
    expect(auth.user?.email.toLowerCase(), MockData.demoEmail.toLowerCase());
    expect(auth.user?.name, 'Demo User');
    expect(auth.user?.avatarUrl, isEmpty);
    expect(auth.user?.isDemoAccount, isTrue);
    expect(auth.user?.canPostOpportunities, isTrue);
    expect(auth.error, isNull);
  });

  test('demo login fails with wrong password', () async {
    final auth = AuthProvider();

    final success = await auth.login(MockData.demoEmail, 'wrong-password');

    expect(success, isFalse);
    expect(auth.isLoggedIn, isFalse);
    expect(auth.error, isNotNull);
  });
}
