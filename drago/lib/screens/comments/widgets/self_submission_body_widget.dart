import 'package:drago/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;

class SelfSubmissionBodyWidget extends StatelessWidget {
  final String bodyText;

  SelfSubmissionBodyWidget(this.bodyText) : assert(bodyText != null);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: CupertinoTheme.of(context).barBackgroundColor,
        child: md.MarkdownBody(
            data: bodyText, styleSheet: MarkdownTheme.of(context)));
  }
}
