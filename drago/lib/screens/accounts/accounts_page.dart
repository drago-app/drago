import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helius/blocs/blocs.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({
    Key key,
  }) : super(key: key);

  @override
  State<AccountsPage> createState() => AccountsPageState();
}

class AccountsPageState extends State<AccountsPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountPageBloc, AccountPageState>(
        builder: (context, AccountPageState state) {
      return CupertinoPageScaffold(
          backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
          navigationBar: CupertinoNavigationBar(
              leading: CupertinoButton(
                child: Icon(CupertinoIcons.add),
                onPressed: () =>
                    BlocProvider.of<AppBloc>(context).add(UserTappedLogin()),
              ),
              middle: Text('')),
          child: _test());
    });
  }

  Widget _rounded() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: CSSelection<int>(
          items: const <CSSelectionItem<int>>[
            CSSelectionItem<int>(text: 'Day maan', value: 0),
            CSSelectionItem<int>(text: 'Night man', value: 1),
          ],
          onSelected: (index) {
            print(index);
          },
          currentSelection: 0,
        ),
      ),
    );
  }

  Widget _test() {
    return CupertinoSettings(
      items: <Widget>[
        _rounded(),
        CSDescription(
          'Using Night mode extends battery life on devices with OLED display',
        ),
        const CSHeader(''),
        CSControl(
          nameWidget: Text('Loading...'),
          contentWidget: CupertinoActivityIndicator(),
        ),
        CSButton(CSButtonType.DEFAULT, "Licenses", () {
          print("It works!");
        }),
        const CSHeader(''),
        CSButton(CSButtonType.DESTRUCTIVE, "Delete all data", () {})
      ],
    );
  }
}
