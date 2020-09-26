import 'package:flutter/cupertino.dart';
import 'package:drago/core/entities/submission_entity.dart';
import 'package:drago/features/subreddit/get_reddit_links.dart';

class SubmissionSave extends StatelessWidget {
  final Submission submission;

  const SubmissionSave({required this.submission}) : assert(submission != null);

  @override
  Widget build(BuildContext context) {
    if (submission.saved == false) {
      return SizedBox.shrink();
    } else {
      return Container(
        child: CustomPaint(size: Size(20, 20), painter: DrawTriangle()),
      );
    }
  }
}

class DrawTriangle extends CustomPainter {
  late Paint _paint;

  DrawTriangle() {
    _paint = Paint()
      ..color = CupertinoColors.activeGreen
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.height, 0);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
