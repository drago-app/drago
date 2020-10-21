import 'package:drago/common/picture.dart';
import 'package:drago/sandbox/host.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class GalleryWidget extends StatelessWidget {
  final PageController controller = PageController();
  final GalleryMedia media;

  GalleryWidget({@required this.media});

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: controller,
        children: media.src
            .map<Widget>((src) => Center(
                    child: Picture(
                  maxHeight: MediaQuery.of(context).size.height * .8,
                  url: src.src,
                )))
            .toList());
  }
}
