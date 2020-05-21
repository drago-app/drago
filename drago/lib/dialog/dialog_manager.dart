import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'alert_request.dart';
import 'alert_response.dart';
import 'dialog_service.dart';

class DialogManager extends StatefulWidget {
  final DialogService dialogService;
  final Widget child;
  DialogManager({Key key, this.child, @required this.dialogService})
      : super(key: key);
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  // @override
  // didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    super.initState();

    widget.dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(AlertRequest request) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('${request.title}'),
        content: Text('${request.description}'),
        actions: [
          CupertinoButton(
            child: Text('${request.buttonTitle}'),
            onPressed: () {
              widget.dialogService
                  .dialogComplete(AlertResponse(confirmed: true));
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    print('[DialogManager] ...disposed');
    super.dispose();
  }
}
