import 'package:dartz/dartz.dart';
import 'package:drago/models/score_model.dart';
import 'package:drago/models/sort_option.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/sandbox/types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

class GetSubmissions
    implements UseCase<List<Future<Submission>>, GetSubmissionsParams> {
  final RedditService reddit;

  GetSubmissions({@required this.reddit});

  @override
  Future<Either<Failure, List<Future<Submission>>>> call(
      GetSubmissionsParams params) async {
    // What do I need to do here?
    // Take a RedditLink and transform into a submission
    // I think three types of Submissions: Self, Link, Media
    // First check if it's self
    // Then check if any host can handle it
    // If any host can handle then it is a Media submission
    // otherwise it is a Link -- but a Link Submission is really just a basic
    // submission because all RedditLinks have a url, we're just trying to
    // figure out how to handle them

    final linksOrFailure = await reddit.getSubmissions(params.subreddit,
        sort: params.sort, after: params.after, filter: params.filter);

    return linksOrFailure.fold(
      (left) => Left(left),
      (right) => Right(
        right.map((link) => _mapLinkToSubmission(link)).toList(),
      ),
    );
  }

  Future<Submission> _mapLinkToSubmission(RedditLink link) async {
    final defaultHosts = [defaultHost, defaultVideo];
    if (link.isSelf) return Future.value(SelfSubmission(link: link));
    // final media = await HostManager.getMedia(link);
    // if(media != null)

    // return Submission.fromRedditLink(link: link);
  }
}

class HostManager {
  static List<Host> hosts = [defaultHost, defaultVideo];

  static Host _getHost(url) =>
      hosts.firstWhere((host) => host.detect(url) != null);
  static Future<ExpandoMedia> getMedia(url) async {
    final host = _getHost(url);
    if (host == null)
      return null;
    else {
      final media = await host.handleLink(url, host.detect(url));
      return media;
    }
  }
}

class Submission extends Equatable {
  static String _defaultPreviewUrl = 'https://via.placeholder.com/150';
  final Author author;
  final String domain, title, url, id, previewUrl, subreddit;
  final DateTime createdUtc;
  final bool edited, saved;
  final int numComments;
  final ScoreModel score; //todo I don't likke this

  Submission({
    @required this.author,
    @required this.createdUtc,
    @required this.edited,
    @required this.domain,
    @required this.id,
    @required this.numComments,
    @required this.score,
    @required this.title,
    @required this.url,
    @required this.previewUrl,
    @required this.saved,
    @required this.subreddit,
  });
  Submission.fromRedditLink({@required RedditLink link, String previewUrl})
      : author = Author.fromRedditLink(link: link),
        createdUtc = link.createdUtc,
        edited = link.edited,
        domain = link.domain,
        id = link.id,
        saved = link.saved,
        numComments = link.numComments,
        score = ScoreModel(score: link.score),
        title = link.title,
        subreddit = link.subreddit,
        url = link.url,
        previewUrl = previewUrl ?? link.previewUrl ?? _defaultPreviewUrl;
  Submission copyWith({score, numComments, edited}) {
    return Submission(
      author: this.author,
      createdUtc: this.createdUtc,
      edited: edited ?? this.edited,
      domain: this.domain,
      id: this.id,
      subreddit: this.subreddit,
      numComments: numComments ?? this.numComments,
      score: score ?? this.score,
      title: this.title,
      url: this.url,
      previewUrl: this.previewUrl,
      saved: saved ?? this.saved,
    );
  }

  @override
  List<Object> get props => [
        author,
        createdUtc,
        edited,
        domain,
        id,
        numComments,
        score,
        title,
        url,
        previewUrl,
        saved,
        subreddit
      ];
}

class SelfSubmission extends Submission {
  static String _defaultPreview =
      'https://via.placeholder.com/150/0000FF/808080?Text=SELF';
  final String body;

  SelfSubmission({@required RedditLink link})
      : body = link.body,
        super.fromRedditLink(link: link, previewUrl: _defaultPreview);
}

enum AuthorType { admin, moderator, regular, developer, loggedInUser, friend }

class Author {
  final AuthorType type;

  /// This is the of the form:
  /// spez
  final String name;
  Author({this.type = AuthorType.regular, @required this.name});
  factory Author.fromRedditLink({@required RedditLink link}) {
    if (link.distinguished == 'admin')
      return Author(name: link.author, type: AuthorType.admin);
    if (link.distinguished == 'moderator')
      return Author(name: link.author, type: AuthorType.moderator);
    if (link.author.toLowerCase() == 'pinkywrinkle')
      return Author(name: link.author, type: AuthorType.developer);
    return Author(name: link.author);
  }
  @override
  String toString() {
    return name;
  }
}

class GetSubmissionsParams {
  final String after;
  final String subreddit;
  final SubmissionSortType sort;
  final TimeFilter_ filter;

  GetSubmissionsParams(
      {@required this.subreddit, this.sort, this.filter, this.after});
}
