import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import './account_page.dart';

class AccountPageBloc extends Bloc<AccountPageEvent, AccountPageState> {
  @override
  // TODO: implement initialState
  get initialState => InitialAccountPageState();

  @override
  Stream<AccountPageState> mapEventToState(AccountPageEvent event) async* {}
}
