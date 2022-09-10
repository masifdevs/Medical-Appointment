import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/services/repo.dart';
import 'package:flutter_localization_master/utils/elevatedbtn.dart';
import 'package:flutter_localization_master/utils/textformfield.dart';
import 'package:intl/intl.dart';
import 'package:weekday_selector/weekday_selector.dart';

class ShedulePage extends StatefulWidget {
  @override
  _ShedulePageState createState() => _ShedulePageState();
}

class _ShedulePageState extends State<ShedulePage> {
  final values = <bool>[false, false, false, false, false, false, false];
  TextEditingController startDateCtl = TextEditingController();
  TextEditingController endDateCtl = TextEditingController();
  TextEditingController startTimeCtl = TextEditingController();
  TextEditingController endTimeCtl = TextEditingController();
  TextEditingController timeSlot = TextEditingController();

  List selectedDay = [];
  DateTime _startDate, _endDate;
  TimeOfDay _startTime, _endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    getTranslated(context, "set_availability_schedule"),
                    style: Theme.of(context).textTheme.headline2,
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              getTranslated(context, "start_date"),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: grape),
                                      borderRadius: BorderRadius.circular(15)),
                                  labelText:
                                      getTranslated(context, "start_date"),
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText1),
                              focusNode: AlwaysDisabledFocusNode(),
                              controller: startDateCtl,
                              style: Theme.of(context).textTheme.bodyText1,
                              onTap: () {
                                _selectDate(context, true);
                              },
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              getTranslated(context, "end_date"),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () {
                                _selectDate(context, false);
                              },
                              controller: endDateCtl,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: grape),
                                      borderRadius: BorderRadius.circular(15)),
                                  labelText: getTranslated(context, "end_date"),
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText1),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              getTranslated(context, "start_time"),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () {
                                _selectTime(context, true);
                              },
                              cursorColor: grape,
                              controller: startTimeCtl,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: grape),
                                      borderRadius: BorderRadius.circular(15)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: grape),
                                      borderRadius: BorderRadius.circular(15)),
                                  labelText:
                                      getTranslated(context, "start_time"),
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText1),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              getTranslated(context, "end_time"),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              focusNode: AlwaysDisabledFocusNode(),
                              onTap: () {
                                _selectTime(context, false);
                              },
                              cursorColor: grape,
                              controller: endTimeCtl,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: grape),
                                      borderRadius: BorderRadius.circular(15)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: grape),
                                      borderRadius: BorderRadius.circular(15)),
                                  labelText: getTranslated(context, "end_time"),
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText1),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    getTranslated(context, "excluded_days"),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: WeekdaySelector(
                    selectedFillColor: grape,
                    fillColor: white,
                    selectedColor: white,
                    color: grape,
                    onChanged: (v) {
                      setState(() {
                        // week start from sunday in array
                        values[v % 7] = !values[v % 7];
                      });
                    },
                    values: values,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    getTranslated(context, "time_slot"),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      maxLength: 2,
                      controller: timeSlot,
                      cursorColor: grape,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: grape),
                              borderRadius: BorderRadius.circular(15)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: grape),
                              borderRadius: BorderRadius.circular(15)),
                          labelText: getTranslated(context, "time_slot"),
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          hintStyle: Theme.of(context).textTheme.bodyText1),
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: ElevatedBtn(
                      text: "save",
                      onPress: () {
                        calculateTime();
                        // if (startDateCtl.text == endDateCtl.text) {
                        //   Repo.showSnackBar(context, "Invalid Date Selection");
                        // } else {
                        //   setShedule();
                        // }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context, bool startDate) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _startDate != null ? _startDate : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2140),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: grape,
                onPrimary: white,
                surface: grape,
                onSurface: grape,
              ),
              dialogBackgroundColor: white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      startDate ? _startDate = newSelectedDate : _endDate = newSelectedDate;
      startDate ? startDateCtl : endDateCtl
        ..text = startDate
            ? DateFormat('yyyy-MM-dd').format(_startDate)
            : DateFormat('yyyy-MM-dd').format(_endDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset:
                startDate ? startDateCtl.text.length : endDateCtl.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  Future<void> _selectTime(BuildContext context, bool startTime) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: grape,
                onPrimary: white,
                surface: white,
                onSurface: grape,
              ),
              dialogBackgroundColor: grape,
            ),
            child: child,
          );
        });

    if (picked_s != null)
      setState(() {
        startTime
            ? startTimeCtl.text = picked_s.format(context).toString()
            : endTimeCtl.text = picked_s.format(context).toString();
      });
  }

  setShedule() async {
    FirebaseFirestore.instance
        .collection("doctors")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('shedule')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      "start_date": startDateCtl.text,
      "end_date": endDateCtl.text,
      "start_time": startTimeCtl.text,
      "end_time": endTimeCtl.text,
      "excluded_days": values,
      "time_slot": timeSlot.text
    }).then((value) {
      clearFields();
      Repo.showSnackBar(context, "successfully set shedule");
    }).onError((error, stackTrace) => Repo.showSnackBar(context, error));
  }

  clearFields() {
    startDateCtl.clear();
    endDateCtl.clear();
    startTimeCtl.clear();
    endTimeCtl.clear();
    timeSlot.clear();
  }

  calculateTime() {
    DateTime date = DateFormat.jm().parse(startTimeCtl.text);

    DateTime date2 = DateFormat.jm().parse(endTimeCtl.text);

    var start = DateFormat("HH:mm").format(date);
    var end = DateFormat("HH:mm").format(date2);

    final diff_dy = date2.difference(date).inMinutes;
    print(diff_dy / int.parse(timeSlot.text));
    for (int i = date.minute; i <= date2.minute; i++) {
      print(i);
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
