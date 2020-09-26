// import 'package:draw/draw.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';

// enum AuthorType { Regular, Moderator, Admin, Special }

// class SubmissionAuthor extends Equatable {
//   final String name;
//   final AuthorType type;

//   @override
//   List<Object> get props => [];

//   SubmissionAuthor._({required this.name, required this.type})
//       : assert(name != null),
//         assert(type != null);

//   factory SubmissionAuthor.factory({@required Submission submission}) {
//     return SubmissionAuthor._(
//         name: submission.author,
//         type: _mapDistinguishedToAuthorType(submission.distinguished));
//   }

//   static AuthorType _mapDistinguishedToAuthorType(String distinguished) {
//     if (distinguished == 'moderator') {
//       return AuthorType.Moderator;
//     } else if (distinguished == 'admin') {
//       return AuthorType.Admin;
//     } else if (distinguished == 'special') {
//       return AuthorType.Special;
//     } else {
//       return AuthorType.Regular;
//     }
//   }
// }
