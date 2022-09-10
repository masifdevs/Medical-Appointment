import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/pages/doctor/edit_profile.dart';
import 'package:flutter_localization_master/pages/doctor/get_labReports.dart';
import 'package:flutter_localization_master/widgets/image_alert.dart';
import 'package:image_picker/image_picker.dart';

class LabReports extends StatefulWidget {
  @override
  State<LabReports> createState() => _LabReportsState();
}

class _LabReportsState extends State<LabReports>
    with SingleTickerProviderStateMixin {
  File _image;
  final _picker = ImagePicker();
  String pickedFile = "", pickedFilepdf, fileType;
  File pathPicked;
  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
              right: 0,
              bottom: 0,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  IgnorePointer(
                    child: Container(
                      color: Colors.transparent,
                      height: 200.0,
                      width: 180.0,
                    ),
                  ),
                  // Transform.translate(
                  //   offset: Offset.fromDirection(getRadiansFromDegree(280),
                  //       degOneTranslationAnimation.value * 150),
                  //   child: Transform(
                  //     transform: Matrix4.rotationZ(
                  //         getRadiansFromDegree(rotationAnimation.value))
                  //       ..scale(degOneTranslationAnimation.value),
                  //     alignment: Alignment.center,
                  //     child: CustomTextButton(
                  //       text: "Lab",
                  //       onClick: () {},
                  //     ),
                  //   ),
                  // ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(280),
                        degOneTranslationAnimation.value * 110),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degOneTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: CustomTextButton(
                        text: "Lab Reports",
                        onClick: () {
                          _dialogCall(context, "Report");
                        },
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(280),
                        degOneTranslationAnimation.value * 70),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degOneTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: CustomTextButton(
                        text: "Prescriptions ",
                        onClick: () {
                          _dialogCall(context, "Prescriptions");
                        },
                      ),
                    ),
                  ),

                  Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value)),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: Container(
                        height: 80,
                        decoration:
                            BoxDecoration(color: grape, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (animationController.isCompleted) {
                          animationController.reverse();
                        } else {
                          animationController.forward();
                        }
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
      body: GetLabReports(),
    );
  }

  _fileFromStorage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      print("**** ${file.name}");
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

  Future<void> _dialogCall(BuildContext context, String title) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(title: title);
        });
  }
}
