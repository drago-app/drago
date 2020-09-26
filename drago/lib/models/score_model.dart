import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils.dart';

class ScoreModel extends Equatable {
  final int score;

  ScoreModel({required this.score});
  String get asString => truncateLongInt(score);

  @override
  List<Object> get props => [score];
}
