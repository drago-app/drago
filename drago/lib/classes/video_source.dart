import 'package:flutter/foundation.dart';
import 'package:helius/classes/gfycat_model.dart';
import 'package:http/http.dart' show Client;

import 'dart:convert';

import 'dart:io';

enum VideoType { DIRECT, IMGUR, VID_ME, STREAMABLE, GFYCAT, REDDIT, OTHER }

class VideoTypeHelper {
  static VideoType fromPath({@required String url}) {
    if (url.contains(".mp4") ||
        url.contains("webm") ||
        url.contains("redditmedia.com") ||
        (url.contains("preview.redd.it") && url.contains("format=mp4"))) {
      return VideoType.DIRECT;
    }
    if (url.contains("gfycat") && !url.contains("mp4")) {
      return VideoType.GFYCAT;
    }
    if (url.contains("v.redd.it")) {
      return VideoType.REDDIT;
    }
    if (url.contains("imgur.com")) {
      return VideoType.IMGUR;
    }
    if (url.contains("vid.me")) {
      return VideoType.VID_ME;
    }
    if (url.contains("streamable.com")) {
      return VideoType.STREAMABLE;
    }
    return VideoType.OTHER;
  }

  static VideoSource getSourceObject(VideoType type) {
    switch (type) {
      case VideoType.DIRECT:
        return DirectVideoSource();
      case VideoType.IMGUR:
        return DirectVideoSource();
      case VideoType.VID_ME:
        return VidMeVideoSource();

      case VideoType.STREAMABLE:
        return StreamableVideoSource();

      // case VideoType.GFYCAT:
      //   return GfycatVideoSource();

      case VideoType.REDDIT:
        return RedditVideoSource();
      case VideoType.OTHER:
        return DirectVideoSource();
      default:
        {
          return DirectVideoSource();
        }
    }
  }
}

abstract class VideoSource {
  load({@required String url, @required Function completion, Function failure});
}

class DirectVideoSource implements VideoSource {
  load(
      {@required String url, @required Function completion, Function failure}) {
    var finalURL = url;
    if (finalURL.contains("imgur.com")) {
      finalURL = finalURL.replaceAll(".gifv", ".mp4");
      finalURL = finalURL.replaceAll(".gif", ".mp4");
    }
    completion(finalURL);
    // return nil
  }
}

// class GfycatVideoSource implements VideoSource {
//   final Client _client = Client();

//   load(
//       {@required String url,
//       @required Function completion,
//       Function failure}) async {
//     var name = url.substring(url.lastIndexOf("/"),
//         url.length - url.lastIndexOf("/")); //? this may be incorrect
//     if (!name.startsWith("/")) {
//       name = "/" + name;
//     }
//     if (name.contains("-")) {
//       name = name.split("-")[0];
//     }
//     name = name.split(".")[0];
//     final finalURL = Uri.parse("https://api.gfycat.com/v1/gfycats$name");
//     print('GFYCAT URL --- $finalURL');

//     var response;
//     try {
//       response = await _client.get(finalURL);
//     } on SocketException {
//       print('There was no internet to be had...');
//     }

//     if (response.statusCode == 200) {
//       final gif = GfycatModel.fromJson(json.decode(response.body));
//       completion(gif.mp4URL);
//     } else {
//       print('[GfycatVideoSource] status code: ${response.statusCode}');
//     }

// let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
//     if error != nil {
//         print(error ?? "Error loading gif...")
//         DispatchQueue.main.async {
//             failure?()
//         }
//     } else {
//         do {
//             guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
//                 return
//             }

//             if json["errorMessage"] != nil {
//                 DispatchQueue.main.async {
//                     failure?()
//                 }
//                 return
//             }

//             let gif = GfycatJSONBase.init(dictionary: json)

//             DispatchQueue.main.async {
//                 completion((gif?.gfyItem?.mp4Url)!)
//             }
//         } catch let error as NSError {
//             print(error)
//         }
//     }

// }
// dataTask.resume()
// return dataTask
//   }
// }

class RedditVideoSource implements VideoSource {
  load(
      {@required String url, @required Function completion, Function failure}) {
    final muxedURL = url;
    completion(muxedURL);
  }
}

class StreamableVideoSource implements VideoSource {
  final Client _client = Client();

  load(
      {@required String url,
      @required Function completion,
      Function failure}) async {
    var hash = url.substring(
        url.lastIndexOf("/") + 1, url.length - (url.lastIndexOf("/") + 1));

    final finalURL = Uri.parse("https://api.streamable.com/videos/" + hash);
    print('STREAMABLE URL --- $finalURL');

    var response;
    try {
      response = await _client.get(finalURL);
    } on SocketException {
      print('There was no internet to be had...');
    }
    // TODO Map the Streamable api response
    // if (response.statusCode == 200) {
    //   final gif = GfycatItem.fromJson(json.decode(response.body));
    //   completion(gif.mp4URL);

    // } else {
    //     print('[StreamableVideoSource] status code: ${response.statusCode}');
    // }

    // let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
    //     if error != nil {
    //         print(error ?? "Error loading gif...")
    //         failure?()
    //     } else {
    //         do {
    //             guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
    //                 return
    //             }

    //             let gif = StreamableJSONBase.init(dictionary: json)

    //             DispatchQueue.main.async {
    //                 var video = ""
    //                 if let url = gif?.files?.mp4mobile?.url {
    //                     video = url
    //                 }

    //                 if video.isEmpty() {
    //                     video = (gif?.files?.mp4?.url!)!
    //                 }
    //                 if video.hasPrefix("//") {
    //                     video = "https:" + video
    //                 }
    //                 completion(video)
    //             }
    //         } catch let error as NSError {
    //             print(error)
    //         }
    //     }
    // }
    // dataTask.resume()
    // return dataTask
  }
}

class VidMeVideoSource implements VideoSource {
  final Client _client = Client();

  load(
      {@required String url,
      @required Function completion,
      Function failure}) async {
    var finalURL = Uri.parse("https://api.vid.me/videoByUrl?url=" + url);
    print('VIDME URL --- $finalURL');

    var response;
    try {
      response = await _client.get(finalURL);
    } on SocketException {
      print('There was no internet to be had...');
    }
    // TODO Map the VidMe api response
    // if (response.statusCode == 200) {
    //   final gif = GfycatItem.fromJson(json.decode(response.body));
    //   completion(gif.mp4URL);

    // } else {
    //     print('[VidMeVideoSource] status code: ${response.statusCode}');
    // }
  }
}
