import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/strings.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/pages/initial/doctor_register.dart';
import 'package:flutter_localization_master/pages/initial/forget_pass.dart';
import 'package:flutter_localization_master/pages/patient/patient_home_page.dart';
import 'package:flutter_localization_master/services/firestore_services.dart';
import 'package:flutter_localization_master/utils/elevatedbtn.dart';
import 'package:flutter_localization_master/utils/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorLoginPage extends StatefulWidget {
  @override
  _DoctorLoginPageState createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  var password = TextEditingController();
  final FocusNode nomeFocusNode = FocusNode();

  var email = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    email.text = "doctor@gmail.com";
    password.text = "12345678";
    super.initState();
  }

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
                  getTranslated(context, 'log_in'),
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
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
                  if (val.isEmpty) {
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
              child: ElevatedBtn(
                text: "log_in",
                onPress: () async {
                  if (_key.currentState.validate()) {
                    await userLogin();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPasswordPage()));
                  },
                  child: Text(
                    getTranslated(context, 'forget_password'),
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      getTranslated(context, 'dont_have_account'),
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorRegisterPage()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: Text(
                          getTranslated(context, 'register'),
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

  userLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.text, password: password.text)
        .then((currentUser) => FirebaseFirestore.instance
                .collection("doctors")
                .doc(currentUser.user.uid)
                .get()
                .then((DocumentSnapshot result) {
              print("*****");
              print(result['email']);
              prefs.setString("role", result['role'] ?? "");
              prefs.setString("uid", result['uid'] ?? "");
              prefs.setString("name", result['name'] ?? "");
              prefs.setString("about", result['about'] ?? "");
              prefs.setString("address", result['address'] ?? "");
              prefs.setString("blood_group", result['blood_group'] ?? "");
              prefs.setString("dob", result['dob'] ?? "");
              prefs.setString("email", result['email'] ?? "");
              prefs.setString("image", result['image'] ?? "");
              prefs.setString("phone", result['phone']) ?? "";

              if ("doctor" == result["role"]) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => PatientHomePage()));
              } else {
                FireStoreServices.showSnackBar(
                    context, "Invalid email or password");
              }
            }).catchError((err) => FireStoreServices.showSnackBar(
                    context, "Invalid email or password")))
        .catchError((err) => FireStoreServices.showSnackBar(
            context, "Invalid email or password"));
  }
}
