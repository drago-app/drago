import 'package:drago/core/entities/vote_state.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/models/score_model.dart';
import 'package:drago/sandbox/types.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils.dart';

abstract class BaseCommentModel extends Equatable {
  final int depth;
  final String id;
  final String submissionId;

  @override
  List<Object?> get props => [depth, id, submissionId];

  BaseCommentModel(
      {required this.depth, required this.id, required this.submissionId})
      : assert(depth != null),
        assert(submissionId != null),
        assert(id != null);

  factory BaseCommentModel.fromMore(More more, String submissionId) {
    return more.count == 0
        ? ContinueThreadModel(
            depth: more.depth,
            submissionId: submissionId,
            id: more.id,
            data: more.data)
        : MoreCommentsModel(
            depth: more.depth,
            numReplies: more.count,
            submissionId: submissionId,
            id: more.id,
            data: more.data);
  }
  factory BaseCommentModel.fromRedditComment(
      RedditComment redditComment, String submissionId) {
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
      children: _getChildren(redditComment, submissionId),
      count: _getCount(redditComment),
      submissionId: submissionId,
    );
  }

  static int? _getCount(redditComment) {
    return redditComment.children.fold(
        1,
        (acc, moc) => moc.fold(
              (more) => more.count + acc,
              (comment) => _getCount(comment)! + acc,
            ));
  }

  static List<BaseCommentModel> _getChildren(
      RedditComment redditComment, submissionId) {
    // if (redditComment.children == null) return [];

    return redditComment.children
        .map<BaseCommentModel>((moc) => moc.fold(
            (more) => BaseCommentModel.fromMore(more, submissionId),
            (redditComment) => BaseCommentModel.fromRedditComment(
                redditComment, submissionId)))
        .toList();
  }
}

class CommentModel extends BaseCommentModel {
  final VoteState voteState;

  final bool edited;
  final Author author;
  final ScoreModel score;
  final int? count;
  final String? body;
  final String? authorFlairText;
  final String age;

  final List<BaseCommentModel> children;

  @override
  List<Object?> get props => [
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
        submissionId
      ];

  CommentModel({
    required this.voteState,
    required id,
    required depth,
    required this.edited,
    required this.author,
    required this.score,
    required this.body,
    required this.authorFlairText,
    required this.age,
    required submissionId,
    required this.children,
    required this.count,
  }) : super(depth: depth, id: id, submissionId: submissionId);
}

class ContinueThreadModel extends BaseCommentModel {
  final Map data;

  ContinueThreadModel(
      {required id, required depth, required this.data, required submissionId})
      : super(depth: depth, id: id, submissionId: submissionId);

  List<Object> get props => [id, depth, submissionId];
}

class MoreCommentsModel extends BaseCommentModel {
  final int? numReplies;

  final Map data;
  // final String submissionId;

  // MoreCommentsModel();

  MoreCommentsModel(
      {required id,
      required depth,
      required this.numReplies,
      required this.data,
      required submissionId})
      : super(depth: depth, id: id, submissionId: submissionId);
  List<Object?> get props => [id, depth, numReplies, submissionId];
}
