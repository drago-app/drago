import 'package:drago/models/num_comments_model.dart';
import 'package:drago/models/score_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/entities/preview.dart';
import 'package:drago/core/entities/submission_author.dart';

enum VoteState_ { Up, Down, Neutral }

class SubmissionModel extends Equatable {
  final String age;
  final String title;
  final SubmissionAuthor author;
  final String authorFlairText;
  final String id;
  final String subredditName;
  final String upvoteRatio;
  final ScoreModel score;

  final bool saved;
  final int upvotes;
  final NumCommentsModel numComments;
  final ContentPreview preview;
  final VoteState_ voteState;

  SubmissionModel(
      {@required this.title,
      @required this.author,
      @required this.authorFlairText,
      @required this.id,
      @required this.subredditName,
      @required this.saved,
      @required this.upvotes,
      @required this.score,
      @required this.numComments,
      @required this.upvoteRatio,
      @required this.age,
      @required this.preview,
      @required this.voteState});

  SubmissionModel copyWith(
      {title,
      author,
      authorFlairText,
      id,
      subredditName,
      upvotes,
      saved,
      score,
      numComments,
      upvoteRatio,
      age,
      preview,
      voteState}) {
    return SubmissionModel(
        age: age ?? this.age,
        author: author ?? this.author,
        authorFlairText: authorFlairText ?? this.authorFlairText,
        id: id ?? this.id,
        subredditName: subredditName ?? this.subredditName,
        saved: saved ?? this.saved,
        numComments: numComments ?? this.numComments,
        upvoteRatio: upvoteRatio ?? this.upvoteRatio,
        preview: preview ?? this.preview,
        score: score ?? this.score,
        title: title ?? this.title,
        voteState: voteState ?? this.voteState,
        upvotes: upvotes ?? this.upvotes);
  }

  @override
  List<Object> get props => [
        title,
        author,
        authorFlairText,
        id,
        subredditName,
        saved,
        upvotes,
        score,
        numComments,
        upvoteRatio,
        age,
        preview,
        voteState
      ];

  @override
  String toString() {
    return '[SubmissionModel] saved: ${saved.toString()} .... voteState: ${voteState.toString()}';
  }
}
