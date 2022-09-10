import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';

class AppointmentHistory extends StatefulWidget {
  @override
  State<AppointmentHistory> createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  List appointments = [];
  @override
  initState(){
    super.initState();
    getAppointmentHistory();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: appointments.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.width * 0.7
                        : MediaQuery.of(context).size.width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        appointments[index]['patient_name'],
                                        style:
                                            Theme.of(context).textTheme.headline4,
                                      ),
                                      Text(
                                        appointments[index]['date'],
                                        style:
                                        Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                 "Symptoms:",
                                  style:
                                  Theme.of(context).textTheme.bodyText2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  child: Text(
                                    appointments[index]['symptoms'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  getTranslated(context, "history"),
                                ),
                                Container(
                                    height: 10,
                                    width: 20,
                                    child: VerticalDivider(
                                      thickness: 1.0,
                                      color: black,
                                    )),
                                Text(
                                  getTranslated(context, "payment"),
                                ),
                                Container(
                                    height: 10,
                                    width: 20,
                                    child: VerticalDivider(
                                      thickness: 1.0,
                                      color: black,
                                    )),
                                Text(
                                  getTranslated(context, "prescription"),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  getAppointmentHistory() {
    FirebaseFirestore.instance
        .collection("doctors")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("appointments")
        .where("appointment_status", isEqualTo: "checked")
        .get()
        .then((data) {
      for (int i = 0; i < data.docs.length; i++) {
        appointments = data.docs;
        setState(() {});
      }
    }).onError((error, stackTrace) {
      print("error $error");
    });
  }
}
