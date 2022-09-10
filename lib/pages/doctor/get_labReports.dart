import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/widgets/pdfReports.dart';
import 'package:flutter_localization_master/widgets/show_report.dart';

class GetLabReports extends StatefulWidget {
  const GetLabReports({Key key}) : super(key: key);

  @override
  _GetLabReportsState createState() => _GetLabReportsState();
}

class _GetLabReportsState extends State<GetLabReports> {
  List reports = [];

  @override
  initState() {
    super.initState();
    getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  reports[index]['fileType'] == 1
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ImageReport(Report: reports[index])))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PdfReport(Report: reports[index])));
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reports[index]['title'],
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Spacer(),
                        Text(
                          reports[index]['date'],
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  getReports() {
    FirebaseFirestore.instance
        .collection("patients")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("reports")
        .get()
        .then((data) {
      for (int i = 0; i < data.docs.length; i++) {
        reports = data.docs;

        setState(() {});
      }
    }).onError((error, stackTrace) {
      print("error $error");
    });
  }
}
