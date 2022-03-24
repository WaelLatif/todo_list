// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:todo_list/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  bool isPassword = false,
  bool isClickable = true,
  IconData? suffix,
  required String label,
  required IconData prefix,
  Function? onSubmit,
  Function? onTap,
  Function? suffixPressed,
  required String? Function(String?) validate,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: (s) {
        onSubmit!(s);
      },
      onTap: () {
        onTap!();
      },
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPressed!(), icon: Icon(suffix))
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(

        padding: const EdgeInsets.all(16.0),

        child: Row(

          children: [

            CircleAvatar(

              radius: 40.0,

              child: Text('${model['time']}'),

            ),

            SizedBox(

              width: 20.0,

            ),

            Expanded(

              child: Column(

                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(

                    '${model['title']}',

                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),

                  ),

                  Text(

                    '${model['date']}',

                    style: TextStyle(

                      color: Colors.grey,

                    ),

                  ),

                ],

              ),

            ),

            SizedBox(

              width: 20.0,

            ),

            IconButton(

              icon: Icon(

                Icons.check_circle_outline,

                color: Colors.green,

              ),

              onPressed: () {

                AppCubit.get(context).updateData(

                  status: 'done',

                  id: model['id'],

                );

              },

            ),

            IconButton(

              icon: Icon(Icons.archive_outlined),

              onPressed: () {

                AppCubit.get(context).updateData(

                  status: 'archive',

                  id: model['id'],

                );

              },

            ),

          ],

        ),

      ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
);
