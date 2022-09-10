import 'package:flutter/material.dart';
import 'package:flutter_localization_master/pages/initial/login_option.dart';
import 'package:flutter_localization_master/pages/patient/appointment_history.dart';
import 'package:flutter_localization_master/pages/patient/shedule_page.dart';
import 'package:flutter_localization_master/services/firestore_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DDrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text("Savannah Aurora"),
          accountEmail: Text("Savannah@gmail.com"),
          currentAccountPicture: CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  "assets/images/patient-1.png",
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AppointmentHistory()));
          },
          title: Text(
            "Appointment History Page",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ShedulePage()));
          },
          title: Text(
            "Schedule Page",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        ListTile(
          onTap: () {
            SharedPreferences.getInstance().then((pref) async {
              await pref.clear();
              FireStoreServices.userLogOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginOption()),
                  (route) => false);
            });
          },
          title: Text(
            "Log Out",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        )
      ],
    ));
  }
}
