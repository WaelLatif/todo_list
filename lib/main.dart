// ignore_for_file: use_key_in_widget_constructors

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'components/constanse.dart';
import 'layout/home_layout.dart';

void main() {


  BlocOverrides.runZoned(
        () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
 }
}
