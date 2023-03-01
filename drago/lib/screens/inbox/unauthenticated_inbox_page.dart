

import 'package:drago/blocs/app_bloc/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UnauthenticatedInboxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final containerWidth = MediaQuery.of(context).size.width * .75;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Inbox')),
        child: Center(
          child: Container(
            width: containerWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                    child: FaIcon(
                  FontAwesomeIcons.envelope,
                  size: 250,
                )),
                Text(
                  "Sign in to access your Reddit account, vote on posts, save posts, comment and much more!",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                CupertinoButton(
                  minSize: double.minPositive,
                  color: CupertinoColors.activeBlue,
                  onPressed: () {
                    BlocProvider.of<AppBloc>(context).add(UserTappedLogin());
                  },
                  child: Text('Sign In with Reddit'),
                )
              ],
            ),
          ),
        ));
  }
}
