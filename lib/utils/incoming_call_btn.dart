import 'package:flutter/material.dart';

class IncomingCallBtn extends StatelessWidget {
  Color color;
  String text;

  IncomingCallBtn({this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 120,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: Center(
          child: Text(
        text,
        style: Theme.of(context).textTheme.headline5,
      )),
    );
  }
}
