// package me.ccrama.redditslide;

// import android.content.Context;
// import android.content.Intent;
// import android.content.pm.PackageManager;
// import android.content.res.Resources;
// import android.net.Uri;

// import net.dean.jraw.models.Submission;

// import java.net.URI;
// import java.net.URISyntaxException;
// import java.util.HashMap;
// import java.util.Locale;

import 'package:draw/draw.dart';

enum Type {
  ALBUM,
  DEVIANTART,
  EMBEDDED,
  EXTERNAL,
  GIF,
  VREDDIT_DIRECT,
  VREDDIT_REDIRECT,
  IMAGE,
  IMGUR,
  LINK,
  NONE,
  REDDIT,
  SELF,
  SPOILER,
  STREAMABLE,
  TABLE,
  VIDEO,
  XKCD,
  TUMBLR,
  VID_ME,
  YouTube
}
enum ThumbnailType { NSFW, DEFAULT, SELF, NONE, URL }
Map<ThumbnailType, String> thumbnailTypeToString = {
  ThumbnailType.NSFW: 'nswf',
  ThumbnailType.DEFAULT: 'default',
  ThumbnailType.SELF: 'self',
  ThumbnailType.NONE: '',
  ThumbnailType.URL: 'url'
};

class ContentType {
  ///
  /// Checks if {@code host} is contains by any of the provided {@code bases}
  /// <p/>
  /// For example "www.youtube.com" contains "youtube.com" but not "notyoutube.com" or
  /// "youtube.co.uk"
  ///
  /// @param host  A hostname from e.g. {@link URI#getHost()}
  /// @param bases Any number of hostnames to compare against {@code host}
  /// @return If {@code host} contains any of {@code bases}
  ///

  static bool hostContains(String host, List<String> bases) {
    if (host == null || host.isEmpty) return false;

    for (String base in bases) {
      if (base == null || base.isEmpty) continue;

      final int index = host.lastIndexOf(base);
      if (index < 0 || index + base.length != host.length) continue;
      if (base.length == host.length || host[index - 1] == '.') return true;
    }

    return false;
  }

  static bool isSpoiler(String url) {
    if (!url.startsWith("//") &&
        ((url.startsWith("/") && url.length < 4) ||
            url.startsWith("#spoil") ||
            url.startsWith("/spoil") ||
            url.startsWith("#s-") ||
            url == ("#s") ||
            url == ("#ln") ||
            url == ("#b") ||
            url == ("#sp"))) {
      return true;
    }
    return false;
  }

  static bool isTable(Uri uri) {
    final String uriString = uri.toString();
    if (uriString.contains("http://view.table/")) {
      return true;
    }
    return false;
  }

  // static bool isGifLoadInstantly(Uri uri) {
  //     try {
  //         final String host = uri.host.toLowerCase();
  //         final String path = uri.path.toLowerCase();

  //         return hostContains(host, ["gfycat.com"]) || hostContains(host, ["v.redd.it"]) || (
  //                 hostContains(host, ["imgur.com"])
  //                         && (path.endsWith(".gif") || path.endsWith(".gifv") || path.endsWith(
  //                         ".webm"))) || path.endsWith(".mp4");

  //     } catch (e) {
  //         print('[DRAGO] Exception caught in ContentType.isGifLoadInstantly $e');
  //         return false;
  //     }
  // }

  static bool isGifLoadInstantly(Uri uri) {
    final String host = uri.host.toLowerCase();
    final String path = uri.path.toLowerCase();

    return hostContains(host, ["gfycat.com", "v.redd.it"]) ||
        ((hostContains(host, ["preview.redd.it", "external-preview.redd.it"]) &&
            uri.toString().contains("format=mp4"))) ||
        (hostContains(host, ["redditmedia.com", "imgur.com"]) &&
                path.endsWith(".gif") ||
            path.endsWith(".gifv") ||
            path.endsWith(".webm")) ||
        path.endsWith(".mp4");
  }

  static bool isGif(Uri uri) {
    try {
      final String host = uri.host.toLowerCase();
      final String path = uri.path.toLowerCase();

      return hostContains(host, ["gfycat.com"]) ||
          hostContains(host, ["v.redd.it"]) ||
          path.endsWith(".gif") ||
          path.endsWith(".gifv") ||
          path.endsWith(".webm") ||
          path.endsWith(".mp4");
    } catch (e) {
      print('[DRAGO] Exception caught in ContentType.isGif $e');
      return false;
    }
  }

