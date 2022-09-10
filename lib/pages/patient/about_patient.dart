import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/constants/handle_permission.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/pages/doctor/incoming_call.dart';
import 'package:flutter_localization_master/pages/doctor/incoming_video_call.dart';
import 'package:flutter_localization_master/pages/patient/prescription.dart';
import 'package:flutter_localization_master/pages/patient/reports.dart';
import 'package:flutter_localization_master/services/firestore_services.dart';
import 'package:flutter_localization_master/services/repo.dart';
import 'package:flutter_localization_master/widgets/chat_page.dart';
import 'package:flutter_localization_master/widgets/patient_appointment_list.dart';
import 'package:flutter_localization_master/widgets/prescription_alert.dart';

class AboutPatient extends StatefulWidget {
  final patientData;

  AboutPatient({this.patientData});

  @override
  State<AboutPatient> createState() => _AboutPatientState();
}

class _AboutPatientState extends State<AboutPatient> {
  String groupChatId = "", _query = "", peerId, peerAvatar, id;
  var Patient_data;
  bool isLoading = true;
  List previousAppointment = [], reports = [];
  @override
  initState() {
    getPatientInfo();
    getPatientAppointments();
    getReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        child: Container(
          height: 80,
          decoration: BoxDecoration(color: grape, shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.medication,
              color: white,
            ),
          ),
        ),
        onTap: () {
          showBottomSheet();
        },
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        height: constraints.maxWidth > 420
                            ? MediaQuery.of(context).size.height * 0.5
                            : MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            image: DecorationImage(
                                image: widget.patientData['patient_image'] != ""
                                    ? NetworkImage(
                                        widget.patientData['patient_image'])
                                    : AssetImage("assets/images/patient.jpg"),
                                fit: BoxFit.cover)),
                      );
                    }),
                    Positioned(
                        top: 0.0,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Icon(
                                Icons.arrow_back,
                                color: grape,
                              ),
                            ))),
                    Positioned(
                      bottom: 0.0,
                      left: MediaQuery.of(context).size.width * 0.2,
                      child: Container(
                        decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 30),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    checkVideoCall(context);
                                  },
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: white,
                                      foregroundColor: grape,
                                      child: Center(
                                          child: Icon(Icons.video_call))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => IncomingCall(),
                                        ));
                                    // onJoinAudio(context);
                                  },
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: white,
                                      foregroundColor: green,
                                      child: Center(child: Icon(Icons.call))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Chat(
                                                  peerId:
                                                      "DNENIAyZIUSnVFqoIkdEFMnYud32",
                                                  peerAvatar: "",
                                                )));
                                  },
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: white,
                                      foregroundColor: grape,
                                      child:
                                          Center(child: Icon(Icons.message))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    getTranslated(context, "history"),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        Patient_data['about'] != ""
                            ? Patient_data['about']
                            : "Patient has not provided his history",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    getTranslated(context, "appointments"),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 160,
                    child: PatientAppointmentList(
                        previousAppointment: previousAppointment)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    cursorColor: grape,
                    autofocus: false,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      hintStyle: Theme.of(context).textTheme.bodyText1,
                      labelText: getTranslated(context, 'simple_search'),
                      prefixIcon: Icon(
                        Icons.search,
                        color: grape,
                      ),
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
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
                      reports.clear();
                      reports = await FireStoreServices.searchPatientReport(
                          _query, widget.patientData["patient_id"]);
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    },
                    onChanged: (String value) async {
                      reports.clear();
                      _query = value;
                      reports = await FireStoreServices.searchPatientReport(
                          _query, widget.patientData["patient_id"]);
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    getTranslated(context, "lab_reports"),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                PatientLabReports(reports: reports)
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkVideoCall(context) {
    id = FirebaseAuth.instance.currentUser.uid;
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-patientid';
    } else {
      groupChatId = 'patientid-$id';
    }
    FirebaseFirestore.instance
        .collection('calls')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .get()
        .then((value) {
      if (value.exists) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => IncomingVideoCall()));
      } else {
        makeVideoCall(context);
      }
    }).onError((error, stackTrace) {
      makeVideoCall(context);
    });
  }

  makeVideoCall(context) {
    id = FirebaseAuth.instance.currentUser.uid;
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-patientid';
    } else {
      groupChatId = 'patientid-$id';
    }
    var documentReference = FirebaseFirestore.instance
        .collection('calls')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance
        .runTransaction((transaction) async {
          transaction.set(
            documentReference,
            {
              'caller_id': FirebaseAuth.instance.currentUser.uid,
              'caller_name': FirebaseAuth.instance.currentUser.displayName,
              'caller_pic': FirebaseAuth.instance.currentUser.photoURL,
              'receiver_id': "patient.uid",
              'receiver_name': "patient.name",
              'receiver_pic': "patient.image",
              'has_dialled': "true",
              'call_status': 'dialled',
              'channel_id': Random().nextInt(1000).toString(),
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            },
          );
        })
        .then((value) =>
            CallPermissionHandler.joinVideoCall(context, "patientName"))
        .onError((error, stackTrace) => print("error: $error"));
  }

  getPatientInfo() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection("patients")
        .doc(widget.patientData["patient_id"])
        .get();
    Patient_data = docSnapshot;
    setState(() {
      isLoading = false;
    });
  }

  getPatientAppointments() async {
    QuerySnapshot docSnapshot = await FirebaseFirestore.instance
        .collection("doctors")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('appointments')
        .where('patient_id', isEqualTo: widget.patientData['patient_id'])
        .where("appointment_status", isEqualTo: 'checked')
        .get();
    previousAppointment = docSnapshot.docs;
    setState(() {});
  }

  getReports() {
    FirebaseFirestore.instance
        .collection("patients")
        .doc(widget.patientData['patient_id'])
        .collection("reports")
        .get()
        .then((data) {
      for (int i = 0; i < data.docs.length; i++) {
        reports = data.docs;
        setState(() {});
      }
    }).onError((error, stackTrace) {
      print("error $error");
    });
  }

  showBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.medication),
                title: new Text('Add Medicines'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrescriptionPage(
                              docId: widget.patientData['document_id'])));
                },
              ),
              ListTile(
                  leading: new Icon(Icons.note_add_sharp),
                  title: new Text('Add Prescriptions'),
                  onTap: () {
                    Navigator.pop(context);
                    _dialogCall(context, widget.patientData['document_id']);
                  })
            ],
          );
        });
  }

  Future<void> _dialogCall(BuildContext context, String DocId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return PrescriptionAlert(docId: DocId);
        });
  }
}
