import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/constants/handle_permission.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/models/doctor_model.dart';
import 'package:flutter_localization_master/models/user.dart';
import 'package:flutter_localization_master/pages/doctor/appointment_page.dart';
import 'package:flutter_localization_master/pages/doctor/incoming_call.dart';
import 'package:flutter_localization_master/pages/doctor/incoming_video_call.dart';
import 'package:flutter_localization_master/utils/elevatedbtn.dart';
import 'package:flutter_localization_master/widgets/about-dr_reviewList.dart';
import 'package:flutter_localization_master/widgets/chat_page.dart';
import 'package:permission_handler/permission_handler.dart';

class AboutDoctor extends StatefulWidget {
  final Doctor doctor_data;

  AboutDoctor({this.doctor_data});

  @override
  State<AboutDoctor> createState() => _AboutDoctorState();
}

class _AboutDoctorState extends State<AboutDoctor> {
  ClientRole _role = ClientRole.Broadcaster;
  String totalRating = "", groupChatId = "", peerId, peerAvatar, id;
  List review_data = [];

  @override
  void initState() {
    getDoctorReviewsData();

    super.initState();
  }

  getDoctorReviewsData() {
    FirebaseFirestore.instance
        .collection('reviews')
        .where('doctor_id', isEqualTo: widget.doctor_data.uid)
        .get()
        .then((value) => setState(() {
              review_data = value.docs.toList();
            }))
        .onError((error, stackTrace) =>
            print("error :$error * stackTrack:$stackTrace"));
  }

  @override
  Widget build(BuildContext context) {
    calculateTotalRating();
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedBtn(
          onPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AppointmentPage(doctor: widget.doctor_data)));
          },
          text: "book_appointment",
        ),
        body: SafeArea(
          child: Container(
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
                                image: NetworkImage(widget.doctor_data.image),
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
                      bottom: 10.0,
                      left: MediaQuery.of(context).size.width * 0.2,
                      child: Container(
                        decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    await CallPermissionHandler
                                        .handleCameraAndMic(Permission.camera);
                                    await CallPermissionHandler
                                        .handleCameraAndMic(
                                            Permission.microphone);
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
                                                      widget.doctor_data.uid,
                                                  peerAvatar:
                                                      widget.doctor_data.image,
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          getTranslated(context, "about_doctor"),
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          widget.doctor_data.about != null
                              ? widget.doctor_data.about
                              : "Doctor has to update his about info.",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Text(
                              getTranslated(context, "reviews"),
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Icon(
                                Icons.star,
                                color: yellow,
                              ),
                            ),
                            Text(
                              totalRating,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "(${review_data.length})" ?? "",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AboutDrReviewList(review_data: review_data),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          getTranslated(context, "location"),
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          widget.doctor_data.address != ""
                              ? widget.doctor_data.address
                              : "Location is not provided.",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          getTranslated(context, "experience"),
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          widget.doctor_data.experience != ''
                              ? widget.doctor_data.experience
                              : "Doctor has not added any experience. ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
        ));
  }

  calculateTotalRating() {
    int rating = 0;
    for (int i = 0; i < review_data.length; i++) {
      rating += int.parse(review_data[i]['rating']);
    }
    totalRating = review_data.length == 0
        ? "0"
        : (rating / review_data.length).toString();
  }

  checkVideoCall(context) {
    id = FirebaseAuth.instance.currentUser.uid;
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-${widget.doctor_data.uid}';
    } else {
      groupChatId = '${widget.doctor_data.uid}-$id';
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
      groupChatId = '$id-${widget.doctor_data.uid}';
    } else {
      groupChatId = '${widget.doctor_data.uid}-$id';
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
              'caller_name': UserModel.name,
              'caller_pic': UserModel.name,
              'receiver_id': widget.doctor_data.uid,
              'receiver_name': widget.doctor_data.name,
              'receiver_pic': widget.doctor_data.image,
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
}
