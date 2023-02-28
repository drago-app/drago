import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

typedef RegExpMatch Detect(String url);
typedef Future<ExpandoMedia> HandleLink(String href, RegExpMatch detectResult);
typedef Future<VideoData> GetVideoData(String id);

class Host {
  static List<Host> hosts = [
    defaultHost,
    defaultVideo,
    defaultGifHost,
    imgurAlbumHost,
    imgurGifvHost
  ];
  final String moduleId;
  final String name;
  final List<String> domains;
  final Detect detect;
  final HandleLink handleLink;
  final GetVideoData getVideoData;

  Host({
    @required this.moduleId,
    @required this.name,
    @required this.domains,
    @required this.detect,
    @required this.handleLink,
    this.getVideoData,
  });
  static Stream<Host> _getHost(String url) async* {
    for (var host in hosts) {
      if (host.detect(url) is RegExpMatch) {
        yield host;
      }
    }
  }

  static Stream<ExpandoMedia> _getMedia(Stream<Host> hosts, String url) async* {
    yield* hosts.asyncMap((host) => host.handleLink(url, host.detect(url)));
  }

  static Stream<ExpandoMedia> getMedia(String url) async* {
    yield* _getMedia(_getHost(url), url);
  }
}

class VideoData {
  final String title;
  final String duration;
  final String publishedAt;
  final String viewCount;
  VideoData({this.title, this.duration, this.publishedAt, this.viewCount});
}

enum ExpandoMediaType { Gallery, Image, Video, Audio, Text, Iframe, Generic }

abstract class MediaVisitor {
  visitGalleryMedia(GalleryMedia media);
  visitImageMedia(ImageMedia media);
  visitVideoMedia(VideoMedia media);
  visitGifMedia(GifMedia media);
  visitAudioMedia(AudioMedia media);
  visitGenericMedia(GenericaMedia media);
  visitIframeMedia(IframeMedia media);
}

abstract class ExpandoMedia {
  static ExpandoMediaType type;
  String get title;
  accept(MediaVisitor vistor);
}

class GalleryMedia implements ExpandoMedia {
  static ExpandoMediaType type = ExpandoMediaType.Gallery;
  int get size => src.length;
  final String title;
  final String caption;
  final String credits;
  final List<ExpandoMedia> src;
  GalleryMedia({this.title, this.caption, this.credits, this.src});
  accept(MediaVisitor visitor) => visitor.visitGalleryMedia(this);
}

class ImageMedia implements ExpandoMedia {
  static ExpandoMediaType type = ExpandoMediaType.Image;
  final String title;
  final String caption;
  final String credits;
  final String src;
  final String href;
  ImageMedia(
      {this.title, this.caption, this.credits, @required this.src, this.href});
  accept(MediaVisitor visitor) => visitor.visitImageMedia(this);
}

class GifMedia implements ExpandoMedia {
  static ExpandoMediaType type = ExpandoMediaType.Image;
  final String title;
  final String caption;
  final String credits;
  final String src;
  final String href;
  GifMedia(
      {this.title, this.caption, this.credits, @required this.src, this.href});

  accept(MediaVisitor visitor) => visitor.visitGifMedia(this);
}

class VideoMedia implements ExpandoMedia {
  // https://github.com/honestbleeps/Reddit-Enhancement-Suite/blob/60b97e46a133b502cd0e44aa6830b1296cc4be62/lib/core/host.js
  static ExpandoMediaType type = ExpandoMediaType.Video;
  final String title;
  final String caption;
  final String credits;
  final String fallback;
  final String href;
  final String source;
  final String poster;
  final bool muted;
  final num frameRate;
  final bool loop;
  final num playbackRate;
  final bool reversable;
  final bool reversed;
  final num time;
  final List<VideoMediaSource> sources;

  VideoMedia(
      {this.title,
      this.caption,
      this.credits,
      this.fallback,
      this.href,
      this.source,
      this.poster,
      this.muted,
      this.frameRate,
      this.loop,
      this.playbackRate,
      this.reversable,
      this.reversed,
      this.time,
      @required this.sources});

  accept(MediaVisitor visitor) => visitor.visitVideoMedia(this);
}

class VideoMediaSource {
  final String source;
  final String reverse;
  final String type;

  VideoMediaSource({@required this.source, this.reverse, @required this.type});
}

class AudioMedia implements ExpandoMedia {
  static ExpandoMediaType type = ExpandoMediaType.Audio;
  final bool autoplay;
  final bool loop;
  final String title;
  final List<AudioMediaSrc> sources;

  AudioMedia({this.autoplay, this.loop, this.sources, this.title = ''});

