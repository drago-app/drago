import 'package:bloc/bloc.dart';
import './account_page.dart';

class AccountPageBloc extends Bloc<AccountPageEvent, AccountPageState> {
  AccountPageBloc() : super(AccountPageInitial());

  // @override
  // get initialState => AccountPageInitial;

  @override
  Stream<AccountPageState> mapEventToState(AccountPageEvent event) {
    return _map();
  }

  Stream<AccountPageInitial> _map() async* {}
}
