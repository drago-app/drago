import 'package:drago/blocs/app_bloc/app_bloc.dart';
import 'package:drago/blocs/app_bloc/app_event.dart';
import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CupertinoLogInAlert extends CupertinoAlertDialog {
  final BuildContext context;
  final String titleText;
  final String contentText;
  final onDismiss;

  CupertinoLogInAlert(
      {@required this.context,
      this.titleText,
      this.contentText,
      this.onDismiss});
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
            onDismiss();
            debugPrint(
                'Hey you clicked the Create New Account button but that shit isn\t implemented so just fucking chill for a little bit.');
          },
          child: Text('Create New Account'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss();
          },
          child: Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ];
}
