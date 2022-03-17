// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
Widget defaultFormField
    (
    {
      required TextEditingController controller,
      required TextInputType keyboardType,
      bool isPassword = false,
      bool isClickable = true,
      IconData? suffix,
      required String label,
      required IconData prefix,
      Function(String)? onSubmit,
      Function()? onTap,
      Function()? suffixPressed,
      required String? Function(String?) validate,
    }) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem()=> Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 40.0,
        child: Text('2.00 pm'),
      ),
      SizedBox(
        width: 20.0,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Task Title',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
            ),

          ),
          Text(
            'April 2 ,2022 ',
            style: TextStyle(
              color: Colors.grey,
            ),

          ),
        ],
      ),
    ],
  ),
);