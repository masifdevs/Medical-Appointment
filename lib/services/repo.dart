import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repo {
  static Future<String> uploadImage(image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;

    //Create a reference to the location you want to upload to in firebase
    Reference reference =
        storage.ref().child("profileImages/doctors/${_auth.currentUser.uid}");

    //Upload the file to firebase
    UploadTask uploadTask = reference.putFile(image);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  static Future<String> uploadReport(report) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;

    //Create a reference to the location you want to upload to in firebase
    Reference reference =
        storage.ref().child("reports/${DateTime.now().millisecondsSinceEpoch}");

    //Upload the file to firebase
    UploadTask uploadTask = reference.putFile(report);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  static showSnackBar(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static addSubColection(String userId) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(userId)
        .collection("reviews")
        .add({
      //add your data that you want to upload
    });
  }

  static UserData(SharedPreferences value) {
    UserModel.uid = value.getString("uid");
    UserModel.name = value.getString("name");
    UserModel.email = value.getString("email");
    UserModel.about = value.getString("about");
    UserModel.phone = value.getString("phone");
    UserModel.address = value.getString("address");
    UserModel.blood_group = value.getString("blood_group");
    UserModel.dob = value.getString("dob");
    UserModel.image = value.getString("image");
    UserModel.role = value.getString("role");
  }
}
