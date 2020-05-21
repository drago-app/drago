import 'package:drago/common/picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:drago/screens/subreddit/widgets/media_viewer/media_view_bottom_row.dart';

class MediaViewerOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 100);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => CupertinoColors.black.withOpacity(1);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  // final SubmissionModel submission;
  final Bloc bloc;

  MediaViewerOverlay({@required this.bloc}) : assert(bloc != null);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return SafeArea(
      top: false,
      child: BlocBuilder(
          bloc: bloc,
          builder: (context, state) => _buildOverlayContent(context, state)),
    );
  }

  Widget _buildOverlayContent(BuildContext context, state) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: MediaViewerBottomRow(
              submission: state.submission,
              bloc: bloc,
            ),
          ),
        ),
        Hero(
          tag: state.submission,
          child: Picture(
              maxHeight: MediaQuery.of(context).size.height,
              url: state.submission.preview.thumbnailUrl),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: CupertinoButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(CupertinoIcons.add),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
