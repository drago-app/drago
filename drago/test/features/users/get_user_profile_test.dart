import 'package:dartz/dartz.dart';
import 'package:drago/features/user/get_user_profile.dart';
import 'package:drago/reddit_service.dart';
// import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  RedditService _reddit;
  GetUserProfile getUserProfile;

  setUp(() async {
    _reddit = RedditService();
    await _reddit.initializeWithoutAuth();
    getUserProfile = GetUserProfile(reddit: _reddit);
  });

  test(
    'it should get a reddit user',
    () async {
      final String userName = 'antioxidantal';
      final params = GetUserProfileParams(userName: userName);

      final result = await getUserProfile(params);

      assert(result.isRight());
    },
  );
}
