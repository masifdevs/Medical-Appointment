import 'package:flutter/material.dart';

class ImageReport extends StatelessWidget {
  final Report;

  const ImageReport({Key key, this.Report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Report['title']),
        ),
        body: Center(
          child: Image.network(Report['image']),
        ));
  }
}
