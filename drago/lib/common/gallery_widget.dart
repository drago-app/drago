import 'package:drago/common/picture.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class GalleryWidget extends StatelessWidget {
  final PageController controller;
  final GalleryMedia media;

  GalleryWidget({@required this.media, @required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
    // return PageView(
    //     controller: controller,
    //     children: media.src
    //         .map<Widget>((src) => Center(
    //               child: Column(
    //                 children: [
    //                   Picture(
    //                     maxHeight: MediaQuery.of(context).size.height * .8,
    //                     url: src.src,
    //                   ),
    //                   Text(src.title)
    //                 ],
    //               ),
    //             ))
    //         .toList());
  }
}

class GalleryPageIndicator extends StatefulWidget {
  final num total;
  final PageController controller;

  GalleryPageIndicator({@required this.total, @required this.controller})
      : assert(controller != null),
        assert(total != null);

  @override
  State<StatefulWidget> createState() => GalleryPageIndicatorState();
}

class GalleryPageIndicatorState extends State<GalleryPageIndicator> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(current + 1).toString()} / ${widget.total.toString()}',
      style:
          defaultTextStyle.copyWith(color: CupertinoColors.white, fontSize: 18),
    );
  }

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        current = widget.controller.page.toInt();
      });
    });
    super.initState();
  }
}

class GalleryPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
