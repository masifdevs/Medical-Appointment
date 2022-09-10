import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/models/doctor_model.dart';
import 'package:flutter_localization_master/models/user.dart';
import 'package:flutter_localization_master/pages/doctor/drawer.dart';
import 'package:flutter_localization_master/services/firestore_services.dart';
import 'package:flutter_localization_master/services/repo.dart';
import 'package:flutter_localization_master/widgets/doctor_grid.dart';
import 'package:flutter_localization_master/widgets/image_alert.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorHomePage extends StatefulWidget {
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  String _query = "";

  bool _isLoading = true;
  List<Doctor> doctor_list = [];

  void didChangeDependencies() async {
    doctor_list = await FireStoreServices.getDoctorData();
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    SharedPreferences.getInstance().then((value) {
      Repo.UserData(value);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerPage(),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          getTranslated(context, "home").toUpperCase(),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //       onPressed: () async {
        //         await _dialogCall(context);
        //       },
        //       icon: Icon(Icons.file_copy_rounded))
        // ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: _isLoading
                ? Text("Loading...")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, "let_us_find_doctor"),
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.start,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10),
                        child: TextFormField(
                          autofocus: false,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            labelStyle: Theme.of(context).textTheme.bodyText1,
                            hintStyle: Theme.of(context).textTheme.bodyText1,
                            labelText: getTranslated(context, 'search'),
                            prefixIcon: Icon(
                              Icons.search,
                              color: grape,
                            ),
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(45.0),
                              ),
                              borderSide: BorderSide(
                                color: grape,
                                width: .5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          style: Theme.of(context).textTheme.bodyText1,
                          keyboardType: TextInputType.text,
                          onSaved: (String value) {
                            _query = value;
                          },
                          onEditingComplete: () async {
                            doctor_list.clear();
                            doctor_list =
                                await FireStoreServices.searchDoctor(_query);
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                          onChanged: (String value) async {
                            doctor_list.clear();
                            _query = value;
                            doctor_list =
                                await FireStoreServices.searchDoctor(_query);
                            setState(() {});
                          },
                        ),
                      ),
                      DoctorGridCard(doctor_list: doctor_list),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _dialogCall(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog();
        });
  }
}
