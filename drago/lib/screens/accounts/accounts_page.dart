import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drago/blocs/blocs.dart';

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
        child: ListView(
          shrinkWrap: true,
          children: [
            _headerRow(),
          ],
        ),
      );
    });
  }

  Widget _header() {
    return Column(children: [
      Center(
          child: Text('24.8K',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      Center(child: Text('Comment', style: TextStyle(fontSize: 16))),
      Center(child: Text('Karma', style: TextStyle(fontSize: 16))),
    ]);
  }

  Widget _headerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[_header(), _header(), _header()],
    );
  }

  Widget _rounded() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            children: [
              _row(),
              _row(),
              _row(),
              _row(),
              _row(),
            ],
          )),
    );
  }

  Widget _row() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(flex: 1, child: FaIcon(FontAwesomeIcons.facebookMessenger)),
          Flexible(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(color: CupertinoColors.lightBackgroundGray),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Post'),
                      FaIcon(
                        CupertinoIcons.chevron_right,
                        color: CupertinoColors.lightBackgroundGray,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // Widget _test() {
  //   return CupertinoSettings(
  //     shrinkWrap: true,
  //     items: <Widget>[
  //       _rounded(),
  //       CSDescription(
  //         'Using Night mode extends battery life on devices with OLED display',
  //       ),
  //       const CSHeader(''),
  //       CSControl(
  //         nameWidget: Text('Loading...'),
  //         contentWidget: CupertinoActivityIndicator(),
  //       ),
  //       CSButton(CSButtonType.DEFAULT, "Licenses", () {
  //         print("It works!");
  //       }),
  //       const CSHeader(''),
  //       CSButton(CSButtonType.DESTRUCTIVE, "Delete all data", () {})
  //     ],
  //   );
  // }
}
