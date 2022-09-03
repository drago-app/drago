import 'package:drago/features/subreddit/subreddit.dart';

import '../../../icons_enum.dart';
import '../subreddit_page_bloc.dart';
import '../subreddit_page_state.dart';

class FavoriteSubredditAction
    implements Actionable<SubredditPageState, SubredditPageBloc> {
  FavoriteSubreddit usecase;

  FavoriteSubredditAction(this.usecase) : assert(usecase != null);

  @override
  ActionModel<SubredditPageState, SubredditPageBloc> toAction(
          SubredditPageBloc bloc) =>
      ActionModel((bloc) => _states(bloc), DragoIcons.favorite, "Favorite");

  Stream<SubredditPageState> _states(SubredditPageBloc bloc) async* {
    final unitOrFailure =
        await usecase(FavoriteSubredditParams(bloc.subreddit));
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
        redditLinks: bloc.state.redditLinks,
        subreddit: bloc.state.subreddit,
      );
    });
  }
}