// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/components.dart';
import 'package:todo_list/modules/archived_tasks_screen.dart';
import 'package:todo_list/modules/done_tasks_screen.dart';
import 'package:todo_list/modules/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  late Database database;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  List<Map> tasks = [];

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Center(child: Text(titles[currentIndex])),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formkey.currentState!.validate()) {
              insertToDatabase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                  titleController.clear();
                  dateController.clear();
                  timeController.clear();
                });
              });
            }
          } else {
            scaffoldkey.currentState
                ?.showBottomSheet(
                  (context) => Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //title tapppp
                          defaultFormField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'title must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Title',
                            prefix: Icons.title,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          //time tapppp
                          defaultFormField(
                            controller: timeController,
                            keyboardType: TextInputType.datetime,
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timeController.text =
                                    value!.format(context).toString();
                              });
                            },
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'time must not be empty';
                              }
                              return null;
                            },
                            label: 'Task time',
                            prefix: Icons.watch_later_outlined,
                          ),

                          SizedBox(
                            height: 15.0,
                          ),
                          //date tapppp
                          defaultFormField(
                            controller: dateController,
                            keyboardType: TextInputType.datetime,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2022-05-03'),
                              ).then(
                                (value) {
                                  dateController.text =
                                      DateFormat.yMMMMd().format(value!);
                                },
                              );
                            },
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Date must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Date',
                            prefix: Icons.calendar_today,
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 20.0,
                )
                .closed
                .then((value) {
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
                titleController.clear();
                dateController.clear();
                timeController.clear();
              });
            });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
              ),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle_outline,
              ),
              label: 'Done',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.archive_outlined,
              ),
              label: 'Archive',
            ),
          ]),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database).then((value) {
          tasks = value;
        });

        print('database opened');
      },
    );
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('task No $value Added successfully');
      }).catchError((error) {
        print('Error when Inserting ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}
