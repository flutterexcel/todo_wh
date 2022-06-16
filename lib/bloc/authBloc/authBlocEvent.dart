import 'package:flutter/cupertino.dart';

abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class SignInWithEmailEvent extends AuthEvent {
  String email;
  String password;
  BuildContext context;
  SignInWithEmailEvent(this.email, this.password, this.context);
}

class InvalidEmailEvent extends AuthEvent {}

class SignUpWithEmailEvent extends AuthEvent {
  String email;
  String password;
  String cPassword;
  String username;
  String url;
  BuildContext context;

  SignUpWithEmailEvent(this.email, this.password, this.cPassword, this.username,
      this.url, this.context);
}
