import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/widgets/DoctorPrescriptionPage.dart';

class HistoryPage extends StatelessWidget {
  final appointmentsList;

  const HistoryPage({Key key, this.appointmentsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: appointmentsList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorPrescriptionPage(
                              prescriptionData: appointmentsList[index])));
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appointmentsList[index]['doctor_image'] != ''
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                appointmentsList[index]
                                                    ['doctor_image']))))
                                : Container(
                                    height: 40,
                                    width: 40,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: grey,
                                    )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  appointmentsList[index]['doctor_name'],
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              appointmentsList[index]['date'],
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Symptoms: ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: appointmentsList[index]['symptoms'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ), SizedBox(
                          height: 5,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Prescription: ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: appointmentsList[index]['prescriptions'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
