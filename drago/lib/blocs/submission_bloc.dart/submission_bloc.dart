import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drago/core/entities/vote_state.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/dialog/dialog_service.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/models/score_model.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/sandbox/types.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:drago/features/submission/usecases.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final RedditLink redditLink;
  final UpvoteOrClear upvoteOrClear;
  final DownvoteOrClear downvoteOrClear;
  final SaveOrUnsaveSubmission saveOrUnsave;

  final DialogService service;

  SubmissionBloc(
      {@required this.redditLink,
      @required this.upvoteOrClear,
      @required this.downvoteOrClear,
      @required this.saveOrUnsave,
      @required this.service})
      : assert(redditLink != null),
        assert(upvoteOrClear != null),
        assert(downvoteOrClear != null),
        assert(saveOrUnsave != null),
        super(SubmissionInitial(
            submission: Submission.fromRedditLink(link: redditLink))) {
    _getSubmissionFromRedditLink(redditLink);
  }

  _getSubmissionFromRedditLink(RedditLink redditLink) {
    // final Stream<ExpandoMedia> mediaStream = Host.getMedia(redditLink.url);
    //Can this cause ui bugs? Like voting then  this causes a rebuild which would then hide the vote?
    if (redditLink.isSelf) {
      this.add(SubmissionResolved(
          submission: SelfSubmission.fromRedditLink(link: redditLink)));
    }
    // else {
    //   this.add(SubmissionResolved(
    //       submission: WebSubmission.fromRedditLink(link: redditLink)));
    // }
    Host.getMedia(redditLink.url).forEach((media) {
      try {
        this.add(
          SubmissionResolved(
              submission: MediaSubmission.fromRedditLink(
                  link: redditLink, media: media)),
        );
      } catch (e) {
        debugPrint(e.toString());
        debugPrint(redditLink.title);
      }
    });
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
    if (event is SubmissionResolved) {
      yield state.copyWith(submission: event.submission);
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
        if (left is PostArchivedFailure) {
          yield SubmissionActionError(
              submission: oldState.submission, title: left.message);
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
        if (left is PostArchivedFailure) {
          yield SubmissionActionError(
              submission: oldState.submission, title: left.message);
        }
      },
      (right) async* {},
    );
  }
}
