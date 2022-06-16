import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/authentication/authentication.dart';
import 'package:todo/authentication/googleSignIn.dart';
import 'package:todo/bloc/authBloc/authBlocEvent.dart';
import 'package:todo/bloc/authBloc/authBlocState.dart';
import '../../models/addImageUrl.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthInitialEvent>((event, emit) async {
      return emit(AuthInitialState());
      // TODO: implement event handler
    });
    on<SignInEvent>((event, emit) async {
      return emit(SignInState());
      // TODO: implement event handler
    });

    on<SignOutEvent>((event, emit) async {
      await signOut();
      return emit(SignOutState());
      // TODO: implement event handler
    });

    on<SignInWithEmailEvent>(((event, emit) async {
      await signInUsingEmailAndPassword(
          event.email, event.password, event.context);
      return emit(SignInWithEmailState());
    }));

    on<InvalidEmailEvent>(((event, emit) {
      return emit(InvalidEmailState());
    }));
    on<SignUpWithEmailEvent>(((event, emit) async {
      // print("object");
      // await addImageUrl(event.url);
      await signUp(event.email, event.password, event.cPassword, event.username,
          event.url, event.context);

      return emit(SignUpWithEmailState());
    }));
  }
}
