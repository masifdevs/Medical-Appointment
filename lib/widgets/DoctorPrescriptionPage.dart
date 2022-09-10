import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';

class DoctorPrescriptionPage extends StatelessWidget {
  final prescriptionData;
  const DoctorPrescriptionPage({Key key, this.prescriptionData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Medicines"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
            itemCount: prescriptionData['medicines'].length,
            itemBuilder: (context, index) => Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Medicine:\t',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: prescriptionData['medicines'][index]
                                    ['medicine'],
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Instructions:\t',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: prescriptionData['medicines'][index]
                                    ['instructions'],
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }
}
