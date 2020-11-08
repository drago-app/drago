import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/models/score_model.dart';
import 'package:drago/sandbox/types.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils.dart';

abstract class BaseCommentModel extends Equatable {
  int get depth;
  // String get submissionId;
  String get id;

  @override
  List<Object> get props => [depth, id];

  BaseCommentModel();

  factory BaseCommentModel.fromMore(More more) {
    return more.count == 0
        ? ContinueThreadModel(
            depth: more.depth, submissionId: more.submissionId, id: more.id)
        : MoreCommentsModel(
            depth: more.depth,
            numReplies: more.count,
            submissionId: more.submissionId,
            id: more.id);
  }
  factory BaseCommentModel.fromRedditComment(RedditComment redditComment) {
    //Theres some room for optimization here. There is a lot of duplicate computation in _getCount

    return CommentModel(
        voteState: redditComment.voteState,
        id: redditComment.id,
        author: Author(name: redditComment.author),
        authorFlairText: redditComment.authorFlairText,
        body: redditComment.body,
        depth: redditComment.depth,
        edited: redditComment.edited,
        // score: redditComment.score,
        age: createdUtcToAge(redditComment.createdUtc),
        score: ScoreModel(score: redditComment.score),
        children: _getChildren(redditComment),
        count: _getCount(redditComment)
        // submissionId: redditComment.id
        );
  }

  static int _getCount(redditComment) {
    return redditComment.children.fold(
        1,
        (acc, moc) => moc.fold(
              (more) => more.count + acc,
              (comment) => _getCount(comment) + acc,
            ));
  }

  static List<BaseCommentModel> _getChildren(RedditComment redditComment) {
    if (redditComment.children == null) return [];

    return redditComment.children
        .map<BaseCommentModel>((moc) => moc.fold(
            (more) => BaseCommentModel.fromMore(more),
            (redditComment) =>
                BaseCommentModel.fromRedditComment(redditComment)))
        .toList();
  }
}

class CommentModel extends BaseCommentModel {
  final String id;
  final VoteState voteState;
  final int depth;
  final bool edited;
  final Author author;
  final ScoreModel score;
  final int count;
  final String body;
  final String authorFlairText;
  final String age;
  // final String submissionId;
  final List<BaseCommentModel> children;
  // final String submissionId;

  @override
  List<Object> get props => [
        id,
        depth,
        edited,
        author,
        score,
        body,
        authorFlairText,
        age,
        children,
        count,
        // submissionId
      ];

  CommentModel({
    @required this.voteState,
    @required this.id,
    @required this.depth,
    @required this.edited,
    @required this.author,
    @required this.score,
    @required this.body,
    @required this.authorFlairText,
    @required this.age,
    // @required this.submissionId,
    @required this.children,
    @required this.count,
  });
}

class ContinueThreadModel extends BaseCommentModel {
  final int depth;
  final String submissionId;
  final String id;

  ContinueThreadModel(
      {@required this.id, @required this.depth, @required this.submissionId})
      : assert(depth != null);

  List<Object> get props => [id, depth, submissionId];
}

class MoreCommentsModel extends BaseCommentModel {
  final int depth;
  final int numReplies;
  final String submissionId;
  final String id;
  // final String submissionId;

  // MoreCommentsModel();

  MoreCommentsModel(
      {@required this.id,
      @required this.depth,
      @required this.numReplies,
      @required this.submissionId
      //  @required this.submissionId,
      }) //: assert(depth != null)
  // assert(submissionId != null)
  ;
  List<Object> get props => [id, depth, numReplies, submissionId];
}
