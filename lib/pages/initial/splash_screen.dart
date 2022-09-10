import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/models/user.dart';
import 'package:flutter_localization_master/pages/doctor/patient_home_page.dart';
import 'package:flutter_localization_master/pages/initial/login_option.dart';
import 'package:flutter_localization_master/pages/patient/patient_home_page.dart';
import 'package:flutter_localization_master/services/firestore_services.dart';
import 'package:flutter_localization_master/services/repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkUser();
    return Scaffold(
      body: Center(child: Image.asset("assets/images/doctor_png.png")),
    );
  }

  checkUser() {
    SharedPreferences.getInstance().then((value) {
      if (value.getString("role") == 'patient') {
        Timer(
            Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DoctorHomePage())));
      } else if (value.getString("role") == 'doctor') {
        Timer(
            Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PatientHomePage())));
      } else {
        Timer(
            Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginOption())));
      }
    });
  }
}
