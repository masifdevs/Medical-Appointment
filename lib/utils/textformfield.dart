import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';

class TextFormFieldCustom extends StatelessWidget {
  Function valid;
  TextEditingController controller;
  String labelText, hintText;
  bool isPhone, isEmail, isPass;

  TextFormFieldCustom(
      {this.valid,
      this.labelText,
      this.hintText,
      this.controller,
      this.isPass,
      this.isEmail,
      this.isPhone});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: grape,
      validator: valid,
      obscureText: isPass ? true : false,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isPhone
              ? TextInputType.phone
              : TextInputType.name,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: grape),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: grape),
              borderRadius: BorderRadius.circular(15)),
          labelText: labelText,
          hintText: hintText,
          labelStyle: Theme.of(context).textTheme.bodyText1,
          hintStyle: Theme.of(context).textTheme.bodyText1),
      style: Theme.of(context).textTheme.bodyText1,
    );
  }
}
