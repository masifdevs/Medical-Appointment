import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/localization/demo_localization.dart';
import 'package:flutter_localization_master/pages/initial/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization/language_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return this._locale == null
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Flutter Localization Demo",
            locale: _locale,
            supportedLocales: [
              Locale("en", "US"),
              Locale("ur", "PK"),
            ],
            localizationsDelegates: [
              DemoLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                color: grape,
              ),
              accentColor: grape,
              brightness: Brightness.light,
              primaryColor: grape,
              scaffoldBackgroundColor: grey,
              fontFamily: 'Poppins',
              textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: 35, fontWeight: FontWeight.bold, color: black),
                headline2: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: black),
                headline3: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: black),
                headline4: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, color: black),
                bodyText1: TextStyle(fontSize: 12, color: black),
                headline5: TextStyle(fontSize: 12, color: white),
                headline6: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: white),
                bodyText2: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold, color: black),
                subtitle1: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.bold, color: black),
                subtitle2: TextStyle(fontSize: 10, color: black),
              ),
            ),
            home: SplashScreen(),
          );
  }
}
