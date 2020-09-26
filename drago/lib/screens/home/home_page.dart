import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drago/blocs/blocs.dart';
import 'package:drago/common/common.dart';
// import 'package:drago/home/list_item_base.dart';
// import 'package:drago/home/subreddit_tile_model.dart';
// import 'package:sticky_headers/sticky_headers.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
      if (state is HomePageLoading) {
        return CupertinoPageScaffold(
            child: Center(
          child: LoadingIndicator(),
        ));
      } else if (state is HomePageLoaded) {
        return CupertinoPageScaffold(
            child: Center(
          child: _body(state),
        ));
      } else if (state is HomePageInitial) {
        return CupertinoPageScaffold(child: Center(child: Placeholder()));
      } else {
        return Center(child: Text('AHH SOMETHING WENT WRONG ON HOME PAGE'));
      }
    });
  }

  Widget _body(HomePageLoaded state) {
    return ListView(
        children:
            state.subscriptions.map((sub) => ListItem(text: sub)).toList());
  }
}

class ListItem extends StatelessWidget {
  final String text;
  final bool last;

  ListItem({required this.text, this.last = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed('/subreddit', arguments: text),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: (!last) ? Colors.grey : Colors.transparent,
                    width: 0))),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '$text',
            style: CupertinoTheme.of(context).textTheme.textStyle,
          ),
        ),
      ),
    );
  }
}

// NOTE: If refactoring this page, consider this package
//  https://github.com/quire-io/scroll-to-index

// class HeaderWrapper {
//   final HeaderType headerType;
//   String header;
//   final item;

//   HeaderWrapper({this.headerType, this.item});
// }

// enum HeaderType { PROMINENT, MODERATOR, SUBSCRIBED }

// class HomePage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _HomePageState();
//   }
// }

// class _HomePageState extends State<HomePage> {
//   ScrollController _scrollController;
//   final _stickyHeaderHeight = 25.0;
//   final _prominentSubredditHeight = 46.0;

//   final _regularHeight = 40.0;
//   final _promHeight = 65.0;
//   Map headerToTag = Map();
//   Map tagToPosition = Map();

//   @override
//   void initState() {
//     _scrollController = ScrollController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     bloc.dispose();
//     super.dispose();
//   }

//   var bloc;

//   List pageContent = [];

//   @override
//   Widget build(BuildContext context) {

//     bloc = AppProvider.of(context);
//     return SafeArea(
//       minimum: EdgeInsets.only(bottom: 50),
//       top: false,
//       child: CupertinoPageScaffold(
//         navigationBar: CupertinoNavigationBar(middle: Text('Home')),
//         child: _buildBody(context, bloc),
//       ),
//     );
//   }

