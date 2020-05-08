import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/blocs/submission_bloc.dart/submission.dart';
import 'package:helius/core/entities/submission_entity.dart';
import 'package:helius/features/submission/usecases.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final SubmissionModel submission;
  final UpvoteOrClear upvoteOrClear;
  final DownvoteOrClear downvoteOrClear;
  final SaveOrUnsaveSubmission saveOrUnsave;

  SubmissionBloc(
      {@required this.submission,
      @required this.upvoteOrClear,
      @required this.downvoteOrClear,
      @required this.saveOrUnsave})
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
    yield (oldState as SubmissionInitial).copyWith(
        submission:
            oldState.submission.copyWith(saved: !oldState.submission.saved));
  }

  Stream<SubmissionState> _mapUpvoteToState() async* {
    final oldState = state;
    yield SubmissionInitial(
      submission: state.submission.copyWith(
        voteState: (state.submission.voteState == VoteState_.Up)
            ? VoteState_.Neutral
            : VoteState_.Up,
        score: (state.submission.voteState == VoteState_.Up)
            ? state.submission.score - 1
            : state.submission.score + 1,
      ),
    );

    upvoteOrClear(VoteParams(submission: oldState.submission));
  }

  Stream<SubmissionState> _mapDownvoteToState() async* {
    final oldState = state;

    yield SubmissionInitial(
      submission: state.submission.copyWith(
        voteState: (state.submission.voteState == VoteState_.Down)
            ? VoteState_.Neutral
            : VoteState_.Down,
        score: (state.submission.voteState == VoteState_.Down)
            ? state.submission.score + 1
            : state.submission.score - 1,
      ),
    );
    downvoteOrClear(DownVoteParams(submission: oldState.submission));
  }
}
