import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/services/repo.dart';

class PrescriptionAlert extends StatefulWidget {
  final docId;
  PrescriptionAlert({this.docId});
  @override
  _PrescriptionAlertState createState() => new _PrescriptionAlertState();
}

class _PrescriptionAlertState extends State<PrescriptionAlert> {
  TextEditingController _prescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Prescription",style: TextStyle(color: black),),
      content: TextField(
        controller: _prescriptionController,
        autofocus: true,
        maxLines: 2,
        cursorColor: grape,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grape),
                borderRadius: BorderRadius.circular(15)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: grape),
                borderRadius: BorderRadius.circular(15)),
            labelText: 'Prescription',
            labelStyle: TextStyle(color: grape)),
      ),
      actions: [
        TextButton(
            child: const Text('CANCEL',
                style: TextStyle(color: grape, fontSize: 14)),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            child: const Text(
              'OK',
              style: TextStyle(color: grape, fontSize: 14),
            ),
            onPressed: () {
              if (_prescriptionController.text != "" ||
                  _prescriptionController.text.isNotEmpty) {
                FirebaseFirestore.instance
                    .collection("doctors")
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection("appointments")
                    .doc(widget.docId)
                    .update({
                  "appointment_status": "checked",
                  "prescriptions": _prescriptionController.text.trim(),
                }).then((value) {
                  Navigator.pop(context);
                  _prescriptionController.clear();
                  Repo.showSnackBar(context, "Succesfully prescription Added");
                }).onError((error, stackTrace) =>
                        Repo.showSnackBar(context, "error occured "));
              } else {
                Navigator.pop(context);
              }
            }),
      ],
    );
  }
}
