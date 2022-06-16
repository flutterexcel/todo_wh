import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/authentication/googleSignIn.dart';
import 'package:todo/bloc/addBloc/addBloc.dart';
import 'package:todo/bloc/authBloc/authBloc.dart';
import 'package:todo/bloc/todoBloc/todoBloc.dart';
import 'package:todo/routes/routes.dart';
import 'package:todo/screens/todoPage.dart';

import 'screens/authScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
          BlocProvider<AddBloc>(create: (BuildContext context) => AddBloc()),
          BlocProvider<TodoBloc>(create: (BuildContext context) => TodoBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.onGenerateRoute,
          home: checkAuth(),
        ),
      );
    });
  }
}

checkAuth() {
  if (auth.currentUser != null) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: const TodoPage(),
    );
  } else {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const AuthScreen(),
    );
  }
}
