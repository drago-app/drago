import 'package:dartz/dartz.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/models/num_comments_model.dart';
import 'package:drago/models/score_model.dart';
import 'package:drago/models/sort_option.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/sandbox/types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:drago/core/error/failures.dart';
import 'package:drago/core/usecases/usecase.dart';
import 'package:drago/reddit_service.dart';

class GetRedditLinks
    implements UseCase<List<RedditLink>, GetRedditLinksParams> {
  final RedditService reddit;

  GetRedditLinks({@required this.reddit});

  @override
  Future<Either<Failure, List<RedditLink>>> call(
      GetRedditLinksParams params) async {
    return await reddit.getRedditLinks(params.subreddit,
        sort: params.sort, after: params.after, filter: params.filter);
  }
}

class Submission extends Equatable {
  static String _defaultPreviewUrl = 'https://via.placeholder.com/150';
  final Author author;
  final String domain,
      title,
      url,
      id,
      previewUrl,
      subreddit,
      authorFlairText,
      linkFlairText;
  final DateTime createdUtc;
  final bool edited, saved, isNSFW, stickied;
  final NumComments numComments;
  final ScoreModel score; //todo I don't likke this
  final VoteState voteState;

  Submission(
      {@required this.author,
      @required this.createdUtc,
      @required this.authorFlairText,
      @required this.linkFlairText,
      @required this.edited,
      @required this.domain,
      @required this.id,
      @required this.numComments,
      @required this.score,
      @required this.title,
      @required this.url,
      @required this.previewUrl,
      @required this.saved,
      @required this.isNSFW,
      @required this.stickied,
      @required this.subreddit,
      @required this.voteState});

  Submission.fromRedditLink({@required RedditLink link, String previewUrl})
      : author = Author.fromRedditLink(link: link),
        createdUtc = link.createdUtc,
        edited = link.edited,
        domain = link.domain,
        id = link.id,
        isNSFW = link.isNSFW,
        stickied = link.stickied,
        saved = link.saved,
        authorFlairText = link.authorFlairText,
        linkFlairText = link.linkFlairText,
        numComments = NumComments(numComments: link.numComments),
        score = ScoreModel(score: link.score),
        title = link.title,
        subreddit = link.subreddit,
        url = link.url,
        previewUrl = link.previewUrl ?? _defaultPreviewUrl,
        voteState = link.voteState;
  Submission copyWith(
      {score, numComments, edited, voteState, saved, isNSFW, stickied}) {
    return Submission(
        stickied: stickied ?? this.stickied,
        author: this.author,
        createdUtc: this.createdUtc,
        edited: edited ?? this.edited,
        domain: this.domain,
        id: this.id,
        isNSFW: isNSFW ?? this.isNSFW,
        subreddit: this.subreddit,
        numComments: numComments ?? this.numComments,
        authorFlairText: this.authorFlairText,
        linkFlairText: this.linkFlairText,
        score: score ?? this.score,
        title: this.title,
        url: this.url,
        previewUrl: this.previewUrl,
        saved: saved ?? this.saved,
        voteState: voteState ?? this.voteState);
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
        subreddit,
        voteState,
        isNSFW,
        authorFlairText,
        linkFlairText,
        stickied
      ];
}

// class WebSubmission extends Submission {
//   WebSubmission.fromRedditLink({@required RedditLink link})
//       : super.fromRedditLink(link: link);
//   WebSubmission(
//       {@required author,
//       @required stickied,
//       @required createdUtc,
//       @required edited,
//       @required domain,
//       @required id,
//       @required numComments,
//       @required authorFlairText,
//       @required linkFlairText,
//       @required score,
//       @required title,
//       @required url,
//       @required previewUrl,
//       @required saved,
//       @required isNSFW,
//       @required subreddit,
//       @required voteState})
//       : super(
//             author: author,
//             stickied: stickied,
//             authorFlairText: authorFlairText,
//             linkFlairText: linkFlairText,
//             createdUtc: createdUtc,
//             edited: edited,
//             domain: domain,
//             id: id,
//             numComments: numComments,
//             score: score,
//             title: title,
//             url: url,
//             previewUrl: previewUrl,
//             saved: saved,
//             isNSFW: isNSFW,
//             subreddit: subreddit,
//             voteState: voteState);

