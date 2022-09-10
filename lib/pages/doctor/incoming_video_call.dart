import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/constants/handle_permission.dart';
import 'package:flutter_localization_master/utils/incoming_call_btn.dart';

class IncomingVideoCall extends StatelessWidget {
  ClientRole _role = ClientRole.Broadcaster;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
        stream: callStream(uid: "sfkMrXJ7PoZfb144SbQoMxiwg8f2"),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.data != null) {
            if (snapshot.data['has_dialled'] == "true") {
              print(snapshot.data.data());
              return Container(
                color: grape,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    snapshot.data["caller_pic"] != null
                        ? Image.network(snapshot.data["caller_pic"])
                        : Image.asset(
                            "assets/images/doctor.jpg",
                            fit: BoxFit.cover,
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Incoming Call".toUpperCase(),
                              style: headline7,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              snapshot.data["caller_name"] ?? "",
                              style: headline8,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {
                                        CallPermissionHandler.joinVideoCall(
                                            context,
                                            snapshot.data['receiver_name']);
                                      },
                                      child: IncomingCallBtn(
                                        text: "APPROVE",
                                        color: orange,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: IncomingCallBtn(
                                        text: "DECLINE",
                                        color: yellow,
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              print(snapshot.data.data());
            }
          }
          return Container();
        },
      )),
    );
  }

  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection("calls");

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.doc(uid).snapshots();
}
