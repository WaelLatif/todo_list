import 'package:flutter/material.dart';
Widget defaultFormField
    (
    {
      required TextEditingController controller,
      required TextInputType keyboardType,
      bool isPassword = false,
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