import 'package:flutter/foundation.dart';
import 'package:helius/classes/content_type.dart';
import 'package:helius/classes/gfycat_provider.dart';
import 'package:helius/classes/video_model.dart';

class VideoFetcher {
  static Future<VideoModel> fetch({@required url}) async {
    print('FROM VIDEO FETCHER -- $url');

    if (ContentType.isGfycat(Uri.parse(url))) {
      final gfycat = GfycatApiProvider();
      final response = await gfycat.fetchGfycat(url: url);
      print('FROM VIDEO FETCHER -- ${response.gfycatItem.mp4URL}');

      return VideoModel(url: response.gfycatItem.mp4URL);
    } else if (ContentType.getContentTypeFromURL(url) ==
        Type.VREDDIT_REDIRECT) {
      if (!url.endsWith('/')) {
        url += "/";
      }

      // I dont know if this is a good way to handle this case.
      // It's possible that not all videos of this type have a DASH_360 version
      // I have seen some with DASH_720, but not all have that.
      url += "DASH_360";
      return VideoModel(url: url);
    } else {
      // This case is also kind of wonky.
      // Gifs don't play well with Chewie.
      // So I need to find a good way to deal with this too

      if (url.endsWith('gifv')) {
        url = url.replaceAll("gifv", 'mp4');
      }

      return VideoModel(url: url);
    }
  }
}
