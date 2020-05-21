import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils.dart';

class ScoreModel extends Equatable {
  final int score;

  ScoreModel({@required this.score});
  String get scoreAsString => truncateLongInt(score);

  @override
  // TODO: implement props
  List<Object> get props => [score];
}
