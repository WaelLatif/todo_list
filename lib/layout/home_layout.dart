// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
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

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();

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
            Navigator.pop(context);
            isBottomSheetShown = false;
            setState(() {
              fabIcon = Icons.edit;
            });
          } else {
            scaffoldkey.currentState?.showBottomSheet(
              (context) => Container(
                color: Colors.grey[100],
                padding: EdgeInsets.all(20.0),
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
                            context: context, initialTime: TimeOfDay.now(),
                        ).then((value) {
                             timeController.text = value!.format(context).toString();
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
                  ],
                ),
              ),
            );
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
        print('database opened');
      },
    );
  }

  void insertToDatabase() {
    database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("first task","02222","02:00 pm","new")')
          .then((value) {
        print('task No $value added successfully');
      }).catchError((error) {
        print('Error when Inserting ${error.toString()}');
      });
    });
  }
}
