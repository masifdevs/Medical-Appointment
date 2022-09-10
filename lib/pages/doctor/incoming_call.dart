import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/constants/handle_permission.dart';
import 'package:flutter_localization_master/utils/incoming_call_btn.dart';

class IncomingCall extends StatelessWidget {
  ClientRole _role = ClientRole.Broadcaster;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: grape,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
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
                        "Helna Anderson",
                        style: headline8,
                      ),
                    ),
                    Text(
                      "602-492-3858",
                      style: Theme.of(context).textTheme.headline5,
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
                                  CallPermissionHandler.joinAudioCall(context);
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
        ),
      ),
    );
  }
}
