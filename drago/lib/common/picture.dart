import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drago/common/common.dart';
import 'package:flutter/cupertino.dart';

class Picture extends StatelessWidget {
  final Key? key;
  final double maxHeight;
  final String url;

  Picture({required this.maxHeight, required this.url, this.key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        imageUrl: url,
        useOldImageOnUrlChange: true,
        placeholder: (context, url) => Center(child: LoadingIndicator()),
        errorWidget: (context, url, error) => Center(
            child: Icon(
          CupertinoIcons.clear,
          color: CupertinoColors.destructiveRed,
        )),
        imageBuilder: (context, ImageProvider imageProvider) {
          Size size;

          // prep
          var maxWidth = MediaQuery.of(context).size.width;
          var maxHeight = this.maxHeight;

          var newHeight;
          var newWidth;

          imageProvider.resolve(ImageConfiguration()).addListener(
            ImageStreamListener(
              (ImageInfo image, bool synchronousCall) {
                var myImage = image.image;
                size =
                    Size(myImage.width.toDouble(), myImage.height.toDouble());

                var imgWidth = size.width;
                var imgHeight = size.height;

                // calc
                var widthRatio = maxWidth / imgWidth;
                var heightRatio = maxHeight / imgHeight;
                var bestRatio = min(widthRatio, heightRatio);

                // output
                newWidth = imgWidth * bestRatio;
                newHeight = imgHeight * bestRatio;
              },
            ),
          );
          return Container(
            height: newHeight,
            width: newWidth,
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
            ),
          );
        },
      ),
    );
  }
}
