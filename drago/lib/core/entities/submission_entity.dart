// import 'package:drago/classes/content_type.dart';
// import 'package:drago/models/num_comments_model.dart';
// import 'package:drago/models/score_model.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
// import 'package:drago/core/entities/preview.dart';
// import 'package:drago/core/entities/submission_author.dart';

// import '../../utils.dart';

enum VoteState { Up, Down, Neutral }

// class SubmissionModelMetaData extends Equatable {
//   final String age;
//   final String title;
//   final SubmissionAuthor author;
//   final String authorFlairText;
//   final String id;
//   final String subredditName;
//   final String upvoteRatio;
//   final ScoreModel score;

//   final bool saved;
//   final int upvotes;
//   final NumCommentsModel numComments;
//   final VoteState_ voteState;

//   SubmissionModelMetaData(
//       {@required this.age,
//       @required this.title,
//       @required this.author,
//       @required this.authorFlairText,
//       @required this.id,
//       @required this.subredditName,
//       @required this.upvoteRatio,
//       @required this.score,
//       @required this.saved,
//       @required this.upvotes,
//       @required this.numComments,
//       @required this.voteState});

//   SubmissionModelMetaData copyWith(
//       {age,
//       title,
//       author,
//       authorFlairText,
//       id,
//       subredditName,
//       upvoteRatio,
//       score,
//       saved,
//       upvotes,
//       numComments,
//       voteState}) {
//     return SubmissionModelMetaData(
//         age: age ?? this.age,
//         title: title ?? this.title,
//         author: author ?? this.author,
//         authorFlairText: authorFlairText ?? this.authorFlairText,
//         id: id ?? this.id,
//         subredditName: subredditName ?? this.subredditName,
//         upvoteRatio: upvoteRatio ?? this.upvoteRatio,
//         score: score ?? this.score,
//         upvotes: upvotes ?? this.upvotes,
//         numComments: numComments ?? this.numComments,
//         voteState: voteState ?? this.voteState,
//         saved: saved ?? this.saved);
//   }

//   @override
//   List<Object> get props => [
//         title,
//         author,
//         authorFlairText,
//         id,
//         subredditName,
//         saved,
//         upvotes,
//         score,
//         numComments,
//         upvoteRatio,
//         age,
//         voteState
//       ];
// }

// class SubmissionModel extends Equatable {
//   final SubmissionModelMetaData metaData;
//   final ContentPreview preview;
//   final SubmissionContent content;

//   String get age => metaData.age;
//   String get title => metaData.title;
//   SubmissionAuthor get author => metaData.author;
//   String get authorFlairText => metaData.authorFlairText;
//   String get id => metaData.id;
//   String get subredditName => metaData.subredditName;
//   String get upvoteRatio => metaData.upvoteRatio;
//   ScoreModel get score => metaData.score;

//   bool get saved => metaData.saved;
//   int get upvotes => metaData.upvotes;
//   NumCommentsModel get numComments => metaData.numComments;
//   VoteState_ get voteState => metaData.voteState;

//   SubmissionModel(
//       {@required this.metaData,
//       @required this.preview,
//       @required this.content});

//   @override
//   List<Object> get props => [metaData, content, preview];

//   SubmissionModel copyWith({metaData, preview, content}) {
//     return SubmissionModel(
//         metaData: metaData ?? this.metaData,
//         content: content ?? this.content,
//         preview: preview ?? this.preview);
//   }
// }

// abstract class SubmissionContent {
//   dynamic get content;
//   factory SubmissionContent({String url, String selfText}) {
//     final Type type = ContentType.getContentTypeFromURL(url);
//     // print(type);

//     if (type == Type.REDDIT) {
//       return SelfSubmissionContent(content: unescape(selfText));
//     }
//     if (type == Type.IMAGE) {
//       return ImageSubmissionContent(
//           content: EmbeddableMediaDataModel(url: url));
//     }
//     if (type == Type.GIF) {
//       return GifSubmissionContent(content: EmbeddableMediaDataModel(url: url));
//     }
//   }
// }

// class GifSubmissionContent implements SubmissionContent {
//   final EmbeddableMediaDataModel content;

//   GifSubmissionContent({@required this.content});
// }

// class SelfSubmissionContent implements SubmissionContent {
//   SelfSubmissionContent({@required this.content});

//   @override
//   final String content;
// }

// class ImageSubmissionContent implements SubmissionContent {
//   final EmbeddableMediaDataModel content;

//   ImageSubmissionContent({@required this.content});
// }

// // class VideoSubmissionContent implements SubmissionContent {

// //   @override
// //   // TODO: implement content
// //   get content => throw UnimplementedError();

// // }

// class EmbeddableMediaDataModel extends Equatable {
//   final String url;
//   final String text;
//   final bool inAlbum;

//   EmbeddableMediaDataModel(
//       {@required this.url, this.text = '', this.inAlbum = false});

//   @override
//   List<Object> get props => [url, text, inAlbum];
// }
