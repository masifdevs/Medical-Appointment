import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/main.dart';
import 'package:flutter_localization_master/models/language.dart';
import 'package:flutter_localization_master/pages/initial/doctor_login.dart';
import 'package:flutter_localization_master/pages/initial/patient_login.dart';

class LoginOption extends StatefulWidget {
  @override
  _LoginOptionState createState() => _LoginOptionState();
}

class _LoginOptionState extends State<LoginOption> {
  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton<Language>(
              underline: SizedBox(),
              icon: Icon(
                Icons.language,
                color: white,
              ),
              onChanged: (Language language) {
                _changeLanguage(language);
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(e.name)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/doctor_png.png"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    getTranslated(context, "login_as"),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PatientLoginPage()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25), color: grape),
                    child: Center(
                      child: Text(
                        getTranslated(context, "patient"),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorLoginPage()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25), color: black),
                    child: Center(
                      child: Text(
                        getTranslated(context, "doctor"),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
