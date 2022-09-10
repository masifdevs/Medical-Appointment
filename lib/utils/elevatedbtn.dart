import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';

class ElevatedBtn extends StatelessWidget {
  String text;
  Function onPress;

  ElevatedBtn({this.text, this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(grape),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ))),
        onPressed: onPress,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(getTranslated(context, text)),
        ));
  }
}
