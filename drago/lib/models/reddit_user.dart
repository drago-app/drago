import 'package:equatable/equatable.dart';

class RedditUser extends Equatable {
  final String displayName;
  final int postKarma;
  final int commentKarma;
  final DateTime createdOn;

  RedditUser(
      {required this.displayName,
      required this.postKarma,
      required this.commentKarma,
      required this.createdOn});

  @override
  List<Object> get props => [displayName, postKarma, commentKarma, createdOn];

  @override
  String toString() {
    return "[RedditUser] $displayName $postKarma $commentKarma $createdOn";
  }
}
