import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/constants/strings.dart';
import 'package:flutter_localization_master/models/doctor_model.dart';
import 'package:flutter_localization_master/models/user.dart';
import 'package:flutter_localization_master/services/repo.dart';
import 'package:flutter_localization_master/utils/elevatedbtn.dart';
import 'package:flutter_localization_master/widgets/appointment_date_grid.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  final Doctor doctor;

  AppointmentPage({this.doctor});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DatePickerController _controller = DatePickerController();
  TextEditingController _symptomsController = TextEditingController();
  String selectedDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: grape,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${daysList[DateTime.now().weekday - 1]} ${DateTime.now().day} ",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Text(
                          "${monthsList[DateTime.now().month - 1]} ${DateTime.now().year}",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: DatePicker(
                    DateTime.now(),
                    width: 60,
                    height: 100,
                    initialSelectedDate: DateTime.now(),
                    selectionColor: grape,
                    selectedTextColor: white,
                    // inactiveDates: [
                    //   DateTime.now().add(Duration(days: 3)),
                    //   DateTime.now().add(Duration(days: 4)),
                    //   DateTime.now().add(Duration(days: 7))
                    // ],
                    onDateChange: (date) {
                      DateFormat('yyyy-MM-dd').format(date);
                      selectedDate =
                          DateFormat('yyyy-MM-dd').format(date).toString();
                      // New date selected
                      print(selectedDate);
                    },
                  ),
                ),
                AppointmentDateGrid(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                  child: TextFormField(
                    controller: _symptomsController,
                    cursorColor: grape,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: grape),
                            borderRadius: BorderRadius.circular(15)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: grape),
                            borderRadius: BorderRadius.circular(15)),
                        labelText: "Symptoms",
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        hintStyle: Theme.of(context).textTheme.bodyText1),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedBtn(
                  onPress: () {
                    bookAppointment();
                  },
                  text: "book_appointment",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bookAppointment() {
    FirebaseFirestore.instance
        .collection("doctors")
        .doc(widget.doctor.uid)
        .collection("appointments")
        .add({
          "doctor_id": widget.doctor.uid,
          "doctor_name": widget.doctor.name,
          "doctor_image": widget.doctor.image,
          "patient_id": UserModel.uid,
          "patient_name": UserModel.name,
          "patient_image": UserModel.image,
          "date": selectedDate,
          "time": "",
          "symptoms": _symptomsController.text,
          "appointment_status": "requested"
        })
        .then((value) => FirebaseFirestore.instance
                .collection("doctors")
                .doc(widget.doctor.uid)
                .collection("appointments")
                .doc(value.id)
                .update({
              "document_id": value.id,
            }).then((value) => FirebaseFirestore.instance
                        .collection("patients")
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .collection("appointments")
                        .add({
                      "doctor_id": widget.doctor.uid,
                      "doctor_name": widget.doctor.name,
                      "doctor_image": widget.doctor.image,
                      "patient_id": FirebaseAuth.instance.currentUser.uid,
                      "patient_name": UserModel.name,
                      "patient_image": UserModel.image,
                      "date": selectedDate,
                      "time": "",
                      "symptoms": _symptomsController.text,
                      "appointment_status": "requested",
                      "medicines": "",
                      "prescriptions": ""
                    }).then((value) => Repo.showSnackBar(
                            context, "Succesfully appointed"))))
        .onError(
            (error, stackTrace) => Repo.showSnackBar(context, "error occured"));
  }
}
