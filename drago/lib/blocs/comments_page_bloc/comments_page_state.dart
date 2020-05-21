import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';

abstract class CommentsPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class CommentsPageInitial extends CommentsPageState {
  CommentsPageInitial();
}

class CommentsLoaded extends CommentsPageState {
  final List comments;

  CommentsLoaded({@required this.comments});
  List<Object> get props => [comments];
}
