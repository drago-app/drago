import 'package:drago/reddit_service.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const _lastLoggedin = 'lastLoggedIn';
  static const _accounts = 'accounts';

  // SharedPreferences prefs;
  final RedditService reddit;

  UserService({required this.reddit});

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_lastLoggedin);
  }

  Future<AuthUser> logIn() async {
    final prefs = await SharedPreferences.getInstance();
    AuthUser authUser = await reddit.loginWithNewAccount();
    final users = (prefs.containsKey(_accounts))
        ? prefs
            .getStringList(_accounts)
            .map((account) => AuthUser.fromJson(jsonDecode(account)))
            .toList()
        : [];

    users.add(authUser);
    final List<String> usersAsString =
        users.map<String>((user) => user.toJson()).toList();

    prefs.setStringList(_accounts, usersAsString);
    prefs.setString(_lastLoggedin, authUser.toJson());
    return authUser;
  }

  Future<User> loggedInUser() async {
    // (Donovan)  this function needs to be refactored
    final prefs = await SharedPreferences.getInstance();

    try {
      AuthUser userLastLoggedIn =
          AuthUser.fromJson(jsonDecode(prefs.getString(_lastLoggedin)));
      reddit.initializeWithAuth(userLastLoggedIn.token);
      prefs.setString(_lastLoggedin, userLastLoggedIn.toJson());
      return userLastLoggedIn;
    } catch (e) {
      try {
        final users = prefs
            .getStringList(_accounts)
            .map((account) => AuthUser.fromJson(jsonDecode(account)));
        reddit.initializeWithAuth(users.last.token);
      } catch (e) {
        await reddit.initializeWithoutAuth();
        return UnAuthUser();
      }
    }
    return UnAuthUser();
  }
}

abstract class User extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthUser extends User {
  final String name;
  final String token;

  AuthUser({required this.name, required this.token});

  @override
  List<Object> get props => [name, token];

  AuthUser copyWith({String? name, String? token}) {
    return AuthUser(name: name ?? this.name, token: token ?? this.token);
  }

  String toJson() {
    final Map<String, dynamic> asMap = {'name': name, 'token': token};
    return json.encode(asMap);
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(name: json['name'], token: json['token']);
  }
}

class UnAuthUser extends User {}