  static bool isGfycat(Uri uri) {
    final String host = uri.host.toLowerCase();
    return hostContains(host, ["gfycat.com"]);
  }

  static bool isImage(Uri uri) {
    try {
      final String host = uri.host.toLowerCase();
      final String path = uri.path.toLowerCase();

      return host == "i.reddituploads.com" ||
          path.endsWith(".png") ||
          path.endsWith(".jpg") ||
          path.endsWith(".jpeg");
    } catch (e) {
      print('[DRAGO] Exception caught in ContentType.isImage $e');
      return false;
    }
  }

  static bool isImgurImage(String lqUrl) {
    try {
      final Uri uri = Uri.parse(lqUrl);
      final String host = uri.host.toLowerCase();
      final String path = uri.path.toLowerCase();

      return (host.contains("imgur.com") || host.contains("bildgur.de")) &&
          ((path.endsWith(".png") ||
              path.endsWith(".jpg") ||
              path.endsWith(".jpeg")));
    } catch (e) {
      print('[DRAGO] Exception caught in ContentType.isImgurImage $e');

      return false;
    }
  }

  static bool isImgurHash(String lqUrl) {
    try {
      final Uri uri = Uri.parse(lqUrl);
      final String host = uri.host.toLowerCase();
      final String path = uri.path.toLowerCase();

      return (host.contains("imgur.com")) &&
          (!(path.endsWith(".png") &&
              !path.endsWith(".jpg") &&
              !path.endsWith(".jpeg")));
    } catch (e) {
      print('[DRAGO] Exception caught in ContentType.isImgurHash $e');
      return false;
    }
  }

  static bool isAlbum(Uri uri) {
    try {
      final String host = uri.host.toLowerCase();
      final String path = uri.path.toLowerCase();

      return hostContains(host, ["imgur.com", "bildgur.de"]) &&
          (path.startsWith("/a/") ||
              path.startsWith("/gallery/") ||
              path.startsWith("/g/") ||
              path.contains(","));
    } catch (e) {
      print('[DRAGO] Exception caught in ContentType.isAlbum $e');
      return false;
    }
  }

  static bool isYoutubeVideo(Uri uri) {
    try {
      final String host = uri.host.toLowerCase();
      final String path = uri.path.toLowerCase();
      return hostContains(host, ["youtu.be", "youtube.com", "youtube.co.uk"]) &&
          !path.contains("/user/") &&
          !path.contains("/channel/");
    } catch (e) {
      print('[DRAGO] Exception caught in ContentType.isYoutubeVideo $e');
      return false;
    }
  }

  static bool isImgurLink(String url) {
    try {
      final Uri uri = Uri.parse(url);
      final String host = uri.host.toLowerCase();
      return hostContains(host, ["imgur.com", "bildgur.de"]) &&
          !isAlbum(uri) &&
          !isGif(uri) &&
          !isImage(uri);
    } catch (e) {
      print('[DRAGO] Exception caught in ContentType.isImgurLink $e');
      // } catch (URISyntaxException | NullPointerException e) {
      return false;
    }
  }

  static bool isXkcd(String url) {
    final Uri uri = Uri.parse(url);
    final String host = uri.host.toLowerCase();

    return (hostContains(host, ["xkcd.com"]) &&
        !hostContains(host, ["imgs.xkcd.com"]) &&
        !hostContains(host, ["what-if.xkcd.com"]));
  }