  accept(MediaVisitor visitor) => visitor.visitAudioMedia(this);
}

class AudioMediaSrc {
  final String file;
  final String type;

  AudioMediaSrc({@required this.file, @required this.type});
}

class IframeMedia implements ExpandoMedia {
  static ExpandoMediaType type = ExpandoMediaType.Iframe;
  final bool muted;
  final String expandoClass;
  final String embed;
  final String embedAutoplay;
  final String width;
  final String height;
  final bool fixedRatio;
  final String pause;
  final String play;
  final String title;

  IframeMedia(
      {this.muted,
      this.expandoClass,
      @required this.embed,
      this.embedAutoplay,
      this.width,
      this.height,
      this.fixedRatio,
      this.pause,
      this.title = '',
      this.play});
  accept(MediaVisitor visitor) => visitor.visitIframeMedia(this);
}

class GenericaMedia implements ExpandoMedia {
  //https://github.com/honestbleeps/Reddit-Enhancement-Suite/blob/60b97e46a133b502cd0e44aa6830b1296cc4be62/lib/core/host.js
  static ExpandoMediaType type = ExpandoMediaType.Generic;
  final bool muted;
  final String expandoClass;
  final String title;

  GenericaMedia({this.muted, this.expandoClass, this.title = ''});
  accept(MediaVisitor visitor) => visitor.visitGenericMedia(this);

  //generate: () => HTMLElement;
  // onAttach?: () => void;
}

final Host defaultHost = Host(
  moduleId: 'default',
  name: 'default',
  domains: [],
  detect: (String url) => RegExp(r'\.(jpe?g|png|svg)$').firstMatch(url),
  handleLink: (String href, _) => Future.value(ImageMedia(src: href)),
);

final Host defaultGifHost = Host(
  moduleId: 'default',
  name: 'default',
  domains: [],
  detect: (String url) => RegExp(r'\.(gif)$').firstMatch(url),
  handleLink: (String href, _) => Future.value(GifMedia(src: href)),
);

final Host defaultVideo = Host(
  moduleId: 'defaultVideo',
  name: 'defaultVideo',
  domains: [],
  detect: (String url) => RegExp(r'\.(webm|mp4|ogv|3gp|mkv)$').firstMatch(url),
  handleLink: (String href, RegExpMatch detectResult) {
    // convert ogv to ogg?
    //https://github.com/honestbleeps/Reddit-Enhancement-Suite/blob/60b97e46a133b502cd0e44aa6830b1296cc4be62/lib/modules/hosts/defaultVideo.js
    final extension = detectResult.group(1);
    final format = 'video/$extension';

    return Future.value(
      VideoMedia(
        sources: [
          VideoMediaSource(source: href, type: format),
        ],
      ),
    );
  },
);

final imgurGifvHost = Host(
    moduleId: 'imgur',
    domains: ['imgur.com'],
    detect: (url) {
      final regex = r'imgur.com\/([a-zA-Z0-9]{3,7})(\.gifv)';
      return RegExp(regex).firstMatch(url);
    },
    handleLink: (url, detectResult) {
      return Future.value(
        VideoMedia(
          sources: [
            VideoMediaSource(
              type: 'video/mp4',
              source: url.replaceAll('.gifv', '.mp4'),
            )
          ],
        ),
      );
    });

final Host imgurAlbumHost = Host(
    moduleId: 'imgur',
    domains: ['imgur.com'],
    detect: (url) {
      final albumRegex = r'(?!m.|www.)imgur.com\/a\/([a-zA-Z0-9]{7})';
      final galleryRegex = r'(?!m.|www.)imgur.com\/gallery\/([a-zA-Z0-9]{7})';

      if (RegExp(albumRegex).firstMatch(url) != null) {
        return RegExp(albumRegex).firstMatch(url);
      }
      if (RegExp(galleryRegex).firstMatch(url) != null) {
        return RegExp(galleryRegex).firstMatch(url);
      }
    },
    handleLink: (href, detectResult) async {
      final src = (hash, ext) => 'https://imgur.com/${hash}m${ext ?? '.png'}';

      var response = await http.get(Uri(
          scheme: "http",
          host: "imgur.com",
          path:
              "/ajaxalbums/getimages/${detectResult.group(1)}/hit.json?all=true"));

      var body = jsonDecode(response.body);

      List<ExpandoMedia> images = body['data']['images']
          .map<ExpandoMedia>(
            (i) => ImageMedia(
                src: src(i['hash'], i['ext']), title: i['description']),
          )
          .toList();
      return images.length == 1 ? images.first : GalleryMedia(src: images);
    }
    // logo: 'https://i.imgur.com/favicon.ico',
    );