//   _buildAlphabetBar(context) {
//     return Positioned(
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.withOpacity(.05),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: headerToTag.values
//                 .map<Widget>(
//                   (k) => SizedBox(
//                     height: 20,
//                     width: 15,
//                     child: GestureDetector(
//                       onTapDown: (_) => _scrollController.animateTo(
//                           tagToPosition[k],
//                           curve: Curves.linear,
//                           duration: Duration(milliseconds: 100)),
//                       child: Text(k.toString()),
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   _buildBody(context, bloc) {
//     return StreamBuilder(
//         stream: bloc.homePageContent,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Ooops something went wrong');
//           } else if (!snapshot.hasData) {
//             return Center(
//               child: LoadingIndicator(),
//             );
//           } else {
//             List headers = [];
//             pageContent = [];
//             pageContent.addAll(snapshot.data[0]
//                 .map((item) =>
//                     HeaderWrapper(headerType: HeaderType.PROMINENT, item: item))
//                 .toList());
//             pageContent.addAll(snapshot.data[1]
//                 .map((item) =>
//                     HeaderWrapper(headerType: HeaderType.MODERATOR, item: item))
//                 .toList());
//             pageContent.addAll(snapshot.data[2].map((item) =>
//                 HeaderWrapper(headerType: HeaderType.SUBSCRIBED, item: item)));
//             pageContent = pageContent.map((p) {
//               p.header = _headerValue(p);
//               return p;
//             }).toList();

//             headers = pageContent.map((i) => i.header).toSet().toList();

//             generateTags(headers);
//             calculatePositions(headers);

//             return Stack(children: [
//               ListView.builder(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 controller: _scrollController,
//                 itemCount: headers.length,
//                 itemBuilder: (context, index) {
//                   return StickyHeader(
//                     header: _buildHeader(context, headers[index]),
//                     content: Column(
//                       children: pageContent
//                           .where((item) => item.header == headers[index])
//                           .map<Widget>((h) => _bodyItem(
//                               h.item,
//                               _itemIsLast(
//                                   pageContent
//                                       .where((item) =>
//                                           item.header == headers[index])
//                                       .toList(),
//                                   h)))
//                           .toList(),
//                     ),
//                   );
//                 },
//               ),
//               _buildAlphabetBar(context)
//             ]);
//           }
//         });
//   }

//   _itemIsLast(List list, item) {
//     return list.indexOf(item) == list.length - 1;
//   }

//   calculatePositions(headers) {
//     tagToPosition = Map.fromIterable(headers,
//         key: (header) => _tagFromHeader(header),
//         value: (header) => _headerPosition(header));
//   }

//   _headerPosition(header) {
//     if (header == '') {
//       return 00.0;
//     } else {
//       double answer = 0.0;
//       int numProm = 1 +
//           pageContent
//               .lastIndexWhere((i) => i.headerType == HeaderType.PROMINENT);
//       double promOffset = numProm * _promHeight;

//       int numHeader = headerToTag.keys.toList().indexOf(header) - 1;
//       double headerOffset = numHeader * _stickyHeaderHeight;

//       int rowIndex = pageContent.indexWhere((i) => i.header == header);

//       int x = rowIndex - numProm;
//       answer = (x * _regularHeight) + promOffset + headerOffset;

//       return answer;
//     }
//   }

//   generateTags(List headers) {
//     headerToTag = Map.fromIterable(headers,
//         key: (header) => header, value: (header) => _tagFromHeader(header));
//   }

//   _tagFromHeader(header) {
//     if (header == '') {
//       return '()';
//     } else if (header == "MODERATOR") {
//       return '*';
//     } else {
//       return header;
//     }
//   }

//   String _headerValue(item) {
//     switch (item.headerType) {
//       case (HeaderType.PROMINENT):
//         return '';
//       case (HeaderType.MODERATOR):
//         return "MODERATOR";
//       case (HeaderType.SUBSCRIBED):
//         return (RegExp(r'[0-9]').hasMatch(item.item.displayName[0]))
//             ? '#'
//             : item.item.displayName[0].toUpperCase();
//       default:
//         throw FormatException;
//     }
//   }

//   _buildHeader(context, header) {
//     if (header.isEmpty) {
//       return SizedBox.shrink();
//     }
//     return Container(
//       height: _stickyHeaderHeight,
//       color: Colors.blue,
//       padding: EdgeInsets.symmetric(horizontal: 16.0),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         '$header',
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }

//   _bodyItem(item, last) {
//     if (item is SubredditTile) {
//       return _prominentSubreddit(item, last);
//     }
//     if (item is Subreddit) {
//       return _subscribedSubreddit(item, last);
//     }
//     if (item is String) {
//       return Container(
//         child: Text(item),
//       );
//     }
//   }

//   _navigate(context, item) {
//     Navigator.push(
//       context,
//       CupertinoPageRoute(
//         builder: (BuildContext context) => SubredditProvider(
//           repository: bloc.repository,
//           child: SubredditPage(
//             message: RoutingMessage(
//                 previousPage: 'Home', subredditName: item.displayName),
//           ),
//         ),
//       ),
//     );
//   }

//   _subscribedSubreddit(Subreddit item, bool last) {
//     final TextStyle style = CupertinoTheme.of(context).textTheme.textStyle;
//     return Material(
//       child: InkWell(
//         onTap: () => _navigate(context, item),
//         child: Container(
//             decoration: BoxDecoration(
//                 border: Border(
//                     bottom: BorderSide(
//                         color: (!last) ? Colors.grey : Colors.transparent,
//                         width: 0))),
//             height: _regularHeight,
//             width: double.infinity,
//             child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                     padding: EdgeInsets.only(left: 16),
//                     child: Text(item.displayName, style: style)))
//             // child: ListTile(
//             //     leading: Text(item.displayName, style: style), dense: false),
//             ),
//       ),
//     );
//   }

//   _prominentSubreddit(SubredditTile item, bool last) {
//     return Material(
//       child: InkWell(
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                   color: (!last) ? Colors.grey : Colors.transparent, width: 0),
//             ),
//           ),
//           height: _promHeight,
//           child: ListTile(
//             dense: true,
//             leading: Container(
//               height: _prominentSubredditHeight,
//               width: _prominentSubredditHeight,
//               child: Icon(
//                 item.icon,
//                 size: 24,
//                 color: Colors.white,
//               ),
//               decoration: BoxDecoration(
//                 color: item.iconColor,
//                 borderRadius: BorderRadius.circular(50),
//               ),
//             ),
//             title: Text(item.title),
//             subtitle: Text(item.subtitle),
//           ),
//         ),
//       ),
//     );
//   }

// /*  I think below here is old... ? i dont know what it is*/

//   // @override
//   // Widget build(BuildContext context) {
//   //   bloc = AppProvider.of(context);

