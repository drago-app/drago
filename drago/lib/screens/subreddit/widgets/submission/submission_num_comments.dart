import 'package:drago/common/tappable_icon_text_span.dart';
import 'package:drago/models/num_comments_model.dart';
import 'package:flutter/cupertino.dart';

class NumCommentsViewModel {
  final NumComments _numComments;
  String get value => _numComments.toString();
  NumCommentsViewModel(this._numComments);
}

class NumCommentsWidget extends TappableIconTextSpan {
  final NumCommentsViewModel numCommentsViewModel;
  NumCommentsWidget(this.numCommentsViewModel)
      : super(
            icon: Icon(CupertinoIcons.chat_bubble,
                color: CupertinoColors.darkBackgroundGray.withOpacity(.7),
                size: 14),
            text: numCommentsViewModel.value,
            style: TextStyle(
                color: CupertinoColors.darkBackgroundGray.withOpacity(.7)));

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
