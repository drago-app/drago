// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:drago/models/auth/accounts.dart';
import 'package:equatable/equatable.dart';

import 'package:drago/reddit_service.dart';

import 'core/error/failures.dart';

class UserStore {
  MyDatabase db;
  UserStore({required this.db});

  Future<void> createNewAccount(
      String name, String token, bool isSelected) async {
    await this.db.into(this.db.accounts).insert(AccountsCompanion.insert(
        name: name, token: token, isSelectedAccount: isSelected));
  }

  Future<void> saveAccounts(List<Account> accounts) async {
    await Future.forEach(
        accounts,
        (Account acct) async =>
            // await this.db.into(this.db.accounts).insert(acct));
            this.db.update(this.db.accounts).write(acct));
  }

  Future<List<Account>> getAccounts() async {
    return await this.db.select(this.db.accounts).get();
  }

  Future<Account?> getSelectedAccount() async {
    List<Account> accts = await (this.db.select(this.db.accounts)
          ..where((tbl) => tbl.isSelectedAccount))
        .get();

    if (accts.isEmpty) {
      return null;
    }
    return accts.first;
  }
}

class UserService {
  final RedditService reddit;
  final UserStore userStore;

  UserService({required this.reddit, required this.userStore});

  Future<bool> isUserLoggedIn() async {
    final Account? maybeAccount = await this.userStore.getSelectedAccount();

    if (maybeAccount == null) {
      return false;
    }

    await this.reddit.currentUser();
    return true;
  }

  Future<Either<Failure, AuthenticatedUser>> logIn() async {
    try {
      AuthenticatedUser user = await this.reddit.loginWithNewAccount();

      final List<Account> accts = await this.userStore.getAccounts();

      final modifiedAccts = accts
          .map((Account a) => a.copyWith(isSelectedAccount: false))
          .toList();

      this.userStore.saveAccounts(modifiedAccts);
      this.userStore.createNewAccount(user.name, user.token, true);
      return Right(user);
    } catch (e) {
      return Left(
          AuthFailure(message: "UserService#logIn ::: ${e.toString()}"));
    }
  }

  Future<Either<Failure, Account>> getCurrentUser() async {
    try {
      Account? acct = await this.userStore.getSelectedAccount();
      if (acct == null) {
        await this.reddit.initializeWithoutAuth();
        return Left(SomeFailure(message: "No accounts found!"));
      }

      final newToken = this.reddit.initializeWithAuth(acct.token);
      acct = acct.copyWith(token: newToken);
      this.userStore.saveAccounts([acct]);

      return Right(acct);
    } catch (e) {
      print(e.toString());
      return Left(
          AuthFailure(message: "UserService#getCurrentUser ::: ${e.toString}"));
    }
    // try {
    //   final allAccounts = await this.userStore.getAccounts();
    //   print('');

    //   for (var acct in allAccounts.accounts.entries) {
    //     if (acct.value.isCurrent) {
    //       final newToken = this.reddit.initializeWithAuth(acct.value.token);

    //       acct.value.updateToken(newToken);
    //       this.userStore.saveAccounts(allAccounts);
    //       return Right(acct.value);
    //     }
    //   }
    //   await this.reddit.initializeWithoutAuth();
    //   return Left(SomeFailure(message: "No accounts found"));
    // } catch (e) {
    //   return Left(
    //       SomeFailure(message: "Something went wrong! ${e.toString()}"));
    // }
  }
}

class AuthenticatedUser extends Equatable {
  final String name;
  final String token;
  const AuthenticatedUser({
    required this.name,
    required this.token,
  });

  AuthenticatedUser copyWith({
    String? name,
    String? token,
    bool? isCurrent,
  }) {
    return AuthenticatedUser(
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'token': token,
    };
  }

  factory AuthenticatedUser.fromMap(Map<String, dynamic> map) {
    return AuthenticatedUser(
      name: map['name'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthenticatedUser.fromJson(String source) =>
      AuthenticatedUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name, token];
}
