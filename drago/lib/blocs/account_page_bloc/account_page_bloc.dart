import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drago/features/user/get_user_profile.dart';
import 'package:flutter/foundation.dart';
import './account_page.dart';

class AccountPageBloc extends Bloc<AccountPageEvent, AccountPageState> {
  final GetUserProfile getUserProfile;
  final String userName;
  AccountPageBloc({@required this.getUserProfile, @required this.userName})
      : assert(getUserProfile != null),
        assert(userName != null),
        assert(userName != '');

  @override
  get initialState => AccountPageInitial(name: userName);

  @override
  Stream<AccountPageState> mapEventToState(AccountPageEvent event) async* {
    if (event is LoadUser) yield* _mapLoadUserToState(event);
  }

  Stream<AccountPageState> _mapLoadUserToState(event) async* {
    yield AccountPageLoading(name: state.name);

    final accountOrFailure =
        await getUserProfile(GetUserProfileParams(userName: event.name));

    yield* accountOrFailure.fold(
      (left) async* {
        print('[AccountPage] failed to get user profile\n ${left.message}');
      },
      (account) async* {
        yield AccountPageLoaded(
            account: account, listingOptions: otherUserOptions);
      },
    );
  }
}

final List<AccountPageListingOptions> otherUserOptions = [
  AccountPageListingOptions.posts,
  AccountPageListingOptions.comments,
  AccountPageListingOptions.trophies,
  AccountPageListingOptions.multireddits
];
final List<AccountPageListingOptions> thisUserOptions = [
  AccountPageListingOptions.saved,
  AccountPageListingOptions.upvoted,
  AccountPageListingOptions.downvoted,
  AccountPageListingOptions.hidden,
  AccountPageListingOptions.friends
];

enum AccountPageListingOptions {
  posts,
  comments,
  multireddits,
  trophies,
  saved,
  upvoted,
  downvoted,
  hidden,
  friends,
  moderatorZone
}
