import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/dialog/dialog_service.dart';
import 'package:drago/models/score_model.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/features/submission/usecases.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final SubmissionModel submission;
  final UpvoteOrClear upvoteOrClear;
  final DownvoteOrClear downvoteOrClear;
  final SaveOrUnsaveSubmission saveOrUnsave;

  final DialogService service;

  SubmissionBloc(
      {@required this.submission,
      @required this.upvoteOrClear,
      @required this.downvoteOrClear,
      @required this.saveOrUnsave,
      @required this.service})
      : assert(submission != null),
        assert(upvoteOrClear != null),
        assert(downvoteOrClear != null),
        assert(saveOrUnsave != null);

  @override
  get initialState => SubmissionInitial(submission: submission);

  @override
  Stream<Transition<SubmissionEvent, SubmissionState>> transformEvents(
    Stream<SubmissionEvent> events,
    TransitionFunction<SubmissionEvent, SubmissionState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
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
  }

  Stream<SubmissionState> _mapSaveToState() async* {
    final oldState = state;

    yield state.copyWith(
        submission: state.submission.copyWith(saved: !state.submission.saved));
    saveOrUnsave(SaveOrUnsaveParams(submission: oldState.submission));
  }

  Stream<SubmissionState> _mapUpvoteToState() async* {
    final oldState = state;
    final newSubmission = state.submission.copyWith(
      voteState: (state.submission.voteState == VoteState_.Up)
          ? VoteState_.Neutral
          : VoteState_.Up,
      score: ScoreModel(
          score: (state.submission.voteState == VoteState_.Up)
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
          yield SubmissionError(
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

    yield SubmissionInitial(
      submission: state.submission.copyWith(
          voteState: (state.submission.voteState == VoteState_.Down)
              ? VoteState_.Neutral
              : VoteState_.Down,
          score: ScoreModel(
              score: (state.submission.voteState == VoteState_.Up)
                  ? state.submission.score.score + 1
                  : state.submission.score.score - 1)),
    );
    downvoteOrClear(DownVoteParams(submission: oldState.submission));
  }
}
