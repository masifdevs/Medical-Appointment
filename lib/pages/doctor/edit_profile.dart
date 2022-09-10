import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/models/user.dart';
import 'package:flutter_localization_master/pages/patient/shedule_page.dart';
import 'package:flutter_localization_master/services/repo.dart';
import 'package:flutter_localization_master/utils/elevatedbtn.dart';
import 'package:flutter_localization_master/utils/textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController dob = TextEditingController();

  final _picker = ImagePicker();
  DateTime _startDate;
  final FocusNode nomeFocusNode = FocusNode();
  String gender = "Male", blood_group = "A+";
  File _image;
  final _updateKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    dob.text = UserModel.dob;
    name.text = UserModel.name;
    phone.text = UserModel.phone;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Form(
              key: _updateKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: grape,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Edit Personal".toUpperCase(),
                            style: Theme.of(context).textTheme.headline2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _key,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: InkWell(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: white,
                                  child: _image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: Image.file(
                                            _image,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: Image.asset(
                                            "assets/images/avatar.png",
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormFieldCustom(
                            controller: name,
                            isPhone: false,
                            isEmail: false,
                            isPass: false,
                            valid: (val) {
                              if (val.isEmpty) {
                                return getTranslated(context, 'required_field');
                                // return DemoLocalization.of(context).translate('required_fiedl');
                              }
                              return null;
                            },
                            labelText: getTranslated(context, 'name'),
                            hintText: getTranslated(context, 'name_hint'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: grape),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      labelText: "Date of Birth",
                                      labelStyle:
                                          Theme.of(context).textTheme.bodyText1,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  focusNode: AlwaysDisabledFocusNode(),
                                  controller: dob,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              height: 60,
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                  border: Border.all(color: grape),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration.collapsed(
                                          hintText: ''),
                                      value: gender,
                                      hint: Text("Gender"),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: grape,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          gender = newValue;
                                        });
                                      },
                                      items: <String>['Male', 'Female']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'gender is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: grape),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButtonFormField<String>(
                                  decoration:
                                      InputDecoration.collapsed(hintText: ''),
                                  value: blood_group,
                                  hint: Text("Blood Group"),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: grape,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      blood_group = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'A+',
                                    'A-',
                                    'B+',
                                    'B-',
                                    'AB+',
                                    'AB-',
                                    'O+',
                                    'O-',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Blood group is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormFieldCustom(
                            controller: phone,
                            isPhone: true,
                            isEmail: false,
                            isPass: false,
                            valid: (val) {
                              if (val.isEmpty) {
                                return getTranslated(context, 'required_field');
                              }
                              return null;
                            },
                            labelText: getTranslated(context, 'phone'),
                            hintText: "03456345234",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedBtn(
                            text: "save",
                            onPress: () async {
                              String image = _image != null
                                  ? await Repo.uploadImage(_image)
                                  : "";
                              FirebaseFirestore.instance
                                  .collection("doctors")
                                  .doc(_auth.currentUser.uid)
                                  .update({
                                    "name": name.text,
                                    "phone": phone.text,
                                    "gender": gender,
                                    "blood_group": blood_group,
                                    "dob": dob.text,
                                    "image": image ?? ""
                                  })
                                  .then((value) => Repo.showSnackBar(
                                      context, "Sucessfully updated"))
                                  .catchError((onError) => Repo.showSnackBar(
                                      context, "error occured"));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime(2140),
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
      dob
        ..text = DateFormat.yMMMd().format(_startDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dob.text.length, affinity: TextAffinity.upstream));
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }
}

class CustomTextButton extends StatelessWidget {
  String text;
  final Function onClick;

  CustomTextButton({this.text, this.onClick});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Text(
          text,
          style: TextStyle(color: grape, fontWeight: FontWeight.bold),
        ),
        onPressed: onClick);
  }
}
