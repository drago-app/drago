import 'package:drago/sandbox/types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/blocs/account_page_bloc/account_page.dart';

abstract class AccountPageState extends Equatable {
  String get name;

  @override
  List<Object> get props => [name];
}

class AccountPageInitial extends AccountPageState {
  final String name;
  AccountPageInitial({@required this.name});

  @override
  List<Object> get props => [name];
}

class AccountPageLoading extends AccountPageState {
  final String name;
  AccountPageLoading({@required this.name});

  @override
  List<Object> get props => [name];
}

class AccountPageLoaded extends AccountPageState {
  final RedditAccount account;
  final List<AccountPageListingOptions> listingOptions;
  final bool showModeratorOptions;

  String get name => account.name;

  AccountPageLoaded(
      {@required this.account,
      @required this.listingOptions,
      this.showModeratorOptions = true})
      : assert(account != null),
        assert(listingOptions != null);

  AccountPageLoaded copyWith({account, listingOptions, showModeratorOptions}) {
    return AccountPageLoaded(
        account: account ?? this.account,
        listingOptions: listingOptions ?? this.listingOptions,
        showModeratorOptions:
            showModeratorOptions ?? this.showModeratorOptions);
  }

  @override
  List<Object> get props => [account, listingOptions];
}
