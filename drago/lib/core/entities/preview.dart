// import 'package:draw/draw.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
// import 'package:drago/classes/content_type.dart';

// enum ImageSourceType { IMAGE, GIF, VIDEO, LINK, NSFW, NONE }

// const placeholder = 'https://via.placeholder.com/150';

// class ImageModel extends Equatable {
//   final int height;
//   final int width;
//   final String url;

//   ImageModel({required this.height, required this.width, required this.url});
//   @override
//   List<Object> get props => [height, width, url];
// }

// class ContentPreview {
//   final String thumbnailUrl;
//   final ImageSourceType sourceType;

//   ContentPreview._({required this.thumbnailUrl, required this.sourceType});
//   factory ContentPreview.factory({Submission submission}) {
//     Type type = ContentType.getContentTypeFromSubmission(submission);

//     if (type == Type.YouTube) {
//       return ContentPreview._(
//           sourceType: ImageSourceType.VIDEO,
//           thumbnailUrl: urlOrPlaceholder(submission.thumbnail.toString()));
//     } else if (type == Type.IMAGE || type == Type.IMGUR) {
//       return ContentPreview._(
//           sourceType: ImageSourceType.IMAGE,
//           thumbnailUrl: submission.url.toString());
//     } else if (type == Type.VREDDIT_DIRECT || type == Type.VREDDIT_REDIRECT) {
//       return ContentPreview._(
//           sourceType: ImageSourceType.VIDEO,
//           thumbnailUrl: submission.thumbnail.toString());
//     } else if (type == Type.LINK) {
//       return ContentPreview._(
//           sourceType: ImageSourceType.LINK,
//           thumbnailUrl: urlOrPlaceholder(submission.thumbnail.toString()));
//     } else if (type == Type.GIF) {
//       return ContentPreview._(
//           sourceType: ImageSourceType.GIF,
//           thumbnailUrl: submission.thumbnail.toString());
//     } else {
//       return ContentPreview._(
//           sourceType: ImageSourceType.NONE, thumbnailUrl: placeholder);
//     }
//   }

//   static bool isUrl(String url) {
// //     const urlPattern = r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
// // var match = new RegExp(urlPattern, caseSensitive: false).firstMatch('https://www.google.com');
// // match = RegExp(urlPattern, caseSensitive: false).firstMatch('http://www.google.com');

//     return Uri.parse(url ?? '').isAbsolute;
//   }

//   static String urlOrPlaceholder(String url) {
//     return (isUrl(url)) ? url : placeholder;
//   }
// }
