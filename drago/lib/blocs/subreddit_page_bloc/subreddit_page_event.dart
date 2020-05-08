import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:helius/core/entities/submission_entity.dart';

abstract class SubredditPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSubmissions extends SubredditPageEvent {}

class LoadMore extends SubredditPageEvent {}
