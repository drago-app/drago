

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils.dart';

class ScoreModel extends Equatable {
  final int? score;

  ScoreModel({required this.score});

  @override
  String toString() => truncateLongInt(score);

  @override
  List<Object?> get props => [score];
}
