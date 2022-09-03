//https://github.com/honestbleeps/Reddit-Enhancement-Suite/blob/master/lib/types/reddit.js
import 'package:dartz/dartz.dart';
import 'package:drago/core/entities/vote_state.dart';
import 'package:drago/utils.dart';
import 'package:flutter/foundation.dart';

VoteState _voteState(dynamic vote) => (vote == null)
    ? VoteState.Neutral
    : (vote == 'likes')
        ? VoteState.Up
        : VoteState.Down;

DateTime _createdUtc(dynamic created_utc) {
  return DateTime.fromMillisecondsSinceEpoch(
      ((created_utc as double).round() * 1000),
      isUtc: true);
}

bool _edited(dynamic edited) => (edited == null) ? false : true;

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

  factory More.fromJson(Map json) {
    return More(
        id: json['id'],
        parentId: json['parent_id'],
        count: json['count'],
        data: json,
        depth: json['depth'],
        submissionId: null);
  }
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

  factory RedditComment.fromJson(Map json) {
    try {
      return RedditComment(
          author: json['author'],
          body: json['body'],
          createdUtc: _createdUtc(json['created_utc']),
          id: json['id'],
          edited: _edited(json['edited']),
          depth: json['depth'],
          score: json['score'],
          authorFlairText: json['author_flair_text'],
          distinguished: json['distinguished'],
          children: _buildChildren(json['replies']),
          voteState: _voteState(json['likes']));
    } catch (e) {
      print('RedditComment-- ${json['id']} ' + e.toString());
    }
  }

  static List<Either<More, RedditComment>> _buildChildren(replies) {
    if (replies == "" || replies == null) return [];
    final Map data = replies['data'];
    final children = data['children'];

    return buildComments(children);
  }

  /// Objects that come in here should be like:
  /// {'kind': 'more', 'data': {...} } or
  /// {'t1': 'more', 'data': {...} }
  static List<Either<More, RedditComment>> buildComments(List jsonChildren) {
    if (jsonChildren == null) return [];

    List<Either<More, RedditComment>> answer = jsonChildren
        .map<Either<More, RedditComment>>((child) => child['kind'] == 'more'
            ? Left(More.fromJson(child['data']))
            : Right(RedditComment.fromJson(child['data'])))
        .toList();

    return answer;
  }
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
  final bool archived;
  final bool edited;
  final bool isSelf;
  final bool saved;
  final bool isNSFW;
  final bool stickied;
  final String domain;
  final String id;
  // final String permalink;

  final String title;
  // final Option<String> previewUrl;
  final String previewUrl;
  final String body;
  final String url;
  final String subreddit;
  final String authorFlairText;
  final String linkFlairText;

  /// admin, moderator,  null
  final String distinguished;
  final int score;
  final int numComments;
  final VoteState voteState;

  RedditLink(
      {@required this.author,
      @required this.createdUtc,
      @required this.archived,
      @required this.edited,
      @required this.isSelf,
      @required this.isNSFW,
      @required this.saved,
      @required this.stickied,
      @required this.domain,
      @required this.body,
      @required this.distinguished,
      @required this.id,
      @required this.numComments,
      @required this.score,
      @required this.subreddit,
      @required this.authorFlairText,
      @required this.linkFlairText,
      @required this.title,
      @required this.url,
      @required this.previewUrl,
      @required this.voteState});

  // static Option<String> _previewUrl(Map<String, dynamic> preview) {
  //   return optionOf(preview['images'].first?.source['url']);
  // }

  static String _previewUrl(Map<String, dynamic> preview) {
    if (preview == null || preview.isEmpty) return null;
    return unescape(preview['images']?.first['source']['url']);
  }

  static VoteState _voteState(String vote) => (vote == null)
      ? VoteState.Neutral
      : (vote == 'likes')
          ? VoteState.Up
          : VoteState.Down;

  static VoteState _parseLikes(likes) => (likes == null)
      ? VoteState.Neutral
      : (likes == true)
          ? VoteState.Up
          : VoteState.Down;

  static bool _parseArchived(bool archived) => archived;

  static DateTime _createdUtc(dynamic created_utc) {
    return DateTime.fromMillisecondsSinceEpoch(
        ((created_utc as double).round() * 1000),
        isUtc: true);
  }

  factory RedditLink.fromJson(Map<dynamic, dynamic> json) {
    try {
      return RedditLink(
          author: json['author'],
          edited: _edited(json['edited']),
          isSelf: json['is_self'],
          isNSFW: json['over_18'],
          saved: json['saved'],
          stickied: json['stickied'],
          domain: json['domain'],
          distinguished: json['distinguished'],
          id: json['id'],
          numComments: json['num_comments'],
          score: json['score'],
          subreddit: json['subreddit'],
          authorFlairText: json['author_flair_text'] ?? '',
          linkFlairText: json['link_flair_text'] ?? '',
          title: json['title'],
          url: json['url'],
          previewUrl: _previewUrl(json['preview']),
          voteState: _parseLikes(json['likes']),
          body: json['selftext'],
          createdUtc: _createdUtc(json['created_utc']),
          archived: _parseArchived(json['archived'] ?? false));
    } catch (e) {
      // print("previewUrl -- " + _previewUrl(json['preview']));
      print(json['url']);
    }
  }
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