//   WebSubmission copyWith(
//       {score, numComments, edited, voteState, saved, isNSFW, stickied}) {
//     return WebSubmission(
//         linkFlairText: this.linkFlairText,
//         stickied: stickied ?? this.stickied,
//         authorFlairText: this.authorFlairText,
//         author: this.author,
//         createdUtc: this.createdUtc,
//         edited: edited ?? this.edited,
//         domain: this.domain,
//         id: this.id,
//         subreddit: this.subreddit,
//         numComments: numComments ?? this.numComments,
//         score: score ?? this.score,
//         title: this.title,
//         url: this.url,
//         previewUrl: this.previewUrl,
//         saved: saved ?? this.saved,
//         isNSFW: isNSFW ?? this.isNSFW,
//         voteState: voteState ?? this.voteState);
//   }
// }

class SelfSubmission extends Submission {
  static String _defaultPreview =
      'https://via.placeholder.com/150/0000FF/808080?Text=SELF';
  final String body;

  SelfSubmission.fromRedditLink({@required RedditLink link})
      : body = link.body,
        super.fromRedditLink(link: link, previewUrl: _defaultPreview);

  SelfSubmission(
      {@required this.body,
      @required stickied,
      @required authorFlairText,
      @required linkFlairText,
      @required author,
      @required createdUtc,
      @required edited,
      @required domain,
      @required id,
      @required numComments,
      @required score,
      @required title,
      @required url,
      @required previewUrl,
      @required saved,
      @required isNSFW,
      @required subreddit,
      @required voteState})
      : super(
            author: author,
            stickied: stickied,
            createdUtc: createdUtc,
            edited: edited,
            domain: domain,
            id: id,
            authorFlairText: authorFlairText,
            linkFlairText: linkFlairText,
            numComments: numComments,
            score: score,
            title: title,
            url: url,
            previewUrl: previewUrl,
            saved: saved,
            isNSFW: isNSFW,
            subreddit: subreddit,
            voteState: voteState);

  SelfSubmission copyWith(
      {score, numComments, edited, voteState, saved, body, isNSFW, stickied}) {
    return SelfSubmission(
        linkFlairText: this.linkFlairText,
        stickied: stickied ?? this.stickied,
        authorFlairText: this.authorFlairText,
        body: body ?? this.body,
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
        voteState: voteState ?? this.voteState,
        isNSFW: isNSFW ?? this.isNSFW);
  }
}

class MediaSubmission extends Submission {
  final ExpandoMedia media;

  MediaSubmission.fromRedditLink(
      {@required RedditLink link, @required ExpandoMedia media})
      : media = media,
        super.fromRedditLink(link: link);

  @override
  List<Object> get props => [
        media,
        super.id,
        super.saved,
        super.score,
        super.voteState,
        super.edited,
        super.stickied
      ];
  MediaSubmission(
      {@required this.media,
      @required stickied,
      @required linkFlairText,
      @required authorFlairText,
      @required author,
      @required createdUtc,
      @required edited,
      @required domain,
      @required id,
      @required numComments,
      @required score,
      @required title,
      @required url,
      @required previewUrl,
      @required saved,
      @required isNSFW,
      @required subreddit,
      @required voteState})
      : super(
            linkFlairText: linkFlairText,
            stickied: stickied,
            authorFlairText: authorFlairText,
            author: author,
            createdUtc: createdUtc,
            edited: edited,
            domain: domain,
            id: id,
            numComments: numComments,
            score: score,
            title: title,
            url: url,
            previewUrl: previewUrl,
            saved: saved,
            subreddit: subreddit,
            isNSFW: isNSFW,
            voteState: voteState);

  MediaSubmission copyWith(
      {score, numComments, edited, voteState, saved, media, isNSFW, stickied}) {
    return MediaSubmission(
        linkFlairText: this.linkFlairText,
        stickied: stickied ?? this.stickied,
        authorFlairText: this.authorFlairText,
        media: media ?? this.media,
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
        voteState: voteState ?? this.voteState,
        isNSFW: isNSFW ?? this.isNSFW);
  }
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

class GetRedditLinksParams {
  final String after;
  final String subreddit;
  final SubmissionSortType sort;
  final TimeFilter filter;

  GetRedditLinksParams(
      {@required this.subreddit, this.sort, this.filter, this.after});
}
