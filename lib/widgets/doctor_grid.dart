import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/models/doctor_model.dart';
import 'package:flutter_localization_master/pages/doctor/about_doctor.dart';

class DoctorGridCard extends StatelessWidget {
  final List<Doctor> doctor_list;

  DoctorGridCard({this.doctor_list});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return doctor_list == null
          ? Container()
          : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: doctor_list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 420.0 ? 3 : 2,
                  childAspectRatio: constraints.maxWidth > 420.0 ? 0.8 : 0.8,
                  mainAxisSpacing: 0.5,
                  crossAxisSpacing: 0.5),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AboutDoctor(doctor_data: doctor_list[index])));
                  },
                  child: Card(
                      elevation: 0.0,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                                height: 80,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: grey,
                                    image: new DecorationImage(
                                        fit: BoxFit.contain,
                                        image: NetworkImage(
                                            doctor_list[index].image)))),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              child: Text(
                                doctor_list[index].name,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              child: Text(
                                doctor_list[index].specialization ?? "",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getTranslated(context, "experience"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Row(
                                          children: [
                                            Text(doctor_list[index]
                                                        .experience !=
                                                    ""
                                                ? doctor_list[index].experience
                                                : "0"),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Years"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getTranslated(context, "rating"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Row(
                                          children: [
                                            Text(doctor_list[index].rating != ""
                                                ? double.parse(
                                                        doctor_list[index]
                                                            .rating)
                                                    .toStringAsFixed(1)
                                                : "0.0"),
                                            Icon(
                                              Icons.star,
                                              size: 20,
                                              color: yellow,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              });
    });
  }
}
