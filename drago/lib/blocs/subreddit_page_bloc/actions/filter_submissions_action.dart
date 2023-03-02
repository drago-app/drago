import 'package:dartz/dartz.dart';

import '../../../features/subreddit/get_submissions.dart';
import '../../../models/sort_option.dart';
import '../subreddit_page.dart';

class SubmissionFilterAction implements Actionable {
  GetRedditLinks usecase;
  SubmissionSort sort;
  SubmissionFilter filter;

  SubmissionFilterAction(this.usecase, this.sort, this.filter);

  @override
  ActionModel<SubredditPageState, SubredditPageBloc> toAction(bloc) =>
      ActionModel(
        (bloc) => _states(bloc),
        filter.icon,
        filter.description,
        selected: bloc.state.currentSort.selectedFilter
            .fold(() => false, (selectedFilter) => selectedFilter == filter),
      );

  Stream<SubredditPageState> _states(bloc) async* {
    yield SubredditPageLoading(
        subreddit: bloc.state.subreddit,
        currentSort: sort.copyWith(selectedFilter: Some(filter)));

    final redditLinksOrFailure = await usecase(
      GetRedditLinksParams(
        subreddit: bloc.state.subreddit,
        sort: sort.type,
        filter: filter.type,
      ),
    );

    yield* redditLinksOrFailure.fold((failure) async* {
      yield SubredditPageError(
        subreddit: bloc.state.subreddit,
        redditLinks: bloc.state.redditLinks,
        currentSort: bloc.state.currentSort,
        error: failure.message,
      );
    }, (redditLinks) async* {
      yield SubredditPageLoaded(
        currentSort: bloc.state.currentSort,
        redditLinks: redditLinks,
        subreddit: bloc.state.subreddit,
      );
    });
  }
}
