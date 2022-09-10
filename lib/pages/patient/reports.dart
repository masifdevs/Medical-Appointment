import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/widgets/pdfReports.dart';
import 'package:flutter_localization_master/widgets/show_report.dart';

class PatientLabReports extends StatelessWidget {
  final reports;
  const PatientLabReports({Key key, this.reports}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
        });
  }
}