  ///
  /// Attempt to determine the content type of a link from the URL
  ///
  /// @param url URL to get ContentType from
  /// @return ContentType of the URL
  ///
  static Type getContentTypeFromURL(String url) {
    // if (!url.startsWith("//") && ((url.startsWith("/") && url.length < 4) || url.startsWith(
    //         "#spoiler") || url.startsWith("/spoiler") || url.startsWith("#s-") || url ==
    //         "#s" || url == "#ln" || url == "#b" || url == "#sp")) {
    //     return Type.SPOILER;
    // }
    if (isSpoiler(url)) {
      return Type.SPOILER;
    }

    if (url.startsWith("mailto:")) {
      return Type.EXTERNAL;
    }

    if (url.startsWith("//")) url = "https:" + url;
    if (url.startsWith("/")) url = "reddit.com" + url;
    if (!url.contains("://")) url = "http://" + url;

    try {
      final Uri uri = Uri.parse(url);
      final String host = uri.host.toLowerCase();
      final String scheme = uri.scheme.toLowerCase();

      if (hostContains(host, ["v.redd.it"]) ||
          (host == "reddit.com" && url.contains("reddit.com/video/"))) {
        if (url.contains("DASH_")) {
          return Type.VREDDIT_DIRECT;
        } else {
          return Type.VREDDIT_REDIRECT;
        }
      }

      if (scheme != "http" && scheme != "https") {
        return Type.EXTERNAL;
      }
      if (isYoutubeVideo(uri)) {
        return Type.YouTube;
      }
      // if (PostMatch.openExternal(url)) { //Look in SLIDE repo for this
      //     return Type.EXTERNAL;
      // }
      if (isGif(uri)) {
        return Type.GIF;
      }
      if (isImage(uri)) {
        return Type.IMAGE;
      }
      if (isAlbum(uri)) {
        return Type.ALBUM;
      }
      if (hostContains(host, ["imgur.com", "bildgur.de"])) {
        return Type.IMGUR;
      }

      if (isXkcd(url)) {
        return Type.XKCD;
      }

      // if (hostContains(host, ["xkcd.com"]) &&
      //     !hostContains(host, ["imgs.xkcd.com"]) &&
      //     !hostContains(host, ["what-if.xkcd.com"])) {
      //   return Type.XKCD;
      // }
      if (hostContains(host, ["tumblr.com"]) && uri.path.contains("post")) {
        return Type.TUMBLR;
      }
      if (hostContains(host, ["reddit.com", "redd.it"])) {
        return Type.REDDIT;
      }
      if (hostContains(host, ["vid.me"])) {
        return Type.VID_ME;
      }
      if (hostContains(host, ["deviantart.com"])) {
        return Type.DEVIANTART;
      }
      if (hostContains(host, ["streamable.com"])) {
        return Type.STREAMABLE;
      }

      return Type.LINK;
    } catch (e) {
      // } catch (URISyntaxException | NullPointerException e) {
      if (e.getMessage() != null &&
          (e.getMessage().contains("Illegal character in fragment") ||
              e.getMessage().contains("Illegal character in query") ||
              e.getMessage().contains(
                  "Illegal character in path"))) //a valid link but something un-encoded in the URL
      {
        return Type.LINK;
      }
      print('[DRAGO] Exception caught in ContentType.getContentTypeFromURL $e');

      // e.printStackTrace();
      return Type.NONE;
    }
  }

  ///
  /// Attempts to determine the content of a submission, mostly based on the URL
  ///
  /// @param submission Submission to get the content type from
  /// @return Content type of the Submission
  /// @see #getContentType(String)
  ///
  static Type getContentTypeFromSubmission(Submission submission) {
    if (submission == null) {
      return Type.SELF; //hopefully shouldn't be null, but catch it in case
    }

    if (submission.isSelf) {
      return Type.SELF;
    }

    final String url = submission.url.toString();
    final Type basicType = getContentTypeFromURL(url);

    // TODO: Decide whether internal youtube links should be EMBEDDED or LINK
    //! A DRAW submission doesn't have getDataNode(). do I care about embedded media? delete ?
    // if (basicType == Type.LINK && submission.getDataNode().has("media_embed") && submission
    //         .getDataNode()
    //         .get("media_embed")
    //         .has("content")) {
    //     return Type.EMBEDDED;
    // }

    return basicType;
  }

  static bool displayImage(Type t) {
    switch (t) {
      // case Type.ALBUM:
      // case Type.DEVIANTART:
      case Type.XKCD:
      // case Type.TUMBLR:
      case Type.IMAGE:
      case Type.IMGUR:
      case Type.SELF:
        return true;
      default:
        return false;
    }
  }

  static bool shouldHaveThumbnail(Type t) {
    switch (t) {
      case Type.IMAGE:
      case Type.XKCD:
      case Type.IMGUR:
      case Type.YouTube:
      case Type.LINK:
      case Type.GIF:
      case Type.VREDDIT_REDIRECT:
      case Type.VREDDIT_DIRECT:
        return true;
      default:
        return false;
    }
  }

  static bool displayVideo(Type t) {
    switch (t) {
      case Type.STREAMABLE:
      case Type.VID_ME:
      case Type.VIDEO:
      case Type.GIF:
      case Type.VREDDIT_REDIRECT:
        return true;
      default:
        return false;
    }
  }

  static bool imageType(Type t) {
    return (t == Type.IMAGE || t == Type.IMGUR);
  }

