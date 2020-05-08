import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helius/blocs/blocs.dart';
import 'package:helius/blocs/simple_bloc_delegate.dart';
import 'package:helius/blocs/subreddit_page_bloc/subreddit_page.dart';

import 'package:helius/features/submission/usecases.dart';
import 'package:helius/reddit_service.dart';

import 'common/common.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/user/usecases.dart';
import 'screens/screens.dart';

final RedditService _reddit = RedditService();
final GetUsersSubscriptions _getUsersSubscriptions =
    GetUsersSubscriptions(reddit: _reddit);
final GetUsersModerations _getUsersModerations =
    GetUsersModerations(reddit: _reddit);
final UpvoteOrClear upvoteOrClear = UpvoteOrClear(reddit: _reddit);
final DownvoteOrClear downvoteOrClear = DownvoteOrClear(reddit: _reddit);
final SaveOrUnsaveSubmission saveOrUnsave =
    SaveOrUnsaveSubmission(reddit: _reddit);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocSupervisor.delegate = SimpleBlocDelegate();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (context) {
          return AppBloc(reddit: _reddit)..add(AppStarted());
        }),
      ],
      child: CupertinoApp(
        theme: CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: null,
            primaryContrastingColor: null,
            textTheme: CupertinoTextThemeData(
                textStyle: null,
                actionTextStyle: null,
                tabLabelTextStyle: null,
                navTitleTextStyle: null,
                navLargeTitleTextStyle: null,
                navActionTextStyle: null,
                pickerTextStyle: null,
                dateTimePickerTextStyle: null),
            barBackgroundColor: null,
            scaffoldBackgroundColor: null),
        home: BlocBuilder<AppBloc, AppState>(
          builder: (context, AppState state) {
            if (state is AppInitializing) {
              return Center(child: LoadingIndicator());
            } else if (state is AppUnauthenticated) {
              return Center(
                child: Text("APPBLOC STATE IS APPUNAUTHENTICATED"),
              );
            } else if (state is AppInitialized) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<HomePageBloc>(create: (context) {
                    return HomePageBloc(
                        getUsersModerations: _getUsersModerations,
                        getUsersSubscriptions: _getUsersSubscriptions)
                      ..add(UserAuthenticated());
                  }),
                  BlocProvider<AccountPageBloc>(create: (context) {
                    return AccountPageBloc();
                  })
                ],
                child: _scaffold(),
              );
            }
          },
        ),
      ),
    );
  }
}

Widget _scaffold() {
  return CupertinoTabScaffold(
    tabBar: CupertinoTabBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.news_solid),
          title: Text('Post'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.mail_solid),
          title: Text('Inbox'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: Text('Accounts'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.search),
          title: Text('Search'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.settings_solid),
          title: Text('Settings'),
        ),
      ],
    ),
    tabBuilder: (context, index) {
      switch (index) {
        case 0:
          return CupertinoTabView(
              onGenerateRoute: RouteGenerator.generateRoute,
              builder: (context) {
                return HomePage();
              });
        case 1:
          return CupertinoTabView(builder: (context) {
            return CupertinoPageScaffold(
              child: InboxPage(),
            );
          });
        case 2:
          return CupertinoTabView(builder: (context) {
            return AccountsPage();
          });
        case 3:
          return CupertinoTabView(builder: (context) {
            return CupertinoPageScaffold(
              child: InboxPage(),
            );
          });
        case 4:
          return CupertinoTabView(builder: (context) {
            return CupertinoPageScaffold(
              child: InboxPage(),
            );
          });
        default:
          return Placeholder();
      }
    },
  );
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/subreddit':
        return CupertinoPageRoute(
          builder: (context) => BlocProvider<SubredditPageBloc>(
            create: (context) =>
                SubredditPageBloc(reddit: _reddit, subreddit: args as String)
                  ..add(LoadSubmissions()),
            child: SubredditPage(),
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
