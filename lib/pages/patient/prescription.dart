import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/pages/patient/patient_home_page.dart';
import 'package:flutter_localization_master/services/repo.dart';
import 'package:flutter_localization_master/utils/elevatedbtn.dart';

class PrescriptionPage extends StatefulWidget {
  final docId;
  const PrescriptionPage({Key key, this.docId}) : super(key: key);

  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  var medicines = <TextEditingController>[];
  var prescription = <TextEditingController>[];
  var container = <Container>[];
  List entries = [];
  Container createCard() {
    var medicineController = TextEditingController();
    var prescriptionController = TextEditingController();
    medicines.add(medicineController);
    prescription.add(prescriptionController);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Medicine ${container.length + 1}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              textAlign: TextAlign.start,
              maxLines: 1,
              controller: medicineController,
              cursorColor: grape,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grape),
                      borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: grape),
                      borderRadius: BorderRadius.circular(15)),
                  labelText: "Medicine Name",
                  labelStyle: TextStyle(color: grape)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              textAlign: TextAlign.start,
              maxLines: 1,
              controller: prescriptionController,
              cursorColor: grape,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grape),
                      borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: grape),
                      borderRadius: BorderRadius.circular(15)),
                  labelText: "Instruction",
                  labelStyle: TextStyle(color: grape)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    container.add(createCard());
  }

  _onDone() {
    for (int i = 0; i < container.length; i++) {
      var name = medicines[i].text;
      var instr = prescription[i].text;

      entries.add({"medicine": name, "instructions": instr});
    }
    SavePrescription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Medicine"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: container.length,
              itemBuilder: (BuildContext context, int index) {
                return container[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: ElevatedBtn(text: "save", onPress: _onDone),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => setState(() => container.add(createCard()))),
    );
  }

  SavePrescription() {
    FirebaseFirestore.instance
        .collection("doctors")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("appointments")
        .doc(widget.docId)
        .update({
      "appointment_status": "checked",
      "medicines": entries,
    }).then((value) {
      clearField();
      Repo.showSnackBar(context, "Succesfully Added");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PatientHomePage()));
    }).onError((error, stackTrace) =>
            Repo.showSnackBar(context, "error occured $error"));
  }

  clearField() {
    medicines.clear();
    prescription.clear();
  }
}
