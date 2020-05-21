import 'package:drago/blocs/app_bloc/app_bloc.dart';
import 'package:drago/blocs/app_bloc/app_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CupertinoLogInAlert extends CupertinoAlertDialog {
  final BuildContext context;
  final String titleText;
  final String contentText;
  // final Function(BuildContext) logInFunction = (context) {
  //   print('a');
  //   Navigator.of(context).pop();
  //   print('b');

  //   BlocProvider.of<AppBloc>(context).add(UserTappedLogin());
  //   print('c');
  // };

  CupertinoLogInAlert(
      {@required this.context, this.titleText, this.contentText});
  @override
  Widget get title => Text(titleText ?? '');
  @override
  Widget get content => Text(contentText ?? '');
  List<Widget> get actions => <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
            BlocProvider.of<AppBloc>(context).add(UserTappedLogin());
          },
          child: Text('Sign In'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
            debugPrint(
                'Hey you clicked the Create New Account button but that shit isn\t implemented so just fucking chill for a little bit.');
          },
          child: Text('Create New Account'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ];
}
