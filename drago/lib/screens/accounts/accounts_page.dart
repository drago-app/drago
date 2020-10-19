import 'package:drago/blocs/blocs.dart';
import 'package:drago/common/common.dart';
import 'package:drago/screens/subreddit/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drago/main.dart';

class AccountPageListingViewModel {
  final Function onTap;
  final dynamic leading;
  final dynamic trailing;
  final String listingLabel;
  AccountPageListingViewModel(
      {this.onTap,
      @required this.leading,
      this.trailing = CupertinoIcons.chevron_right,
      @required this.listingLabel});
}

final postsListingViewModel = AccountPageListingViewModel(
    listingLabel: 'Posts', leading: CupertinoIcons.chat_bubble);
final commentsListingViewModel = AccountPageListingViewModel(
    listingLabel: 'Comments', leading: CupertinoIcons.chat_bubble);
final multiredditsListingViewModel = AccountPageListingViewModel(
    listingLabel: 'Multiredditds', leading: CupertinoIcons.chat_bubble);
final trophiesListingViewModel = AccountPageListingViewModel(
    listingLabel: 'Trophies', leading: CupertinoIcons.chat_bubble);
final savedListingViewModel = AccountPageListingViewModel(
    listingLabel: 'Saved', leading: CupertinoIcons.chat_bubble);
final upvotedListingViewModel = AccountPageListingViewModel(
    listingLabel: 'Upvoted', leading: CupertinoIcons.chat_bubble);
final downvotedListingViewModel = AccountPageListingViewModel(
    listingLabel: 'Downvoted', leading: CupertinoIcons.chat_bubble);
final hiddenListingViewModel = AccountPageListingViewModel(
    listingLabel: 'Hidden', leading: CupertinoIcons.chat_bubble);
final friendsListingViewModel = AccountPageListingViewModel(
    listingLabel: 'Friends', leading: CupertinoIcons.chat_bubble);
final moderatoreZoneListingViewModel = AccountPageListingViewModel(
    listingLabel: 'Moderator Zone', leading: CupertinoIcons.chat_bubble);

class AccountPageFactory extends StatelessWidget {
  final Map<AccountPageListingOptions, AccountPageListingViewModel>
      viewModelMap = {
    AccountPageListingOptions.posts: postsListingViewModel,
    AccountPageListingOptions.comments: commentsListingViewModel,
    AccountPageListingOptions.multireddits: multiredditsListingViewModel,
    AccountPageListingOptions.trophies: trophiesListingViewModel,
    AccountPageListingOptions.saved: savedListingViewModel,
    AccountPageListingOptions.upvoted: upvotedListingViewModel,
    AccountPageListingOptions.downvoted: downvotedListingViewModel,
    AccountPageListingOptions.hidden: hiddenListingViewModel,
    AccountPageListingOptions.friends: friendsListingViewModel,
    AccountPageListingOptions.moderatorZone: moderatoreZoneListingViewModel,
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountPageBloc, AccountPageState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AccountPageInitial) return AccountPage(name: state.name);
          if (state is AccountPageLoading)
            return AccountPage(
              name: state.name,
              heading: Center(
                child: LoadingIndicator(),
              ),
            );
          if (state is AccountPageLoaded)
            return AccountPage(
              name: state.name,
              heading: _headerRow(
                state.account.commentKarma.toString(),
                state.account.linkKarma.toString(),
                state.account.createdUtc.toString(),
              ),
              listings: AccountPageListings(
                children: state.listingOptions
                    .map((option) => viewModelMap[option])
                    .mapIndex((vm, index) => AccountPageListingWidget(
                        viewModel: vm,
                        last: (index == state.listingOptions.length - 1)))
                    .toList(),
              ),
              moderationZone: state.showModeratorOptions
                  ? AccountPageListings(
                      children: [
                        AccountPageListingWidget(
                            viewModel: moderatoreZoneListingViewModel)
                      ],
                    )
                  : SizedBox.shrink(),
            );
          return Placeholder(color: CupertinoColors.destructiveRed);
        });
  }
}

class AccountPageListingWidget extends StatelessWidget {
  final bool last;
  final AccountPageListingViewModel viewModel;

  AccountPageListingWidget({Key key, this.last = false, this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoListItemSmall(
      leading: Icon(viewModel.leading),
      trailing: Icon(viewModel.trailing),
      last: last,
      middle: Text(viewModel.listingLabel),
    );
  }
}

class AccountPage extends StatelessWidget {
  final String name;
  final Widget heading;
  final Widget listings;
  final Widget moderationZone;
  final Widget overview;

  AccountPage(
      {@required this.name,
      this.heading = const SizedBox.shrink(),
      this.listings = const SizedBox.shrink(),
      this.moderationZone = const SizedBox.shrink(),
      this.overview = const SizedBox.shrink()});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountPageBloc, AccountPageState>(
      listener: (context, state) {},
      builder: (BuildContext context, state) {
        return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
                middle: Text('$name')),
            child: ListView(
              children: [
                heading,
                listings,
                moderationZone,
                overview,
              ],
            ));
      },
    );
  }
}

Widget _header({String value = '', String text = ''}) {
  final newText = text.split(' ');

  return Column(children: [
    Text(value,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    for (var t in newText)
      Text(t, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
  ]);
}

Widget _headerRow(comment, link, age) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _header(value: comment, text: 'Comment Karma'),
      _header(value: link, text: 'Link Karma'),
      _header(value: age, text: 'Account Age')
    ],
  );
}

class AccountPageListings extends StatelessWidget {
  final List<Widget> children;

  AccountPageListings({@required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: Column(children: children),
      ),
    );
  }
}

class CupertinoListItemSmall extends StatefulWidget {
  final Widget leading;
  final Widget middle;
  final Widget trailing;
  final bool last;

  CupertinoListItemSmall({
    this.leading = const SizedBox.shrink(),
    this.middle = const SizedBox.shrink(),
    this.trailing = const SizedBox.shrink(),
    this.last = false,
  });

  @override
  State<StatefulWidget> createState() => _CupertinoListItemSmallState();
}

class _CupertinoListItemSmallState extends State<CupertinoListItemSmall> {
  bool _isPressed = false;
  static const Color _kBackgroundColorPressed = const Color(0xFFDDDDDD);
  void onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Container(
          decoration: BoxDecoration(
              color: _isPressed
                  ? _kBackgroundColorPressed
                  : CupertinoColors.systemBackground.resolveFrom(context)),
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: widget.leading,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: widget.last
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: _kBackgroundColorPressed,
                            ),
                          ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: widget.middle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: widget.trailing,
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
