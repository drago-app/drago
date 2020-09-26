import 'package:drago/blocs/blocs.dart';
import 'package:drago/models/comment_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ContinueThreadWidget extends StatelessWidget {
  final ContinueThreadModel continueThread;

  ContinueThreadWidget({required this.continueThread});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => null,
      // onTap: () => BlocProvider.of<CommentsPageBloc>(context)
      //     .add(ExpandComment(widget.moreComments)),
      child: Padding(
        padding: EdgeInsets.only(right: 0, left: continueThread.depth * 8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: CupertinoColors.darkBackgroundGray, width: 0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      width: 3,
                      color: continueThread.depth > 0
                          ? CupertinoColors.destructiveRed
                          : CupertinoColors.lightBackgroundGray.withOpacity(0)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 4,
                  right: 4,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      'Continue thread ...',
                      style: TextStyle(color: CupertinoColors.systemBlue),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* -----------*/

class MoreCommentsWidget extends StatefulWidget {
  final MoreCommentsModel moreComments;

  MoreCommentsWidget(this.moreComments);
  @override
  _MoreCommentsState createState() => _MoreCommentsState();
}

class _MoreCommentsState extends State<MoreCommentsWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BlocProvider.of<CommentsPageBloc>(context)
          .add(ExpandComment(widget.moreComments)),
      child: Padding(
        padding:
            EdgeInsets.only(right: 0, left: widget.moreComments.depth * 8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: CupertinoColors.darkBackgroundGray, width: 0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      width: 3,
                      color: widget.moreComments.depth > 0
                          ? CupertinoColors.destructiveRed
                          : CupertinoColors.lightBackgroundGray.withOpacity(0)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 4,
                  right: 4,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      '${widget.moreComments.numReplies} more replies',
                      style: TextStyle(color: CupertinoColors.systemBlue),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
