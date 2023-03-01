

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../utils.dart';

class NumComments extends Equatable {
  final int? numComments;

  NumComments({required this.numComments});
  @override
  String toString() => truncateLongInt(numComments);

  @override
  List<Object?> get props => [numComments];
}
