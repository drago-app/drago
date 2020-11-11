//https://github.com/honestbleeps/Reddit-Enhancement-Suite/blob/master/lib/types/reddit.js
import 'package:dartz/dartz.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:flutter/foundation.dart';

abstract class RedditThing {
  static String kind;
}

class More implements RedditThing {
  static String kind = 'more';
  final String id, parentId, submissionId;
  final int count, depth;
  final Map data;

  More({
    @required this.id,
    @required this.parentId,
    @required this.count,
    @required this.depth,
    @required this.data,
    @required this.submissionId,
  });
}

class RedditComment implements RedditThing {
  static String kind = 't1';
  final VoteState voteState;
  final String author;
  final String body;
  // final num created;
  final DateTime createdUtc;
  final String id;
  // final String subreddit;
  final String distinguished;
  final String authorFlairText;
  final int score;
  final bool edited;
  final int depth;
  List<Either<More, RedditComment>> children;

  RedditComment(
      {@required this.author,
      @required this.voteState,
      @required this.body,
      // @required this.created,
      @required this.createdUtc,
      @required this.id,
      @required this.edited,
      @required this.depth,
      @required this.score,

      // @required this.subreddit,
      @required this.authorFlairText,
      @required this.distinguished,
      @required this.children});
}

class RedditAccount implements RedditThing {
  static String kind = 't2';
  final num commentKarma;
  final num createdUtc;
  final String id;
  final bool isFriend;
  final bool isMod;
  final num linkKarma;
  final String name;

  RedditAccount(
      {this.commentKarma,
      this.createdUtc,
      this.id,
      this.isFriend,
      this.isMod,
      this.linkKarma,
      this.name});
}

class CurrentRedditUser implements RedditThing {
  static String kind = 't2';
  final String modhash;
  final num commentKarma;
  final num created;
  final num createdUtc;
  final String id;
  // final num inboxCount;
  final bool isMod;
  final num linkKarma;
  final String name;
  final bool over18;

  CurrentRedditUser(
      {this.modhash,
      this.commentKarma,
      this.created,
      this.createdUtc,
      this.id,
      this.isMod,
      this.linkKarma,
      this.name,
      this.over18});
}

class RedditLink implements RedditThing {
  static String kind = 't3';
  final String author;
  // final num created;
  final DateTime createdUtc;
  final bool edited;
  final bool isSelf;
  final bool saved;
  final bool isNSFW;
  final bool stickied;
  final String domain;
  final String id;
  // final String permalink;

  final String title;
  final String url;
  final String body;
  final String previewUrl;
  final String subreddit;
  final String authorFlairText;
  final String linkFlairText;

  /// admin, moderator,  null
  final String distinguished;
  final int score;
  final int numComments;
  final VoteState voteState;

  RedditLink(
      {this.author,
      this.createdUtc,
      this.edited,
      this.isSelf,
      this.isNSFW,
      this.saved,
      this.stickied,
      this.domain,
      this.body,
      this.distinguished,
      this.id,
      this.numComments,
      this.score,
      this.subreddit,
      this.authorFlairText,
      this.linkFlairText,
      this.title,
      this.url,
      this.previewUrl,
      this.voteState});
}

class RedditMessage implements RedditThing {
  static String kind = 't4';
  final String author;
  final String body;
  final num created;
  final num createdUtc;
  final String dest;
  final String id;
  final String subject;
  final String subreddit;

  RedditMessage(
      {this.author,
      this.body,
      this.created,
      this.createdUtc,
      this.dest,
      this.id,
      this.subject,
      this.subreddit});
}

class RedditSubreddit implements RedditThing {
  static String kind = 't5';
  // final num created;
  final DateTime createdUtc;
  // final String description;
  final String displayName;
  final String id;
  final String name;
  final bool over18;
  final String title;
  final String url;
  final bool userIsSubscriber;

  RedditSubreddit(
      {
      // this.created,
      this.createdUtc,
      // this.description,
      this.displayName,
      this.id,
      this.name,
      this.over18,
      this.title,
      this.url,
      this.userIsSubscriber});
}