//   //   return SafeArea(
//   //       top: false,
//   //       bottom: true,
//   //       child: CupertinoPageScaffold(child: _homePageTab(context, bloc)));
//   // }

//   // Widget _moderationList(BuildContext context, bloc) {
//   //   return StreamBuilder(
//   //       stream: bloc.myModerations,
//   //       builder: (context, snapshot) {
//   //         if (!snapshot.hasData) {
//   //           return SliverList(
//   //             delegate: SliverChildListDelegate([]),
//   //           );
//   //         } else if (snapshot.hasError) {
//   //           return SliverList(
//   //             delegate: SliverChildListDelegate([]),
//   //           );
//   //         } else {
//   //           return new SliverStickyHeaderBuilder(
//   //             builder: (context, state) => _header(context, state, 'moderator'),
//   //             sliver: new SliverList(
//   //               delegate: new SliverChildBuilderDelegate(
//   //                 (context, i) => ListItemBase(
//   //                       lastItem: i == snapshot.data.length - 1,
//   //                       middle: <Widget>[Text(snapshot.data[i].displayName)],
//   //                     ),
//   //                 childCount: snapshot.data.length,
//   //               ),
//   //             ),
//   //           );
//   //         }
//   //       });
//   // }

//   // Widget _header(
//   //     BuildContext context, SliverStickyHeaderState state, String title) {
//   //   return Container(
//   //     height: 20.0,
//   //     color: (state.isPinned)
//   //         ? CupertinoColors.activeBlue
//   //         : CupertinoColors.darkBackgroundGray,
//   //     padding: EdgeInsets.symmetric(horizontal: 24.0),
//   //     alignment: Alignment.centerLeft,
//   //     child: new Text(
//   //       '${title.toUpperCase()}',
//   //       style: const TextStyle(color: CupertinoColors.lightBackgroundGray),
//   //     ),
//   //   );
//   // }

//   // Widget _textInput() {
//   //   return CupertinoTextField(
//   //     autofocus: false,
//   //     placeholder: "Search",
//   //     prefix: Icon(CupertinoIcons.search),
//   //     suffix: AnimatedContainer(
//   //       duration: Duration(milliseconds: 5000),
//   //       child: CupertinoButton(
//   //         child: Text('Cancel'),
//   //         onPressed: () {}, //TODO
//   //       ),
//   //     ),
//   //     suffixMode: OverlayVisibilityMode.editing,
//   //   );
//   // }

//   // Widget _homePageNavigationBar(BuildContext context) {
//   //   return CupertinoSliverNavigationBar(
//   //     key: UniqueKey(),
//   //     automaticallyImplyLeading: false,
//   //     automaticallyImplyTitle: false,
//   //     largeTitle: _textInput(),
//   //     leading: CupertinoButton(
//   //       padding: EdgeInsets.all(0),
//   //       child: Icon(CupertinoIcons.add),
//   //       onPressed: () {}, //TODO
//   //     ),
//   //     middle: Text('Home'),
//   //     trailing: CupertinoButton(
//   //       padding: EdgeInsets.all(0),
//   //       child: Text("Edit"),
//   //       onPressed: () {}, //TODO
//   //     ),
//   //   );
//   // }

//   // Widget _topListIcon(BuildContext context, IconData icon, Color iconColor) {
//   //   return Container(
//   //       height: 48,
//   //       width: 48,
//   //       child: Icon(icon, size: 36, color: CupertinoColors.white),
//   //       decoration: BoxDecoration(
//   //           borderRadius: BorderRadius.circular(50), color: iconColor));
//   // }

//   // Widget _topListView(BuildContext context) {
//   //   return SliverSafeArea(
//   //     top: false,
//   //     minimum: const EdgeInsets.only(top: 0, bottom: 0),
//   //     sliver: SliverList(
//   //       delegate: SliverChildBuilderDelegate(
//   //         (context, index) {
//   //           if (index < subredditTiles.length) {
//   //             return Material(
//   //                 child: InkWell(
//   //                     onTap: () {
//   //                       Navigator.of(context).push(CupertinoPageRoute(
//   //                           builder: (context) => SubredditProvider(
//   //                               bloc:
//   //                                   SubredditBloc(instance: bloc.reddit.value),
//   //                               child: SubredditPage(
//   //                                 message: RoutingMessage(
//   //                                     previousPage: 'Subreddits',
//   //                                     subredditName: 'All'),
//   //                               ))));
//   //                     },
//   //                     child: ListItemBase(
//   //                         lastItem: index == subredditTiles.length - 1,
//   //                         leading: ListItemLeading(
//   //                           height: 48,
//   //                           width: 48,
//   //                           child: _topListIcon(
//   //                               context,
//   //                               subredditTiles[index].icon,
//   //                               subredditTiles[index].iconColor),
//   //                         ),
//   //                         middle: [
//   //                           Text(
//   //                             subredditTiles[index].title,
//   //                             style: Styles.productRowItemName,
//   //                           ),
//   //                           const Padding(padding: EdgeInsets.only(top: 8)),
//   //                           Text(
//   //                             subredditTiles[index].subtitle,
//   //                             style: Styles.productRowItemPrice,
//   //                           )
//   //                         ])));
//   //           }
//   //           return null;
//   //         },
//   //       ),
//   //     ),
//   //   );
//   // }

