import 'package:dartz/dartz.dart';

typedef RegExpMatch? Detect(String url);
typedef Future<ExpandoMedia> HandleLink(String href, RegExpMatch? detectResult);
typedef Future<VideoData> GetVideoData(String id);

class Host {
  final String moduleId;
  final String name;
  final List<String> domains;
  final Detect detect;
  final HandleLink handleLink;
  final GetVideoData? getVideoData;

  Host({
    required this.moduleId,
    required this.name,
    required this.domains,
    required this.detect,
    required this.handleLink,
    this.getVideoData,
  });

  static List<Host> hosts = [defaultHost, defaultVideo];

  static Option<Host> getHost(url) {
    List<Host> x =
        hosts.where((host) => host.detect(url) is RegExpMatch).toList();
    return catching(() => x.first).toOption();
  }

  static Future<Option<ExpandoMedia>> getMedia(Host host, String url) async {
    final ExpandoMedia media = await host.handleLink(url, host.detect(url));
    return optionOf(media);
  }
}

class VideoData {
  final String? title;
  final String? duration;
  final String? publishedAt;
  final String? viewCount;
  VideoData({this.title, this.duration, this.publishedAt, this.viewCount});
}

enum ExpandoMediaType { Gallery, Image, Video, Audio, Text, Iframe, Generic }

abstract class ExpandoMedia {
  static ExpandoMediaType type = ExpandoMediaType.Generic;
}

class GalleryMedia implements ExpandoMedia {
  static ExpandoMediaType type = ExpandoMediaType.Gallery;
  final String title;
  final String caption;
  final String credits;
  final List<ExpandoMedia> src;
  GalleryMedia({
    required this.title,
    required this.caption,
    required this.credits,
    required this.src,
  });
}

class ImageMedia implements ExpandoMedia {
  static ExpandoMediaType type = ExpandoMediaType.Image;
  final String? title;
  final String? caption;
  final String? credits;
  final String src;
  final String? href;
  ImageMedia({
    this.title,
    this.caption,
    this.credits,
    required this.src,
    this.href,
  });
}

class VideoMedia implements ExpandoMedia {
  // https://github.com/honestbleeps/Reddit-Enhancement-Suite/blob/60b97e46a133b502cd0e44aa6830b1296cc4be62/lib/core/host.js
  static ExpandoMediaType type = ExpandoMediaType.Video;
  final String? title;
  final String? caption;
  final String? credits;
  final String? fallback;
  final String? href;
  final String? source;
  final String? poster;
  final bool? muted;
  final num? frameRate;
  final bool? loop;
  final num? playbackRate;
  final bool? reversable;
  final bool? reversed;
  final num? time;
  final List<VideoMediaSource> sources;

  VideoMedia({
    this.title,
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
    required this.sources,
  });
}

class VideoMediaSource {
  final String source;
  final String? reverse;
  final String type;

  VideoMediaSource({required this.source, this.reverse, required this.type});
}

class AudioMedia implements ExpandoMedia {
  static ExpandoMediaType type = ExpandoMediaType.Audio;
  final bool autoplay;
  final bool loop;
  final List<AudioMediaSrc> sources;

  AudioMedia(
      {required this.autoplay, required this.loop, required this.sources});
}

class AudioMediaSrc {
  final String file;
  final String type;

  AudioMediaSrc({required this.file, required this.type});
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

  IframeMedia({
    required this.muted,
    required this.expandoClass,
    required this.embed,
    required this.embedAutoplay,
    required this.width,
    required this.height,
    required this.fixedRatio,
    required this.pause,
    required this.play,
  });
}

class GenericaMedia implements ExpandoMedia {
  //https://github.com/honestbleeps/Reddit-Enhancement-Suite/blob/60b97e46a133b502cd0e44aa6830b1296cc4be62/lib/core/host.js
  static ExpandoMediaType type = ExpandoMediaType.Generic;
  final bool muted;
  final String expandoClass;

  GenericaMedia({required this.muted, required this.expandoClass});
  //generate: () => HTMLElement;
  // onAttach?: () => void;

}

final Host defaultHost = Host(
  moduleId: 'default',
  name: 'default',
  domains: [],
  detect: (String url) => RegExp(r'\.(gif|jpe?g|png|svg)$').firstMatch(url),
  handleLink: (String href, _) => Future.value(ImageMedia(src: href)),
);

final Host defaultVideo = Host(
  moduleId: 'defaultVideo',
  name: 'defaultVideo',
  domains: [],
  detect: (String url) => RegExp(r'\.(webm|mp4|ogv|3gp|mkv)$').firstMatch(url),
  handleLink: (String href, RegExpMatch? detectResult) {
    // convert ogv to ogg?
    //https://github.com/honestbleeps/Reddit-Enhancement-Suite/blob/60b97e46a133b502cd0e44aa6830b1296cc4be62/lib/modules/hosts/defaultVideo.js
    final extension = detectResult?.group(1);
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
