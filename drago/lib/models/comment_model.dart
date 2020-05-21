import 'package:draw/draw.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils.dart';

abstract class BaseCommentModel extends Equatable {
  int get depth;
  String get submissionId;
  String get id;

  @override
  List<Object> get props => [depth, submissionId, id];

  BaseCommentModel();

  factory BaseCommentModel.factory(RedditBase r) {
    if (r is Comment) {
      final submission = r.submission as Submission;
      // debugPrint('submissionref --- ${r.submission.}');
      return CommentModel(
          id: r.id,
          author: r.author,
          authorFlairText: r.authorFlairText,
          body: r.body,
          depth: r.depth,
          edited: r.edited,
          score: r.score,
          age: createdUtcToAge(r.createdUtc),
          children: _children(r.replies),
          submissionId: submission.id);
    } else {
      final moreComments = r as MoreComments;
      final submission = moreComments.submission as Submission;

      if (moreComments.count == 0) {
        return ContinueThreadModel(
            depth: moreComments.data['depth'],
            submissionId: submission.id,
            id: moreComments.id);
      } else {
        return MoreCommentsModel(
            depth: moreComments.data['depth'],
            numReplies: moreComments.count,
            submissionId: submission.id,
            id: moreComments.id);
      }
    }
  }

  static List<BaseCommentModel> _children(CommentForest forest) {
    if (forest is CommentForest) {
      return forest.comments.map((c) => BaseCommentModel.factory(c)).toList();
    } else {
      return [];
    }
  }
}

class CommentModel extends BaseCommentModel {
  final String id;
  final int depth;
  final bool edited;
  final String author;
  final int score;
  final String body;
  final String authorFlairText;
  final String age;
  // final String submissionId;
  final List<BaseCommentModel> children;
  final String submissionId;

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
        submissionId
      ];

  CommentModel(
      {@required this.id,
      @required this.depth,
      @required this.edited,
      @required this.author,
      @required this.score,
      @required this.body,
      @required this.authorFlairText,
      @required this.age,
      @required this.submissionId,
      @required this.children});
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
