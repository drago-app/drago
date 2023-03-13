import 'package:drago/core/entities/subreddit.dart';
import 'package:equatable/equatable.dart';

abstract class HomePageState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final List<Subreddit> subscriptions;
  final List<Subreddit> moderatedSubs;

  HomePageLoaded({required this.subscriptions, required this.moderatedSubs});

  @override
  List<Object> get props => [subscriptions, moderatedSubs];

  HomePageLoaded copyWith(
      {List<Subreddit>? subscriptions, List<Subreddit>? moderatedSubs}) {
    return HomePageLoaded(
        subscriptions: subscriptions ?? this.subscriptions,
        moderatedSubs: moderatedSubs ?? this.moderatedSubs);
  }
}

class HomePageError extends HomePageState {
  final String? message;
  HomePageError(this.message);
}
