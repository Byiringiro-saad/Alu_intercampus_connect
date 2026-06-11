import 'package:flutter_test/flutter_test.dart';
import 'package:aluintercampusconnect/utils/constants.dart';
import 'package:aluintercampusconnect/services/leadership_score_service.dart';

void main() {
  test('App constants are defined', () {
    expect(AppConstants.appName, 'ALU Connect');
    expect(AppConstants.tagline, 'Discover. Connect. Lead.');
  });

  test('Leadership score calculation', () {
    final score = LeadershipScoreService.calculateTotal(
      eventsAttended: 5,
      communitiesJoined: 2,
      hackathonsAttended: 1,
      workshopsAttended: 2,
      leadershipPrograms: 1,
    );
    expect(score, greaterThan(0));
    expect(score, lessThanOrEqualTo(500));
  });
}
