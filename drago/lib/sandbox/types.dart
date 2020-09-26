//https://github.com/honestbleeps/Reddit-Enhancement-Suite/blob/master/lib/types/reddit.js
import 'package:drago/core/entities/submission_entity.dart';

abstract class RedditThing {
  String get kind;
}

// class RedditComment implements RedditThing {
//   static String kind = 't1';
//   final String author;
//   final String body;
//   final num created;
//   final num createdUtc;
//   final String id;
//   final String subreddit;

//   RedditComment(
//       {this.author,
//       this.body,
//       this.created,
//       this.createdUtc,
//       this.id,
//       this.subreddit});
// }

// class RedditAccount implements RedditThing {
//   static String kind = 't2';
//   final num commentKarma;
//   final num createdUtc;
//   final String id;
//   final bool isFriend;
//   final bool isMod;
//   final num linkKarma;
//   final String name;

//   RedditAccount(
//       {this.commentKarma,
//       this.createdUtc,
//       this.id,
//       this.isFriend,
//       this.isMod,
//       this.linkKarma,
//       this.name});
// }

// class CurrentRedditUser implements RedditThing {
//   static String kind = 't2';
//   final String modhash;
//   final num commentKarma;
//   final num created;
//   final num createdUtc;
//   final String id;
//   // final num inboxCount;
//   final bool isMod;
//   final num linkKarma;
//   final String name;
//   final bool over18;

//   CurrentRedditUser(
//       {this.modhash,
//       this.commentKarma,
//       this.created,
//       this.createdUtc,
//       this.id,
//       this.isMod,
//       this.linkKarma,
//       this.name,
//       this.over18});
// }

class RedditLink implements RedditThing {
  String get kind => 't3';
  final String author;
  // final num created;
  final DateTime createdUtc;
  final bool edited;
  final bool isSelf;
  final bool saved;
  final String domain;
  final String id;
  // final String permalink;

  final String title;
  final String url;
  final String body;
  final String? previewUrl;
  final String subreddit;

  /// admin, moderator,  null
  final String distinguished;
  final int score;
  final int numComments;
  final VoteState voteState;

  RedditLink(
      {required this.author,
      required this.createdUtc,
      required this.edited,
      required this.isSelf,
      required this.saved,
      required this.domain,
      required this.body,
      required this.distinguished,
      required this.id,
      required this.numComments,
      required this.score,
      required this.subreddit,
      required this.title,
      required this.url,
      this.previewUrl,
      required this.voteState});
}

// class RedditMessage implements RedditThing {
//   static String kind = 't4';
//   final String author;
//   final String body;
//   final num created;
//   final num createdUtc;
//   final String dest;
//   final String id;
//   final String subject;
//   final String subreddit;

//   RedditMessage(
//       {this.author,
//       this.body,
//       this.created,
//       this.createdUtc,
//       this.dest,
//       this.id,
//       this.subject,
//       this.subreddit});
// }

// class RedditSubreddit implements RedditThing {
//   static String kind = 't5';
//   // final num created;
//   final DateTime createdUtc;
//   // final String description;
//   final String displayName;
//   final String id;
//   final String name;
//   final bool over18;
//   final String title;
//   final String url;
//   final bool userIsSubscriber;

//   RedditSubreddit(
//       {
//       // this.created,
//       this.createdUtc,
//       // this.description,
//       this.displayName,
//       this.id,
//       this.name,
//       this.over18,
//       this.title,
//       this.url,
//       this.userIsSubscriber});
// }
