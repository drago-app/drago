import '../../../features/subreddit/subscribe_to_subreddit.dart';
import '../subreddit_page_bloc.dart';
import '../subreddit_page_state.dart';

class SubscribeToSubredditAction
    implements Actionable<SubredditPageState, SubredditPageBloc> {
  SubscribeToSubreddit usecase;

  SubscribeToSubredditAction(this.usecase) : assert(usecase != null);

  @override
  ActionModel<SubredditPageState, SubredditPageBloc> toAction(
          SubredditPageBloc bloc) =>
      ActionModel((bloc) => _states(bloc), null, "Subscribe");

  Stream<SubredditPageState> _states(SubredditPageBloc bloc) async* {
    final unitOrFailure =
        await usecase(SubscribeToSubredditParams(bloc.subreddit));
    yield* unitOrFailure.fold((failure) async* {
      yield SubredditPageError(
        currentSort: bloc.state.currentSort,
        redditLinks: bloc.state.redditLinks,
        subreddit: bloc.state.subreddit,
        error: failure.message,
      );
    }, (_) async* {
      print('SUBSCRIBED TO ${bloc.subreddit}');
      yield SubredditPageLoaded(
        currentSort: bloc.state.currentSort,
        redditLinks: bloc.state.redditLinks,
        subreddit: bloc.state.subreddit,
      );
    });
  }
}
