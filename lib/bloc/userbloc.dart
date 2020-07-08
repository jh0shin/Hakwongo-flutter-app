import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:kakao_flutter_sdk/common.dart';

// UserEvent & UserState
import 'package:equatable/equatable.dart'; // for compare two class obj
import 'package:meta/meta.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final UserApi _userApi;

  UserBloc({UserApi userApi}) : _userApi = userApi ?? UserApi.instance;

  @override
  UserState get initialState => UserUninitialized();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is AppStarted) {
      yield UserUninitialized();
      return;
    }

    if (event is UserFetchStarted) {
      try {
        final user = await _userApi.me();
        yield UserFetched(user);
      } on KakaoApiException catch (e) {
        if (e.code == ApiErrorCause.INVALID_TOKEN) {
          print('invalid token error occured=================================');
          yield UserLoggedOut();
        } else {
          yield UserFetchFailed(e);
        }
      } catch (e) {
        yield UserFetchFailed(e);
      }

      return;
    }

    if (event is UserLogOut) {
      await _userApi.logout();
      await AccessTokenStore.instance.clear();
      yield UserLoggedOut();
      return;
    }

    if (event is UserUnlink) {
      await _userApi.unlink();
      await AccessTokenStore.instance.clear();
      yield UserLoggedOut();
      return;
    }
  }
}

// UserEvent
@immutable
abstract class UserEvent extends Equatable {
  UserEvent([List props = const []]) : super(props);
}

class AppStarted extends UserEvent {
  @override
  String toString() => "AppStarted";
}

class UserFetchStarted extends UserEvent {
  @override
  String toString() => "UserFetchStarted";
}

class UserLogOut extends UserEvent {
  @override
  String toString() => runtimeType.toString();
}

class UserUnlink extends UserEvent {}

// UserState
@immutable
abstract class UserState extends Equatable {
  UserState([List props = const []]) : super(props);
}

class UserUninitialized extends UserState {
  @override
  String toString() => "UserUninitialized";
}

class UserLoggedOut extends UserState {}

class UserFetched extends UserState {
  final User user;

  UserFetched(this.user) : super([user]);

  @override
  String toString() => user.toString();
}

class UserFetchFailed extends UserState {
  final KakaoException exception;

  UserFetchFailed(this.exception) : super([exception]);

  @override
  String toString() => exception.toString();
}