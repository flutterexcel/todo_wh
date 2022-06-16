import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/screens/authScreen.dart';
import 'package:todo/bloc/authBloc/authBloc.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/login":
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => AuthBloc(),
                  child: AuthScreen(),
                ));
    }
  }
}
