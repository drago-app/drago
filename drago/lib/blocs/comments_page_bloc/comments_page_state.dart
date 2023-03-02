import 'package:equatable/equatable.dart';

abstract class CommentsPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class CommentsPageInitial extends CommentsPageState {
  CommentsPageInitial();
}

class CommentsLoaded extends CommentsPageState {
  final List comments;

  CommentsLoaded({required this.comments});
  List<Object> get props => [comments];
}
