import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/pages/doctor/LabReports.dart';
import 'package:flutter_localization_master/pages/doctor/history_page.dart';

class HistoryTabs extends StatefulWidget {
  const HistoryTabs({Key key}) : super(key: key);

  @override
  State<HistoryTabs> createState() => _HistoryTabsState();
}

class _HistoryTabsState extends State<HistoryTabs> {
  List appointments = [];

  @override
  initState() {
    super.initState();
    getAppointmentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "History",
                ),
                Tab(
                  text: "Reports",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              HistoryPage(appointmentsList: appointments),
              LabReports()
            ],
          ),
        ));
  }

  getAppointmentHistory() {
    FirebaseFirestore.instance
        .collection("patients")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("appointments")
        .get()
        .then((data) {
      for (int i = 0; i < data.docs.length; i++) {
        FirebaseFirestore.instance
            .collection("doctors")
            .doc(data.docs[i]['doctor_id'])
            .collection("appointments")
            .where("patient_id",
                isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .where("appointment_status", isEqualTo: "checked")
            .get()
            .then((value) {
          for (int i = 0; i < value.docs.length; i++) {
            appointments = value.docs;
            setState(() {});
          }
        });
      }
    }).onError((error, stackTrace) {
      print("error $error");
    });
  }
}
