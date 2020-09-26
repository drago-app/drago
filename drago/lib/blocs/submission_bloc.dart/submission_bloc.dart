import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/features/subreddit/get_reddit_links.dart';
import 'package:drago/models/score_model.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/sandbox/types.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/features/submission/usecases.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dartz/dartz.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final RedditLink redditLink;
  final UpvoteOrClear upvoteOrClear;
  final DownvoteOrClear downvoteOrClear;
  final SaveOrUnsaveSubmission saveOrUnsave;

  SubmissionBloc({
    required this.redditLink,
    required this.upvoteOrClear,
    required this.downvoteOrClear,
    required this.saveOrUnsave,
  }) {
    _getSubmissionFromRedditLink(redditLink);
  }

  @override
  get initialState => SubmissionInitial(
      submission: Submission.fromRedditLink(link: redditLink));

  _getSubmissionFromRedditLink(RedditLink redditLink) async {
    Option<Host> optionalHost =
        Host.getHost(redditLink.url); //HostManager.getMedia(redditLink.url);

    var x = await optionalHost.fold(
      () => {},
      (Host host) async => Host.getMedia(host, redditLink.url),
    );
  }

  @override
  Stream<Transition<SubmissionEvent, SubmissionState>> transformEvents(
    Stream<SubmissionEvent> events,
    TransitionFunction<SubmissionEvent, SubmissionState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 1)),
      transitionFn,
    );
  }

  @override
  Stream<SubmissionState> mapEventToState(SubmissionEvent event) async* {
    if (event is Upvote) {
      yield* _mapUpvoteToState();
    }
    if (event is Downvote) {
      yield* _mapDownvoteToState();
    }
    if (event is Save) {
      yield* _mapSaveToState();
    }
    if (event is DialogDismissed) {
      yield SubmissionInitial(submission: state.submission);
    }
  }

  Stream<SubmissionState> _mapSaveToState() async* {
    final oldState = state;

    yield state.copyWith(
      submission: state.submission.copyWith(saved: !state.submission.saved),
    );
    final saveOrFailure =
        await saveOrUnsave(SaveOrUnsaveParams(submission: oldState.submission));
    yield* saveOrFailure.fold((left) async* {
      if (left is NotAuthorizedFailure) {
        yield SubmissionAuthError(
            submission: oldState.submission,
            title: "Sign In to Save",
            content: 'You need to be signed in to save.');
      }
    }, (right) async* {});
  }

  Stream<SubmissionState> _mapUpvoteToState() async* {
    final oldState = state;

    final newSubmission = state.submission.copyWith(
      voteState: (state.submission.voteState == VoteState.Up)
          ? VoteState.Neutral
          : VoteState.Up,
      score: ScoreModel(
          score: (state.submission.voteState == VoteState.Up)
              ? state.submission.score.score - 1
              : state.submission.score.score + 1),
    );

    final newState = state.copyWith(submission: newSubmission);
    yield newState;

    final upvoteOrFailure =
        await upvoteOrClear(VoteParams(submission: oldState.submission));

    yield* upvoteOrFailure.fold(
      (left) async* {
        if (left is NotAuthorizedFailure) {
          yield SubmissionAuthError(
              submission: oldState.submission,
              title: "Sign In to Upvote",
              content: 'You need to be signed in to upvote.');
        }
      },
      (right) async* {},
    );
  }

  Stream<SubmissionState> _mapDownvoteToState() async* {
    final oldState = state;

    final newSubmission = state.submission.copyWith(
      voteState: (state.submission.voteState == VoteState.Down)
          ? VoteState.Neutral
          : VoteState.Down,
      score: ScoreModel(
          score: (state.submission.voteState == VoteState.Up)
              ? state.submission.score.score + 1
              : state.submission.score.score - 1),
    );

    final newState = state.copyWith(submission: newSubmission);
    yield newState;

    final downvoteOrFailure =
        await downvoteOrClear(DownVoteParams(submission: oldState.submission));

    yield* downvoteOrFailure.fold(
      (left) async* {
        if (left is NotAuthorizedFailure) {
          yield SubmissionAuthError(
              submission: oldState.submission,
              title: "Sign In to Downvote",
              content: 'You need to be signed in to downvote.');
        }
      },
      (right) async* {},
    );
  }
}

// class HostManager {
//   static List<Host> hosts = [defaultHost, defaultVideo];

//   static Option<Host> _getHost(url) {
//     List<Host> x =
//         hosts.where((host) => host.detect(url) is RegExpMatch).toList();

//     return catching(() => x.first).toOption();
//   }

//   static Future<Option<ExpandoMedia>> getMedia(Host host, String url) async {
//     final media = await host.handleLink(url, host.detect(url));

//     return catching(() => media).toOption();
//   }
// }