//   // _subscriptionList(context, bloc) {
//   //   const alphabet = [
//   //     "a",
//   //     "b",
//   //     "c",
//   //     "d",
//   //     "e",
//   //     "f",
//   //     "g",
//   //     "h",
//   //     "i",
//   //     "j",
//   //     "k",
//   //     "l",
//   //     "m",
//   //     "n",
//   //     "o",
//   //     "p",
//   //     "q",
//   //     "r",
//   //     "s",
//   //     "t",
//   //     "u",
//   //     "v",
//   //     "w",
//   //     "x",
//   //     "y",
//   //     "z"
//   //   ];
//   //   List<Widget> answer = [];

//   //   alphabet.forEach((letter) {
//   //     var sliver = StreamBuilder(
//   //         stream: bloc.mySubscriptions,
//   //         builder: (context, snapshot) {
//   //           if (!snapshot.hasData) {
//   //             return SliverList(
//   //               delegate: SliverChildListDelegate([]),
//   //             );
//   //           } else if (snapshot.hasError) {
//   //             return SliverList(
//   //               delegate: SliverChildListDelegate([]),
//   //             );
//   //           } else {
//   //             int first = snapshot.data.indexWhere((sub) =>
//   //                 sub.displayName[0].toLowerCase() == letter.toLowerCase());
//   //             int last = snapshot.data.lastIndexWhere((sub) =>
//   //                 sub.displayName[0].toLowerCase() == letter.toLowerCase());
//   //             // print('${first.toString()} --- ${last.toString()}');

//   //             if (first == -1 || last == -1) {
//   //               return SliverList(
//   //                 delegate: SliverChildListDelegate([]),
//   //               );
//   //             } else {
//   //               var sublist = snapshot.data.sublist(first, last);

//   //               return SliverStickyHeaderBuilder(
//   //                   builder: (context, state) =>
//   //                       _header(context, state, letter),
//   //                   sliver: SliverList(
//   //                     delegate: SliverChildBuilderDelegate(
//   //                         (context, i) => GestureDetector(
//   //                             onTap: () => Navigator.of(context).push(
//   //                                 CupertinoPageRoute<void>(
//   //                                     builder: (BuildContext context) =>
//   //                                         SubredditProvider(
//   //                                             bloc: SubredditBloc(
//   //                                                 instance: bloc.reddit.value),
//   //                                             child: SubredditPage(
//   //                                                 message: RoutingMessage(
//   //                                                     subredditName: sublist[i]
//   //                                                         .displayName,
//   //                                                     previousPage:
//   //                                                         'Subreddits'))))),
//   //                             child: Dismissible(
//   //                                 onDismissed: (_) {
//   //                                   //TODO NEED TO UNSUBSCRIBE FROM THE SUBREDDIT
//   //                                   //TODO AND REMOVE THE SUBREDDIT FROM THE UNDERYING LIST
//   //                                   //TODO IF THE ITEM IS IN THE LIST THE APP BREAKS
//   //                                 },
//   //                                 direction: DismissDirection.endToStart,
//   //                                 background: Container(
//   //                                     alignment: Alignment.centerRight,
//   //                                     color: CupertinoColors.destructiveRed,
//   //                                     child: Text(
//   //                                       'Unsubscribe',
//   //                                       style: TextStyle(
//   //                                           color: CupertinoColors.white),
//   //                                     )),
//   //                                 key: Key(sublist[i].displayName),
//   //                                 child: ListItemBase(
//   //                                     lastItem: i == sublist.length - 1,
//   //                                     middle: [Text(sublist[i].displayName)]))),
//   //                         childCount: sublist.length),
//   //                   ));
//   //             }
//   //           }
//   //         });
//   //     answer.add(sliver);
//   //   });

//   //   return answer;
//   // }

//   // /* ======= PAGES ======= */

//   // Widget _homePageTab(BuildContext context, bloc) {
//   //   List<Widget> _slivers = [];

//   //   _slivers.add(_homePageNavigationBar(context));
//   //   _slivers.add(MediaQuery.removePadding(
//   //     context: context,
//   //     child: _topListView(context),
//   //     removeBottom: true,
//   //   ));
//   //   _slivers.add(_moderationList(context, bloc));
//   //   _slivers.addAll(_subscriptionList(context, bloc));
//   //   return CustomScrollView(slivers: _slivers);
//   // }
// }
