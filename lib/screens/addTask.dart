import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/authentication/googleSignIn.dart';
import 'package:todo/bloc/addBloc/addBloc.dart';
import 'package:todo/bloc/addBloc/addBlocEvent.dart';
import 'package:todo/screens/todoPage.dart';

import '../bloc/addBloc/addBlocState.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

TextEditingController _taskVal = TextEditingController();
String category = 'Uncategories';

addBarData(int val, String colorVal, String categ) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  String uid = user!.uid;
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(uid)
      .collection('barData')
      .doc(categ)
      .set({
    'type': categ,
    'value': val,
    'color': colorVal,
  });
}

addTaskToFirebase() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  String uid = user!.uid;
  var time = DateTime.now();
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(uid)
      .collection('mytask')
      .doc(time.toString())
      .set({
    'title': _taskVal.text,
    'timeStamp': time,
    'time': time.toString(),
    'category': category,
  });

  Fluttertoast.showToast(msg: 'Data Added');
}

class _AddTaskState extends State<AddTask> {
  final List<String> categoryList = [
    'Personal',
    'Work',
    'School',
    'Home',
    'Uncategories'
  ];

  @override
  Widget build(BuildContext context) {
    bool _isEmpty = false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 220, horizontal: 60),
      child: Card(
        elevation: 12,
        child: Container(
          color: Color.fromARGB(226, 49, 50, 23),
          height: 300,
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Add your tasks',
                    style: TextStyle(fontSize: 24, color: Colors.white70),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  BlocBuilder<AddBloc, AddState>(
                    builder: (context, state) =>
                        (state is TaskIsEmpty && _isEmpty)
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  state.errorMessage,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red.shade500),
                                ),
                              )
                            : Container(),
                  ),
                  TextField(
                    onChanged: (val) => BlocProvider.of<AddBloc>(context)
                        .add(TextOnchangeEvent(_taskVal.text)),
                    controller: _taskVal,
                    style: TextStyle(color: Colors.white70),
                    decoration: InputDecoration(
                        // label: Text(labelText),
                        // labelStyle: TextStyle(color: Colors.white),
                        hintText: 'eg. Complete Homework',
                        hintStyle: TextStyle(color: Colors.white30)),
                  ),
                  Center(
                    child: Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 0),
                      // color: Colors.amberAccent,
                      width: 300,
                      height: 60,

                      child: Center(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Color.fromARGB(226, 49, 50, 23),
                          ),
                          child: DropdownButton(
                              underline: Text(''), // fix this
                              hint: const Text("Category"),
                              value: category,
                              items: categoryList.map((String e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  category = newValue!;
                                });
                              }),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  BlocBuilder<AddBloc, AddState>(
                    builder: (context, state) {
                      return CupertinoButton(
                        child: Text("Add"),
                        color: Color.fromARGB(73, 84, 110, 122),
                        onPressed: () async {
                          {
                            if (_taskVal.text.isEmpty) {
                              BlocProvider.of<AddBloc>(context)
                                  .emit(TaskIsEmpty('Enter the task first'));
                              _isEmpty = true;
                              null;
                            } else {
                              await addTaskToFirebase();
                              await countCategory(category);
                              Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TodoPage(),
                                  ));
                              _taskVal.clear();
                            }
                          }
                        },
                      );
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

int val = 0;
int homeCount = 0,
    personalCount = 0,
    workCount = 0,
    schoolCount = 0,
    uncategoriesCount = 0;
countCategory(String Categoroy) async {
  String color = 'ff66cc';
  switch (Categoroy) {
    case "Home":
      {
        color = 'cc3300';
        homeCount++;
        await addBarData(homeCount, color, Categoroy);
        break;
      }
    case "Personal":
      {
        color = '3333ff';
        personalCount++;
        await addBarData(personalCount, color, Categoroy);
        break;
      }
    case "Work":
      {
        color = '009933';
        workCount++;
        await addBarData(workCount, color, Categoroy);
        break;
      }
    case "School":
      {
        color = 'ffcc00';
        schoolCount++;
        await addBarData(schoolCount, color, Categoroy);
        break;
      }
    default:
      {
        uncategoriesCount++;
        await addBarData(uncategoriesCount, color, Categoroy);
      }
  }
}

deleteCategory(String categoryType) async {
  String c = categoryType;
  String color = 'ff66cc';

  // return StreamBuilder(
  // stream: FirebaseFirestore.instance
  //     .collection('tasks')
  //     .doc(auth.currentUser!.uid)
  //     .collection('bardata')
  //     .where(category, isEqualTo: c)
  //     .snapshots(),
  // builder: ((context, snapshot) {
  //   if (snapshot.hasError) {
  //     return const Center(
  //       child: Text('Something went wrong'),
  //     );
  //   }
  //   if (snapshot.connectionState == ConnectionState.waiting) {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   }
  //   // final categData = snapshot.data!.docs;
  //   // print('barData >> : ${barData.length}');
  //   return addBarData(snapshot, colorVal, categ);
  // }));

  switch (c) {
    case "Home":
      {
        color = 'cc3300';
        await --homeCount;
        await addBarData(homeCount, color, c);
        break;
      }
    case "Personal":
      {
        color = '3333ff';

        await --personalCount;
        await addBarData(personalCount, color, c);
        break;
      }
    case "Work":
      {
        color = '009933';

        await --workCount;
        await addBarData(workCount, color, c);
        break;
      }
    case "School":
      {
        color = 'ffcc00';

        await --schoolCount;
        await addBarData(schoolCount, color, c);
        break;
      }
    default:
      {
        await --uncategoriesCount;
        await addBarData(uncategoriesCount, color, c);
      }
  }
}
