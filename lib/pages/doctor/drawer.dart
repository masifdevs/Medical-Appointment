import 'package:flutter/material.dart';
import 'package:flutter_localization_master/pages/doctor/edit_profile.dart';
import 'package:flutter_localization_master/pages/doctor/history_tabs.dart';
import 'package:flutter_localization_master/pages/initial/login_option.dart';
import 'package:flutter_localization_master/services/firestore_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text("Anderson"),
          accountEmail: Text("h.anderson@gmail.com"),
          currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Image.asset("assets/images/doctor_png.png")),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfile()));
          },
          title: Text(
            "Edit Profile",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryTabs()));
          },
          title: Text(
            "History Page",
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
    );
  }
}
