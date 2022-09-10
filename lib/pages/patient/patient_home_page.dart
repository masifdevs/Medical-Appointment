import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/models/user.dart';
import 'package:flutter_localization_master/pages/patient/about_patient.dart';
import 'package:flutter_localization_master/pages/patient/drawer_page.dart';
import 'package:flutter_localization_master/services/repo.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientHomePage extends StatefulWidget {
  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  CardController controller;
  List requested_appointments = [], next_appointment = [];

  @override
  initState() {
    appointmentRequested();
    nextAppointments();
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
    print(UserModel.email);
    return Scaffold(
      drawer: Drawer(
        child: DDrawerPage(),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          getTranslated(context, "home").toUpperCase(),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 15),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 245,
                    child: Stack(
                      children: [
                        Center(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Card(
                            elevation: 2.5,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: white)),
                            child: Center(
                              child: Text(
                                getTranslated(context, "appointment_request"),
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ),
                        )),
                        TinderSwapCard(
                          swipeUp: false,
                          swipeDown: true,
                          orientation: AmassOrientation.BOTTOM,
                          totalNum: requested_appointments.length,
                          stackNum: 5,
                          swipeEdge: 4.0,
                          maxWidth: MediaQuery.of(context).size.width * 0.95,
                          maxHeight: 240,
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          minHeight: 230,
                          cardBuilder: (context, index) {
                            return Card(
                              elevation: 2.5,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: white)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      getTranslated(
                                          context, "appointment_request"),
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        requested_appointments[index]
                                                    ['patient_image'] !=
                                                ""
                                            ? Container(
                                                height: 80,
                                                width: 80,
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            requested_appointments[
                                                                    index][
                                                                'patient_image']))))
                                            : Container(
                                                height: 80,
                                                width: 80,
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: AssetImage(
                                                            "assets/images/patient.jpg")))),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  requested_appointments[index]
                                                      ['patient_name'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: Text(
                                                    requested_appointments[
                                                        index]['symptoms'],
                                                    maxLines: 2,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                          child: Text(
                                            requested_appointments[index]
                                                ['date'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.watch_later_outlined,
                                                size: 18,
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                requested_appointments[index]
                                                    ['time'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                approveAppointment(
                                                    requested_appointments[
                                                        index]['document_id']);
                                              },
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: green,
                                                  foregroundColor: white,
                                                  child: Center(
                                                      child:
                                                          Icon(Icons.check))),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                cancelAppointment(
                                                    requested_appointments[
                                                        index]['document_id']);
                                              },
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: red,
                                                  foregroundColor: white,
                                                  child: Center(
                                                      child:
                                                          Icon(Icons.clear))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          cardController: controller = CardController(),
                          swipeUpdateCallback:
                              (DragUpdateDetails details, Alignment align) {
                            /// Get swiping card's alignment
                            if (align.x < 0) {
                              //Card is LEFT swiping
                            } else if (align.x > 0) {
                              //Card is RIGHT swiping
                            }
                          },
                          swipeCompleteCallback:
                              (CardSwipeOrientation orientation, int index) {
                            /// Get orientation & index of swiped card!
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    getTranslated(context, "next_appointment"),
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Container(
                  width:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.width * 0.6,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: next_appointment.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutPatient(
                                        patientData: next_appointment[index])));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  next_appointment[index]['patient_image'] != ""
                                      ? Container(
                                          height: 50,
                                          width: 50,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      next_appointment[index]
                                                          ['patient_image']))))
                                      : Container(
                                          height: 50,
                                          width: 50,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: AssetImage(
                                                      "assets/images/patient.jpg")))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5.0),
                                          child: Text(
                                            next_appointment[index]
                                                ["patient_name"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                          ),
                                          child: Text(
                                            next_appointment[index]['symptoms'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          next_appointment[index]['time'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  appointmentRequested() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("doctors")
        .doc("${FirebaseAuth.instance.currentUser.uid}")
        .collection('appointments')
        .where('appointment_status', isEqualTo: "requested")
        .get();
    List appointments = [];
    for (var document in querySnapshot.docs) {
      appointments.add(document.data());
    }

    requested_appointments = appointments;
    setState(() {});
  }

  nextAppointments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("doctors")
        .doc("${FirebaseAuth.instance.currentUser.uid}")
        .collection('appointments')
        .where('appointment_status', isEqualTo: "approved")
        .get();
    List appointments = [];
    for (var document in querySnapshot.docs) {
      appointments.add(document.data());
    }
    next_appointment = appointments;

    setState(() {});
  }

  approveAppointment(String doc_id) {
    FirebaseFirestore.instance
        .collection('doctors')
        .doc("${FirebaseAuth.instance.currentUser.uid}")
        .collection('appointments')
        .doc(doc_id)
        .update({"appointment_status": "approved"}).then((result) {
      appointmentRequested();
      nextAppointments();
    }).catchError((onError) {
      print("onError");
    });
  }

  cancelAppointment(String doc_id) {
    FirebaseFirestore.instance
        .collection('doctors')
        .doc("${FirebaseAuth.instance.currentUser.uid}")
        .collection('appointments')
        .doc(doc_id)
        .update({"appointment_status": "canceled"}).then((result) {
      appointmentRequested();
      nextAppointments();
    }).catchError((onError) {
      print("onError");
    });
  }
}
