import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/core/entities/preview.dart';
import 'package:helius/core/entities/submission_author.dart';

enum VoteState_ { Up, Down, Neutral }

class SubmissionModel extends Equatable {
  final String age;
  final String title;
  final SubmissionAuthor author;
  final String authorFlairText;
  final String id;

  final bool saved;
  final int upvotes;
  final int score;
  final int numComments;
  final ContentPreview preview;
  final VoteState_ voteState;

  SubmissionModel(
      {@required this.title,
      @required this.author,
      @required this.authorFlairText,
      @required this.id,
      @required this.saved,
      @required this.upvotes,
      @required this.score,
      @required this.numComments,
      @required this.age,
      @required this.preview,
      @required this.voteState});

  SubmissionModel copyWith(
      {title,
      author,
      authorFlairText,
      id,
      upvotes,
      saved,
      score,
      numComments,
      age,
      preview,
      voteState}) {
    return SubmissionModel(
        age: age ?? this.age,
        author: author ?? this.author,
        authorFlairText: authorFlairText ?? this.authorFlairText,
        id: id ?? this.id,
        saved: id ?? this.saved,
        numComments: numComments ?? this.numComments,
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
        saved,
        upvotes,
        score,
        numComments,
        age,
        preview,
        voteState
      ];

  @override
  String toString() {
    return '[SubmissionModel] voteState: ${voteState.toString()}';
  }
}
