import 'package:draw/draw.dart';
import 'package:flutter/material.dart';

class MoreCommentsWidget extends StatefulWidget {
  final MoreComments moreComments;
  final parent;

  MoreCommentsWidget(this.moreComments, {this.parent});
  @override
  _MoreCommentsState createState() => _MoreCommentsState();
}

class _MoreCommentsState extends State<MoreCommentsWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        // onTap: () => bloc.loadMoreComments(widget.moreComments),
        child: Padding(
          padding: EdgeInsets.only(right: 0, left: _depth(widget.parent) * 4.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        width: 3,
                        color: _depth(widget.parent) > 0
                            ? Colors.red
                            : Colors.transparent),
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
                        '${widget.moreComments.count} more replies',
                        style: TextStyle(color: Colors.blue),
                      ),
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

  int _depth(parent) {
    if (parent is Comment) {
      return parent.depth + 1;
    } else {
      return 0;
    }
  }
}
