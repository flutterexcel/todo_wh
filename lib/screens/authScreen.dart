import 'dart:developer';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/bloc/authBloc/authBloc.dart';
import 'package:todo/bloc/authBloc/authBlocEvent.dart';
import '../Widgets/appText.dart';
import '../authentication/googleSignIn.dart';

import '../bloc/authBloc/authBlocState.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _passwordController2 = TextEditingController();
TextEditingController _cPasswordController = TextEditingController();
TextEditingController _usernameController = TextEditingController();

class _AuthScreenState extends State<AuthScreen> {
  File? image;
  late String url;
  Future<dynamic> pickImageWithGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No File Selected.')));
        return null;
      } else {
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child(_usernameController.text + '.jpg');
        await ref.putFile(File(image.path));
        url = await ref.getDownloadURL();
        log('photo url $url');
      }
      final imageTemporary = File(image.path);

      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  Future<dynamic> pickImageWithCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        return ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No File Selected.')));
      } else {
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child(_usernameController.text + '.jpg');
        await ref.putFile(File(image.path));
        url = await ref.getDownloadURL();
        print('photo url $url');
      }
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  bool _isSignUp = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color.fromARGB(226, 49, 50, 23),
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is SignInState) {
              await signIn(context);
            }
          },
          child: Container(
            color: Colors.transparent,
            height: 480,
            width: 320,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _isSignUp
                        ? Column(
                            children: [
                              Stack(children: [
                                image != null
                                    ? Container(
                                        height: 80,
                                        width: 80,
                                        child: ClipOval(
                                            child: Material(
                                          child: Image.file(
                                            image!,
                                            fit: BoxFit.cover,
                                          ),
                                        )))
                                    : Container(
                                        height: 80,
                                        width: 80,
                                        child: const ClipOval(
                                            child: Material(
                                                shadowColor: Color(0xfff0932b),
                                                color: Color.fromARGB(
                                                    226, 49, 50, 23),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ))),
                                      ),
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      child: Text('Gallery'),
                                      value: 'g',
                                    ),
                                    const PopupMenuItem(
                                      child: Text('Camera'),
                                      value: 'c',
                                    ),
                                  ],
                                  onSelected: (String v) {
                                    setState(() {
                                      if (v == 'g') {
                                        pickImageWithGallery();
                                      } else {
                                        pickImageWithCamera();
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    margin: const EdgeInsets.only(
                                        top: 50, left: 52),
                                    child: const Align(
                                      alignment: Alignment.bottomRight,
                                      child: ClipOval(
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white70,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'Upload image',
                                style: TextStyle(
                                    color: Colors.white30, fontSize: 14),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              new Icon(
                                Icons.today_outlined,
                                color: Color.fromARGB(255, 205, 127, 17),
                                size: 44,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                " T O D O ",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                            ],
                          ),
                    Card(
                      elevation: 22,
                      color: Color.fromARGB(226, 49, 50, 23),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) =>
                                        (state is InvalidEmailState)
                                            ? Text(
                                                "Enter a valid email",
                                                style: TextStyle(
                                                    color: Colors.red.shade300),
                                              )
                                            : Container(),
                                  ),
                                  _isSignUp
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: TextField(
                                            controller: _usernameController,
                                            style:
                                                TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                color: Color(0xfff0932b),
                                              )),
                                              border: UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                color: Colors.red,
                                              )),
                                              hintText: 'create username',
                                              hintStyle: TextStyle(
                                                  color: Colors.white12),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextField(
                                      controller: _emailController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                          color: Color(0xfff0932b),
                                        )),
                                        border: UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                          color: Colors.red,
                                        )),
                                        hintText: 'email',
                                        hintStyle:
                                            TextStyle(color: Colors.white12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextField(
                                      controller: _isSignUp
                                          ? _passwordController2
                                          : _passwordController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                          color: Color(0xfff0932b),
                                        )),
                                        border: UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                          color: Colors.red,
                                        )),
                                        hintText: 'password',
                                        hintStyle:
                                            TextStyle(color: Colors.white12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _isSignUp
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: TextField(
                                            controller: _cPasswordController,
                                            style:
                                                TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                color: Color(0xfff0932b),
                                              )),
                                              border: UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                color: Colors.red,
                                              )),
                                              hintText: 'confirm password',
                                              hintStyle: TextStyle(
                                                  color: Colors.white12),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      return CupertinoButton(
                                          color:
                                              Color.fromARGB(73, 84, 110, 122),
                                          child: Text(
                                            _isSignUp ? 'Sign up' : 'Sign in',
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          onPressed: () async {
                                            bool _isValidEmail =
                                                EmailValidator.validate(
                                                    _emailController.text);
                                            _isValidEmail
                                                ? {
                                                    _isSignUp
                                                        ? {
                                                            print(url),
                                                            BlocProvider.of<
                                                                        AuthBloc>(
                                                                    context)
                                                                .add(SignUpWithEmailEvent(
                                                                    _emailController
                                                                        .text
                                                                        .trim(),
                                                                    _passwordController2
                                                                        .text
                                                                        .trim(),
                                                                    _cPasswordController
                                                                        .text
                                                                        .trim(),
                                                                    _usernameController
                                                                        .text
                                                                        .trim(),
                                                                    url,
                                                                    context))
                                                          }
                                                        : BlocProvider.of<
                                                                    AuthBloc>(
                                                                context)
                                                            .add(SignInWithEmailEvent(
                                                                _emailController
                                                                    .text
                                                                    .trim(),
                                                                _passwordController
                                                                    .text
                                                                    .trim(),
                                                                context))
                                                  }
                                                : BlocProvider.of<AuthBloc>(
                                                        context)
                                                    .add(InvalidEmailEvent());
                                          });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            BlocProvider.of<AuthBloc>(context)
                                                .add(SignInEvent());

                                            print('sign in');
                                          },
                                          child: Row(
                                            children: [
                                              AppText(
                                                text: "Sign in with",
                                                color: Colors.white60,
                                                size: 12,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration:
                                                      const BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/google.png"),
                                                  ))),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            BlocProvider.of<AuthBloc>(context)
                                                .add(AuthInitialEvent());
                                            _isSignUp = !_isSignUp;
                                            print('user change');
                                            clearAuthController();
                                          },
                                          child:
                                              BlocBuilder<AuthBloc, AuthState>(
                                            builder: (context, state) {
                                              return Text(
                                                _isSignUp
                                                    ? 'Already a user'
                                                    : 'New User ?',
                                                style: const TextStyle(
                                                    color: Colors.white60),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ));
  }
}

clearAuthController() {
  _usernameController.clear();
  _emailController.clear();
  _passwordController.clear();
  _passwordController2.clear();
  _cPasswordController.clear();
}
