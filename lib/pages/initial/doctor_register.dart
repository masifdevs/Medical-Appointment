import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/strings.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/services/firestore_services.dart';
import 'package:flutter_localization_master/utils/elevatedbtn.dart';
import 'package:flutter_localization_master/utils/textformfield.dart';

class DoctorRegisterPage extends StatefulWidget {
  @override
  _DoctorRegisterPageState createState() => _DoctorRegisterPageState();
}

class _DoctorRegisterPageState extends State<DoctorRegisterPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: _mainForm(context),
      ),
    );
  }

  Form _mainForm(BuildContext context) {
    return Form(
      key: _key,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Center(
                child: Text(
                  getTranslated(context, 'create_newAccount'),
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormFieldCustom(
                controller: email,
                isPhone: false,
                isEmail: false,
                isPass: false,
                valid: (val) {
                  if (val.isEmpty) {
                    return getTranslated(context, 'required_field');
                  }
                  if (!RegExp(email_RegExp).hasMatch(val)) {
                    return 'Please enter a valid Email';
                  }
                  return null;
                },
                labelText: getTranslated(context, 'email'),
                hintText: getTranslated(context, 'email_hint'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormFieldCustom(
                controller: password,
                isPhone: false,
                isEmail: false,
                isPass: true,
                valid: (val) {
                  if (val.isEmpty || val.length < 6) {
                    return getTranslated(context, 'required_field');
                  }
                  return null;
                },
                labelText: getTranslated(context, 'password'),
                hintText: "*******",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormFieldCustom(
                isPhone: false,
                controller: confirm_password,
                isEmail: false,
                isPass: true,
                valid: (val) {
                  if (val.isEmpty) {
                    return getTranslated(context, 'required_field');
                  }
                  if (val != password.text) return "password not match";

                  return null;
                },
                labelText: getTranslated(context, 'confirm_password'),
                hintText: "*******",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedBtn(
                text: "register",
                onPress: () async {
                  if (_key.currentState.validate()) {
                    await registerUser(
                      email.text,
                      name.text,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      getTranslated(context, 'already_have_account'),
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: Text(
                          getTranslated(context, 'log_in'),
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  clearField() {
    name.clear();
    email.clear();
    password.clear();
    confirm_password.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clearField();
  }

  void registerUser(String uemail, String uname) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email.text, password: password.text)
        .then((currentUser) => FirebaseFirestore.instance
                .collection("doctors")
                .doc(currentUser.user.uid)
                .set({
              "uid": currentUser.user.uid,
              "name": uname,
              "email": uemail,
              "role": "doctor",
              "phone": "",
              "gender": "",
              "blood_group": "",
              "dob": "",
              "image": "",
              "address": "",
              "specialization": "",
              "about": "",
              "experience": "",
              "total_rating": "",
            }).then((result) => {
                      clearField(),
                      FireStoreServices.showSnackBar(
                          context, "Doctor Registered Successfully.")
                    }));
  }
}
