import 'package:dartz/dartz.dart';

import '../../../features/subreddit/get_submissions.dart';
import '../../../models/sort_option.dart';
import '../subreddit_page_bloc.dart';
import '../subreddit_page_state.dart';

class SortSubmissionsAction
    implements Actionable<SubredditPageState, SubredditPageBloc> {
  GetRedditLinks usecase;

  SubmissionSort sort;
  Option<List<ActionableFn>> filterFnsOption;

  SortSubmissionsAction(
    this.usecase,
    this.sort, {
    this.filterFnsOption = const None(),
  })  : assert(usecase != null),
        assert(sort != null);

  @override
  ActionModel<SubredditPageState, SubredditPageBloc> toAction(
          SubredditPageBloc bloc) =>
      ActionModel(
          (bloc) => _states(bloc),
          sort.icon,
          (bloc.state.currentSort == sort)
              ? bloc.state.currentSort.description
              : sort.description,
          options: filterFnsOption,
          selected: bloc.state.currentSort == sort);

  Stream<SubredditPageState> _states(bloc) async* {
    yield* filterFnsOption.fold(() async* {
      yield SubredditPageLoading(
          currentSort: sort, subreddit: bloc.state.subreddit);
      final params = GetRedditLinksParams(
          subreddit: bloc.state.subreddit, sort: sort.type);

      final redditLinksOrFailure = await usecase(params);

      yield* redditLinksOrFailure.fold((failure) async* {
        yield SubredditPageError(
          subreddit: bloc.state.subreddit,
          redditLinks: bloc.state.redditLinks,
          currentSort: bloc.state.currentSort,
          error: failure.message,
        );
      }, (redditLinks) async* {
        yield SubredditPageLoaded(
          redditLinks: redditLinks,
          subreddit: bloc.state.subreddit,
          currentSort: sort,
        );
      });
    }, (filterFns) async* {
      await Future.delayed(Duration(milliseconds: 200));
      yield DisplayingActions(
          currentSort: bloc.state.currentSort,
          subreddit: bloc.state.subreddit,
          actions: filterFns
              .map((fn) => fn(sort))
              .map((actionable) => actionable.toAction(bloc))
              .toList());
    });
  }
}
