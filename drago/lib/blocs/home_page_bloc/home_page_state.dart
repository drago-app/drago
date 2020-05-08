import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class HomePageState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final List subscriptions;
  final List moderatedSubs;

  HomePageLoaded({@required this.subscriptions, @required this.moderatedSubs})
      : assert(subscriptions != null),
        assert(moderatedSubs != null);

  @override
  List<Object> get props => [subscriptions, moderatedSubs];

  HomePageLoaded copyWith({List subscriptions, List moderatedSubs}) {
    return HomePageLoaded(
        subscriptions: subscriptions ?? this.subscriptions,
        moderatedSubs: moderatedSubs ?? this.moderatedSubs);
  }
}

class HomePageError extends HomePageState {}
