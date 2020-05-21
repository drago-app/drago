import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils.dart';

class NumCommentsModel extends Equatable {
  final int numComments;

  NumCommentsModel({@required this.numComments});
  String get asString => truncateLongInt(numComments);

  @override
  List<Object> get props => [numComments];
}
