import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/models/doctor_model.dart';

class FireStoreServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Register User
  static Future<UserCredential> userRegister(
      context, String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => value);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  //login user
  static Future<UserCredential> userLoginIn(
      context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The email already in use.");
        print('The account already exists for that email.');
      }
    } catch (e) {
      showSnackBar(context, "error: $e");
      print(e);
    }
  }

  // logout user
  static userLogOut() async {
    await FirebaseAuth.instance.signOut();
  }

// show snackbar
  static showSnackBar(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  //**********************************************************************//
  //************************* Firestore Services **************************//
  //***********************************************************************//

  static Future<List<Doctor>> getDoctorData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("doctors").get();
    List<Doctor> doctors = [];

    for (var document in querySnapshot.docs) {
      doctors.add(
        Doctor(
            uid: document["uid"],
            name: document['name'],
            email: document['email'],
            role: document["role"],
            dob: document['dob'],
            gender: document['gender'],
            blood_group: document['blood_group'],
            phone: document['phone'],
            image: document['image'],
            address: document['address'],
            experience: document['experience'],
            about: document['about'],
            rating: document['total_rating'],
            specialization: document['specialization']),
      );
    }
    return doctors;
  }

  static Future<List<Doctor>> searchDoctor(String query) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("doctors").orderBy("name").startAt([query])

        .get();
    List<Doctor> doctors = [];

    for (var document in querySnapshot.docs) {
      doctors.add(
        Doctor(
            uid: document["uid"],
            name: document['name'],
            email: document['email'],
            role: document["role"],
            dob: document['dob'],
            gender: document['gender'],
            blood_group: document['blood_group'],
            phone: document['phone'],
            image: document['image'],
            address: document['address'],
            experience: document['experience'],
            about: document['about'],
            rating: document['total_rating'],
            specialization: document['specialization']),
      );
    }

    return doctors;
  }

  static Future<List<QueryDocumentSnapshot<Object>>> searchPatientReport(
      String query, String patientId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("patients")
        .doc(patientId)
        .collection("reports")
        .where("title", isGreaterThanOrEqualTo: query)
        .get();
    return querySnapshot.docs;
  }
}
