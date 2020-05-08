import 'package:flutter/foundation.dart';
import 'package:helius/classes/content_type.dart';
import 'package:helius/classes/image_model.dart';
import 'package:helius/classes/xkcd_provider.dart';

class ImageFetcher {
  static Future<ImageModel> fetch({@required url}) async {
    print('FROM IMAGE FETCHER -- $url');

    if (ContentType.isXkcd(url)) {
      final xkcd = XkcdApiProvider();
      final response = await xkcd.fetchXkcd(url: url);
      return ImageModel(url: response.img);
    } else if (ContentType.isImgurLink(url)) {
      url = url.replaceAll('imgur.com', 'i.imgur.com');
      url += '.png';
      print('IMAGEFETCHER ---- $url');
      return ImageModel(url: url);
    } else {
      // if (ContentType.isImage(Uri.parse(url))) {
      return ImageModel(url: url);
    }
  }
}