  static bool fullImage(Type t) {
    switch (t) {
      case Type.ALBUM:
      case Type.DEVIANTART:
      case Type.GIF:
      case Type.IMAGE:
      case Type.IMGUR:
      case Type.STREAMABLE:
      case Type.TUMBLR:
      case Type.XKCD:
      case Type.VIDEO:
      case Type.SELF:
      case Type.VREDDIT_DIRECT:
      case Type.VREDDIT_REDIRECT:
      case Type.VID_ME:
        return true;

      case Type.EMBEDDED:
      case Type.EXTERNAL:
      case Type.LINK:
      case Type.NONE:
      case Type.REDDIT:
      case Type.SPOILER:
      default:
        return false;
    }
  }

  static bool mediaType(Type t) {
    switch (t) {
      case Type.ALBUM:
      case Type.DEVIANTART:
      case Type.GIF:
      case Type.IMAGE:
      case Type.TUMBLR:
      case Type.XKCD:
      case Type.IMGUR:
      // case Type.VREDDIT_DIRECT:
      // case Type.VREDDIT_REDIRECT:
      case Type.STREAMABLE:
      case Type.VID_ME:
        return true;
      default:
        return false;
    }
  }

  ///   Returns a string identifier for a submission e.g. Link, GIF, NSFW Image
  ///   @param submission Submission to get the description for
  ///   @return the String identifier

  // static String _getContentID(Submission submission) {
  //   return getContentID(getContentTypeFromSubmission(submission));
  // }

  // static String getContentID(Type contentType) {
  //   switch (contentType) {
  //     case Type.NONE:
  //     case Type.SPOILER:
  //     case Type.TABLE:
  //     case Type.EMBEDDED:

  //     case /*Type.UNKNOWN,*/ Type.LINK:
  //       return "Link";
  //     case Type.ALBUM:
  //       return "Imgur Album";
  //     case Type.DEVIANTART:
  //       return "Deviantart";
  //     case Type.IMAGE:
  //       return "Direct Image";
  //     case Type.IMGUR:
  //       return "Imgur Image";
  //     case Type.TUMBLR:
  //       return "Tumblr";
  //     case Type.XKCD:
  //       return "XKCD";
  //     case Type.EXTERNAL:
  //       return "External Link";
  //     case Type.GIF:
  //       // if url != nil && url!.absoluteString.contains("v.redd.it") {
  //       //     return "Reddit Video"
  //       // }
  //       return "Gif";
  //     case Type.STREAMABLE:
  //       return "Streamable.com Video";
  //     case Type.VIDEO:
  //       return "YouTube Video";
  //     case Type.VID_ME:
  //       return "Vid.me Video";
  //     case Type.REDDIT:
  //       return "Reddit Link";
  //     case Type.SELF:
  //       return "Selftext Post";
  //     case Type.VREDDIT_DIRECT:
  //     case Type.VREDDIT_REDIRECT:
  //       return "Reddit Video";
  //   }
  //   return "Link";
  //   // return R.string.type_link;
  // }

  static Map<String, String> contentDescriptions = Map();

  /**
     * Returns a description of the submission, for example "Link", "NSFW link", if the link is set
     * to open externally it returns the package name of the app that opens it, or "External"
     *
     * @param submission The submission to describe
     * @param context    Current context
     * @return The content description
     */
  // static String getContentDescription(Submission submission, Context context) {
  //     final int generic = _getContentID(submission);
  //     final Resources res = context.getResources();
  //     final String domain = submission.getDomain();

  //     if (generic != R.string.type_external) {
  //         return res.getString(generic);
  //     }

  //     if (contentDescriptions.containsKey(domain)) {
  //         return contentDescriptions.get(domain);
  //     }

  //     try {
  //         final PackageManager pm = context.getPackageManager();
  //         final Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(submission.getUrl()));
  //         final String packageName = pm.resolveActivity(intent, 0).activityInfo.packageName;
  //         String description;

  //         if (!packageName.equals("android")) {
  //             description = pm.getApplicationLabel(
  //                     pm.getApplicationInfo(packageName, PackageManager.GET_META_DATA))
  //                     .toString();
  //         } else {
  //             description = res.getString(generic);
  //         }

  //         // Looking up a package name takes a long time (3~10ms), memoize it
  //         contentDescriptions.put(domain, description);
  //         return description;
  //     } catch (PackageManager.NameNotFoundException | NullPointerException e) {
  //         contentDescriptions.put(domain, res.getString(generic));
  //         return res.getString(generic);
  //     }
  // }

}
