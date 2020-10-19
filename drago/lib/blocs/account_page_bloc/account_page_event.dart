import 'package:equatable/equatable.dart';

abstract class AccountPageEvent extends Equatable {}

class LoadUser extends AccountPageEvent {
  final String name;

  LoadUser(this.name);

  @override
  List<Object> get props => [name];
}
