import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/Widgets/appText.dart';
import 'package:todo/bloc/todoBloc/todoBloc.dart';
import 'package:todo/bloc/todoBloc/todoEvent.dart';
import 'package:todo/providers/todoProvider.dart';
import '../Widgets/barChart.dart';
import '../authentication/googleSignIn.dart';
import '../bloc/addBloc/addBloc.dart';
import '../bloc/todoBloc/todoState.dart';
import 'addTask.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  String uid = '';
  bool _isAuth = false;
  @override
  void initState() {
    // TODO: implement initState
    getuid();
    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // final User? user = await auth.currentUser;
    setState(() {
      uid = auth.currentUser!.uid;
      _isAuth = true;
    });
  }

  final List<String> categoryList = [
    'All tasks',
    'Personal',
    'Home',
    'Work',
    'School',
    'Uncategories'
  ];
  bool _alltaskTab = true;
  List<bool> boolItems = [];
  // late bool aa;

  String C = 'All tasks';
  Widget build(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return _isAuth
        ? Scaffold(
            backgroundColor: Color.fromARGB(226, 49, 50, 23),
            appBar: AppBar(
              backgroundColor: const Color(0xfff0932b),
              title: const Text("Todo"),
              actions: [
                IconButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => BarCharts())));
                    },
                    icon: Icon(
                      Icons.bar_chart,
                      color: Colors.white,
                    )),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => profileCard(context),
                    );
                  },
                  child: showProfile(context),
                ),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
            body: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 42,
                        child: ListView.builder(
                            itemCount: categoryList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  BlocProvider.of<TodoBloc>(context)
                                      .add(TodoShowEvent(categoryList[index]));
                                  C = categoryList[index];
                                },
                                child: BlocBuilder<TodoBloc, TodoState>(
                                  builder: (context, state) {
                                    return Container(
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: categoryList[index] != C
                                            ? Color.fromARGB(187, 240, 148, 43)
                                            : const Color(0xfff0932b),
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(
                                          color: categoryList[index] != C
                                              ? Color.fromARGB(
                                                  187, 240, 148, 43)
                                              : const Color(0xfff0932b),
                                        ),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        child: AppText(
                                          text: categoryList[index],
                                          size: 20,
                                          color: _alltaskTab
                                              ? Color.fromARGB(
                                                  255, 255, 255, 255)
                                              : Color.fromARGB(
                                                  255, 192, 181, 181),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }))),
                BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is ShowCategoryTaskState) {
                      return getCategoryData(state.catg);
                    } else {
                      return getAllTasks(context);
                    }
                  },
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xfff0932b),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocProvider(
                        create: (context) => AddBloc(),
                        child: AddTask(),
                      );
                    });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        : Container(
            height: 10,
            width: 10,
            child: const CircularProgressIndicator(
              color: Color(0xfff0932b),
              strokeWidth: 6,
            ));
  }

  deleteData(final d) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytask')
        .doc(d)
        .delete();
    print('deleted');
  }

  // Future<List<dynamic>> giveSnapshot() async {
  //   final list = await FirebaseFirestore.instance
  //       .collection('tasks')
  //       .doc(uid)
  //       .collection('mytask')
  //       .get();
  //   List docs = list.docs;
  //   return docs;
  // }

  getCategoryData(String c) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(uid)
            .collection('mytask')
            .where('category', isEqualTo: c)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 10,
              width: 10,
              child: const Center(
                child: const CircularProgressIndicator(
                  color: Color(0xfff0932b),
                  strokeWidth: 6,
                ),
              ),
            );
          } else {
            print('In category sections >>>');
            final docs = snapshot.data!.docs;
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xffffbe76),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(top: 4, left: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(docs[index]['title'],
                                      style: boolItems[index]
                                          ? const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.black,
                                              fontSize: 22)
                                          : const TextStyle(
                                              decoration: null,
                                              color: Colors.black,
                                              fontSize: 22)),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                // Text(DateFormat('hh:mm').format(time)),
                                Container(
                                  child: Text(
                                    c,
                                    style: GoogleFonts.roboto(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  child: Checkbox(
                                    checkColor: Colors.amber,
                                    value: boolItems[index],
                                    onChanged: (bool? value) async {
                                      bool aa = boolItems[index];
                                      setState(() {
                                        BlocProvider.of<TodoBloc>(context)
                                            .add(TaskIsCompletedEvent());
                                        if (State is TaskIsCompletedState) {
                                          print(
                                              'In task is completed state <<< ');
                                        }
                                        print('holla');
                                        boolItems[index] = !boolItems[index];
                                      });
                                    },
                                  ),
                                ),
                                boolItems[index]
                                    ? Container(
                                        child: IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            try {
                                              await deleteCategory(docs[index]
                                                      ['category']
                                                  .toString());

                                              await deleteData(
                                                  docs[index]['time']);

                                              print('deleted');
                                            } catch (e) {
                                              print('error: ');
                                            }
                                          },
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  getAllTasks(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(uid)
            .collection('mytask')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 10,
              width: 10,
              child: const Center(
                child: const CircularProgressIndicator(
                  color: Color(0xfff0932b),
                  strokeWidth: 6,
                ),
              ),
            );
          } else {
            final docs = snapshot.data!.docs;
            print('In all tasks >> ');
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  boolItems.add(false);

                  // ChangeNotifierProvider<todoProvider>(
                  //                 create: (context) => todoProvider(),
                  //                 child: Consumer<todoProvider>(
                  //                     builder: (context, provider, child)

                  return ChangeNotifierProvider<todoProvider>(
                      create: (context) => todoProvider(),
                      child: Consumer<todoProvider>(
                          builder: (context, provider, child) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: boolItems[index]
                                ? Color.fromARGB(193, 255, 191, 118)
                                : const Color(0xffffbe76),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(top: 4, left: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocBuilder<TodoBloc, TodoState>(
                                builder: (context, state) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(docs[index]['title'],
                                                style: boolItems[index]
                                                    ? const TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color: Colors.black,
                                                        fontSize: 22)
                                                    : const TextStyle(
                                                        decoration: null,
                                                        color: Colors.black,
                                                        fontSize: 22)),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Container(
                                            child: Text(
                                              docs[index]['category'],
                                              style: GoogleFonts.roboto(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Checkbox(
                                              checkColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              activeColor: Colors.blueGrey,
                                              focusColor: Colors.red,
                                              value: boolItems[index],
                                              onChanged: (bool? value) async {
                                                boolItems[index] =
                                                    Provider.of<todoProvider>(
                                                            context,
                                                            listen: false)
                                                        .checkComplition(
                                                            boolItems[index]);
                                              },
                                            ),
                                          ),
                                          boolItems[index]
                                              ? Container(
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    onPressed: () async {
                                                      try {
                                                        Provider.of<todoProvider>(
                                                                context)
                                                            .resetBool(
                                                                boolItems[
                                                                    index]);
                                                        await deleteCategory(
                                                            docs[index]
                                                                    ['category']
                                                                .toString());

                                                        await deleteData(
                                                            docs[index]
                                                                ['time']);

                                                        print('deleted');
                                                      } catch (e) {
                                                        print('error: $e ');
                                                      }
                                                    },
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }));
                });
          }
        },
      ),
    );
  }
}

Widget profileCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 240, horizontal: 60),
    child: Card(
      // title: Text('profile
      color: Color.fromARGB(200, 240, 148, 43),
      child: Container(
        height: 200,
        width: 300,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 26,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await signOut();
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/login');
                },
                icon: Icon(
                  Icons.exit_to_app,
                  size: 26,
                ),
              ),
            ]),
            showCardProfile(context),
            SizedBox(
              height: 8,
            ),
            showUserName(context),
          ],
        ),
      ),
    ),
  );
}

showCardProfile(BuildContext context) {
  if (auth.currentUser?.photoURL != null) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipOval(
        child: Material(
          child: Image.network(
            "${auth.currentUser?.photoURL}",
            fit: BoxFit.fill,
            height: 100,
            width: 100,
          ),
        ),
      ),
    );
  } else {
    return Icon(Icons.account_circle, size: 50);
  }
}
