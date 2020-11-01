import 'package:drago/blocs/submission_bloc.dart/submission.dart';
import 'package:drago/common/common.dart';
import 'package:drago/common/drag_to_pop_modal/drag_to_pop_page_route.dart';
import 'package:drago/common/picture.dart';
import 'package:drago/features/subreddit/get_submissions.dart';
import 'package:drago/sandbox/host.dart';
import 'package:drago/screens/subreddit/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SubmissionWidgetFactory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SubmissionWidgetFactoryState();
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class SubmissionWidgetFactoryState extends State<SubmissionWidgetFactory>
    implements MediaVisitor {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubmissionBloc, SubmissionState>(
        listener: (listenerContext, state) {},
        builder: (builderContext, state) {
          if (state.submission is SelfSubmission)
            return selfSubmission(state.submission);
          if (state.submission is WebSubmission)
            return linkSubmission(state.submission);
          if (state.submission is MediaSubmission) {
            return (state.submission as MediaSubmission).media.accept(this);
          }
          if (state.submission is Submission) {
            return SizedBox.shrink();
          }
        });
  }

  @override
  Widget visitImageMedia(ImageMedia media) {
    return mediaSubmission(
      BlocProvider.of<SubmissionBloc>(context).state.submission,
      SubmissionThumbnail(
        previewUrl: BlocProvider.of<SubmissionBloc>(context)
            .state
            .submission
            .previewUrl,
        onTap: () => Navigator.of(context, rootNavigator: true).push(
          DragToPopPageRoute(
            builder: (_) => SecondPage(
              body: ImageViewerWidget(media
                  // maxHeight: MediaQuery.of(context).size.height,
                  // url: media.src,
                  ),
              bloc: context.bloc<SubmissionBloc>(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  visitAudioMedia(AudioMedia media) {
    // TODO: implement visitAudioMedia
    throw UnimplementedError();
  }

  @override
  visitGalleryMedia(GalleryMedia media) {
    return mediaSubmission(
        BlocProvider.of<SubmissionBloc>(context).state.submission,
        SubmissionThumbnail(
            label: GalleryThumbnailLabel(media),
            previewUrl: BlocProvider.of<SubmissionBloc>(context)
                .state
                .submission
                .previewUrl,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                DragToPopPageRoute(
                  builder: (_) {
                    final PageController controller = PageController();
                    return SecondPage(
                      topRightCorner: GalleryPageIndicator(
                        controller: controller,
                        total: media.size,
                      ),
                      body: Center(
                          child: GalleryWidget(
                              controller: controller, media: media)),
                      bloc: context.bloc<SubmissionBloc>(),
                      // caption: GalleryCaptionWidget(
                      //   controller: controller,
                      //   captions: media.src.map((src) => src.title).toList(),
                      // ),
                    );
                  },
                ),
              );
            }));
  }

  @override
  visitGenericMedia(GenericaMedia media) {
    // TODO: implement visitGenericMedia
    throw UnimplementedError();
  }

  @override
  Widget visitGifMedia(GifMedia media) {
    return mediaSubmission(
        BlocProvider.of<SubmissionBloc>(context).state.submission,
        SubmissionThumbnail(
          label: GifThumbnailLabel(),
          previewUrl: BlocProvider.of<SubmissionBloc>(context)
              .state
              .submission
              .previewUrl,
        ));
  }

  @override
  visitIframeMedia(IframeMedia media) {
    // TODO: implement visitIframeMedia
    throw UnimplementedError();
  }

  @override
  visitVideoMedia(VideoMedia media) {
    return mediaSubmission(
        BlocProvider.of<SubmissionBloc>(context).state.submission,
        SubmissionThumbnail(
          label: VideoThumbnailLabel(),
          previewUrl: BlocProvider.of<SubmissionBloc>(context)
              .state
              .submission
              .previewUrl,
        ));
  }
}

Widget mediaSubmission(Submission submission, Widget thumbnail) =>
    SubredditListItem(
        stickied: submission.stickied,
        saved: submission.saved,
        title: submission.title,
        voteState: submission.voteState,
        authorFlairText: submission.authorFlairText,
        linkFlairText: submission.linkFlairText,
        onUpVote: (context) =>
            BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
        onDownVote: (context) =>
            BlocProvider.of<SubmissionBloc>(context).add(Downvote()),
        onTap: (context) => Navigator.of(context).pushNamed('/comments',
            arguments: BlocProvider.of<SubmissionBloc>(context)),
        thumbnail: thumbnail,
        authorViewModel:
            AuthorViewModel(author: submission.author, onTap: null),
        scoreViewModel: ScoreViewModel(
          score: submission.score,
          voteState: submission.voteState,
          onTap: (context) =>
              BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
        ),
        numCommentsViewModel: NumCommentsViewModel(submission.numComments),
        nsfw: submission.isNSFW);

Widget linkSubmission(Submission submission) => SubredditListItem(
    stickied: submission.stickied,
    saved: submission.saved,
    title: submission.title,
    authorFlairText: submission.authorFlairText,
    linkFlairText: submission.linkFlairText,
    voteState: submission.voteState,
    onUpVote: (context) =>
        BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
    onDownVote: (context) =>
        BlocProvider.of<SubmissionBloc>(context).add(Downvote()),
    onTap: (context) => Navigator.of(context).pushNamed('/comments',
        arguments: BlocProvider.of<SubmissionBloc>(context)),
    thumbnail: SubmissionThumbnail(
      onTap: () => _launchURL(submission.url),
      label: LinkThumbnailLabel(),
      previewUrl: submission.previewUrl ?? 'https://via.placeholder.com/150',
    ),
    authorViewModel: AuthorViewModel(author: submission.author, onTap: null),
    scoreViewModel: ScoreViewModel(
      score: submission.score,
      voteState: submission.voteState,
      onTap: (context) =>
          BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
    ),
    numCommentsViewModel: NumCommentsViewModel(submission.numComments),
    nsfw: submission.isNSFW);

Widget selfSubmission(Submission submission) => SubredditListItem(
    stickied: submission.stickied,
    saved: submission.saved,
    title: submission.title,
    authorFlairText: submission.authorFlairText,
    linkFlairText: submission.linkFlairText,
    voteState: submission.voteState,
    onUpVote: (context) =>
        BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
    onDownVote: (context) =>
        BlocProvider.of<SubmissionBloc>(context).add(Downvote()),
    onTap: (context) => Navigator.of(context).pushNamed('/comments',
        arguments: BlocProvider.of<SubmissionBloc>(context)),
    thumbnail: SubmissionThumbnail(
      onTap: null,
      previewUrl: 'https://via.placeholder.com/150',
    ),
    authorViewModel: AuthorViewModel(author: submission.author, onTap: null),
    scoreViewModel: ScoreViewModel(
      score: submission.score,
      voteState: submission.voteState,
      onTap: (context) =>
          BlocProvider.of<SubmissionBloc>(context).add(Upvote()),
    ),
    numCommentsViewModel: NumCommentsViewModel(submission.numComments),
    nsfw: submission.isNSFW);
