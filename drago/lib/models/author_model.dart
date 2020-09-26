import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AuthorModel extends Equatable {
  final String name;
  final Color color;

  const AuthorModel({required this.name, required this.color});

  @override
  List<Object> get props => [name, color];
}
