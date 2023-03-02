import 'package:drago/features/subreddit/filter_subreddit.dart';

import '../../../icons_enum.dart';
import '../subreddit_page_bloc.dart';
import '../subreddit_page_state.dart';

class FilterSubredditAction
    implements Actionable<SubredditPageState, SubredditPageBloc> {
  FilterSubreddit usecase;

  FilterSubredditAction(this.usecase);

  @override
  ActionModel<SubredditPageState, SubredditPageBloc> toAction(
          SubredditPageBloc bloc) =>
      ActionModel(
          (bloc) => _states(bloc), DragoIcons.filter, "Filter Subreddit");

  Stream<SubredditPageState> _states(SubredditPageBloc bloc) async* {
    final unitOrFailure = await usecase(FilterSubredditParams(bloc.subreddit));
    yield* unitOrFailure.fold((failure) async* {
      yield SubredditPageError(
        currentSort: bloc.state.currentSort,
        redditLinks: bloc.state.redditLinks,
        subreddit: bloc.state.subreddit,
        error: failure.message,
      );
    }, (_) async* {
      yield SubredditPageLoaded(
        currentSort: bloc.state.currentSort,
        redditLinks: bloc.state.redditLinks!,
        subreddit: bloc.state.subreddit,
      );
    });
  }
}
