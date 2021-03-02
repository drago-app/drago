import 'package:dartz/dartz.dart';
import 'package:drago/draw_reddit_adapter.dart';
import 'package:drago/features/comment/get_comments.dart';
import 'package:drago/features/comment/get_more_comments.dart';
import 'package:drago/features/subreddit/subscribe_to_subreddit.dart';
import 'package:drago/models/sort_option.dart';
import 'package:drago/theme.dart';
import 'package:drago/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drago/blocs/blocs.dart';
import 'package:drago/blocs/simple_bloc_delegate.dart';
import 'package:drago/blocs/subreddit_page_bloc/subreddit_page.dart';

import 'package:drago/features/submission/usecases.dart';
import 'package:drago/reddit_service.dart';

import 'blocs/submission_bloc.dart/submission.dart';
import 'comments_page_factory.dart';
import 'common/common.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'dialog/dialog_manager.dart';
import 'dialog/dialog_provider.dart';
import 'dialog/dialog_service.dart';
import 'features/subreddit/get_submissions.dart';
import 'features/user/usecases.dart';
import 'screens/screens.dart';

final RedditClient _redditClient = DrawRedditClient();

final RedditService _reddit = RedditService(redditClient: _redditClient);

final UserService _userService = UserService(reddit: _reddit);

final GetDefaultSubreddits _getDefaultSubreddits =
    GetDefaultSubreddits(reddit: _reddit);

final GetUsersSubscriptions _getUsersSubscriptions =
    GetUsersSubscriptions(reddit: _reddit);

final GetUsersModerations _getUsersModerations =
    GetUsersModerations(reddit: _reddit);

final UpvoteOrClear upvoteOrClear =
    UpvoteOrClear(reddit: _reddit, userService: _userService);

final DownvoteOrClear downvoteOrClear =
    DownvoteOrClear(reddit: _reddit, userService: _userService);

final SaveOrUnsaveSubmission saveOrUnsave =
    SaveOrUnsaveSubmission(reddit: _reddit, userService: _userService);

final GetRedditLinks getRedditLinks = GetRedditLinks(reddit: _reddit);
final GetComments getComments = GetComments(reddit: _reddit);
final GetMoreComments getMoreComments = GetMoreComments(reddit: _reddit);
final SubscribeToSubreddit subscribeToSubreddit =
    SubscribeToSubreddit(reddit: _reddit);
final SubscribeToSubredditAction subscribeToSubredditAction =
    SubscribeToSubredditAction(subscribeToSubreddit);
final ActionService actionService = ActionService()
  ..add(subscribeToSubredditAction);

List<ActionableFn> filterFns = filters
    .map((filter) =>
        (sort) => SubmissionFilterAction(getRedditLinks, sort, filter))
    .toList(growable: false);

final ActionService<SortSubmissionsAction> sortActionService = ActionService()
  ..add(SortSubmissionsAction(getRedditLinks, hotSubmissionSort))
  ..add(SortSubmissionsAction(getRedditLinks, newestSubmissionSort))
  ..add(SortSubmissionsAction(getRedditLinks, controversialSubmissionSort,
      filterFnsOption: Some(filterFns)))
  ..add(SortSubmissionsAction(getRedditLinks, topSubmissionSort,
      filterFnsOption: Some(filterFns)))
  ..add(SortSubmissionsAction(getRedditLinks, risingSubmissionSort));

final DialogService _dialogService = DialogService();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc.observer = SimpleBlocDelegate();

    return MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(create: (context) {
            return AppBloc(reddit: _reddit, userService: _userService)
              ..add(AppStarted());
          }),
        ],
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppInitializing || state is AppUninitialized) {
              return Center(child: LoadingIndicator());
            } else if (state is AppInitializedWithAuthUser) {
              return AuthenticatedApp();
            } else {
              return UnAuthenticatedApp();
            }
          },
        ));
  }
}

class UnAuthenticatedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: appThemeData[AppTheme.light],
      home: DialogProvider(
        service: _dialogService,
        child: DialogManager(
          dialogService: _dialogService,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<HomePageBloc>(create: (context) {
                return HomePageBloc(
                  dialogService: _dialogService,
                  getUsersModerations: _getUsersModerations,
                  getUsersSubscriptions: _getUsersSubscriptions,
                  getDefaultSubreddits: _getDefaultSubreddits,
                )..add(UserNotAuthenticated());
              }),
              // BlocProvider<AccountPageBloc>(create: (context) {
              //   return AccountPageBloc();
              // })
            ],
            child: _unAuthscaffold(),
          ),
        ),
      ),
    );
  }
}

Widget _unAuthscaffold() {
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
            },
          );
        case 1:
          return CupertinoTabView(
            builder: (context) {
              return CupertinoPageScaffold(
                child: UnauthenticatedInboxPage(),
              );
            },
          );
        case 2:
          return CupertinoTabView(
            builder: (context) {
              return UnauthenticatedAccountsPage();
            },
          );
        case 3:
          return CupertinoTabView(
            builder: (context) {
              return CupertinoPageScaffold(
                child: InboxPage(),
              );
            },
          );
        case 4:
          return CupertinoTabView(
            builder: (context) {
              return CupertinoPageScaffold(
                child: InboxPage(),
              );
            },
          );
        default:
          return Placeholder();
      }
    },
  );
}

class AuthenticatedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: appThemeData[AppTheme.light],
      home: DialogProvider(
        service: _dialogService,
        child: DialogManager(
          dialogService: _dialogService,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<HomePageBloc>(create: (context) {
                return HomePageBloc(
                  dialogService: _dialogService,
                  getUsersModerations: _getUsersModerations,
                  getUsersSubscriptions: _getUsersSubscriptions,
                  getDefaultSubreddits: _getDefaultSubreddits,
                )..add(UserAuthenticated());
              }),
              BlocProvider<AccountPageBloc>(create: (context) {
                return AccountPageBloc();
              })
            ],
            child: _scaffold(),
          ),
        ),
      ),
    );
  }

  Widget _scaffold() {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.today),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.envelope_fill),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings_solid),
            label: 'Settings',
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
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/subreddit':
        return CupertinoPageRoute(
          builder: (context) => BlocProvider<SubredditPageBloc>(
            create: (context) => SubredditPageBloc(
                getRedditLinks: getRedditLinks,
                subreddit: args as String,
                actionService: actionService,
                sortActionsService: sortActionService)
              ..add(LoadSubmissions()),
            child: SubredditPage(),
          ),
        );
      case '/comments':
        return CupertinoPageRoute(
          builder: (context) => BlocProvider<CommentsPageBloc>(
            child: CommentsPageFactory(
              submissionBloc: args as SubmissionBloc,
            ),
            create: (BuildContext context) => CommentsPageBloc(
                getComments: getComments,
                reddit: _reddit, // Bloc shouldnlt have access to _reddit
                submission: (args as SubmissionBloc).state.submission)
              ..add(LoadComments()),
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
