import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/services/repo.dart';
import 'package:intl/intl.dart';

class MyDialog extends StatefulWidget {
  final String title;
  MyDialog({this.title});
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  String pickedFile = "", pickedFilepdf, fileType;
  File pathPicked;
  bool _isButtonDisabled;

  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  DateTime _startDate;

  @override
  void initState() {
    _isButtonDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: new SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new TextField(
              controller: titleController,
              autofocus: true,
              decoration:
                  new InputDecoration(labelText: '${widget.title} Title'),
            ),
            new TextField(
              controller: dateController,
              onTap: () {
                _selectDate(context);
              },
              autofocus: true,
              decoration:
                  new InputDecoration(labelText: '${widget.title} Date'),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _getFileFromStorage,
                    child: Container(
                        decoration: BoxDecoration(
                            color: grape,
                            borderRadius: BorderRadius.circular(4)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Pick File/Image",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: white),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Container(
                    color: white,
                    child: pickedFile != "" ? Text(pickedFile) : Text(""),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    child: const Text('CANCEL',
                        style: TextStyle(color: grape, fontSize: 14)),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    child: const Text(
                      'OK',
                      style: TextStyle(color: grape, fontSize: 14),
                    ),
                    onTap: () {
                      if (_isButtonDisabled) {
                        print('here');
                      } else {
                        addReport();
                      }
                    }),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  _getFileFromStorage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        pickedFile = file.name;
        fileType = file.extension;
        pathPicked = File(file.path);
        pickedFilepdf = file.path;
      });
    } else {
      // User canceled the picker
    }
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: grape,
                onPrimary: white,
                surface: grape,
                onSurface: grape,
              ),
              dialogBackgroundColor: white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _startDate = newSelectedDate;
      dateController
        ..text = DateFormat.yMMMd().format(_startDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  addReport() async {
    setState(() {
      _isButtonDisabled = true;
    });
    String image =
        pathPicked != null ? await Repo.uploadReport(pathPicked) : "";
    FirebaseFirestore.instance
        .collection("patients")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("reports")
        .add({
      "title": titleController.text,
      "date": dateController.text,
      "image": image ?? "",
      "fileType": fileType == "pdf" ? 0 : 1
    }).then((value) {
      Navigator.pop(context);
      Repo.showSnackBar(context, "${widget.title} Added Successfuly");
      setState(() {});
    }).catchError((onError) => Repo.showSnackBar(context, "error occured"));
  }
}
