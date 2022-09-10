import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:intl/intl.dart';

class AboutDrReviewList extends StatelessWidget {
  final review_data;

  AboutDrReviewList({this.review_data});

  @override
  Widget build(BuildContext context) {
    return review_data.length == 0
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "This doctor is not reviewed yet by patients.",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          )
        : Container(
            height: 120,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: LayoutBuilder(
              builder: (context, constraints) => ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: review_data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var review = review_data[index];
                    DateFormat dateFormat = DateFormat("HH:mm:ss");
                    // DateTime dateTime = dateFormat.parse(review["time"].toDate());
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10)),
                        width: constraints.maxWidth > 420.0
                            ? MediaQuery.of(context).size.width * 0.5
                            : MediaQuery.of(context).size.width * 0.85,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage(
                                                "assets/images/doctor.jpg")))),
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 5.0),
                                        child: Text(
                                          review['patient_name'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                        ),
                                        child: Text(
                                          (DateFormat("yyyy-mm-dd").format(
                                                  review["time"].toDate()))
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                        ),
                                        child: Text(
                                          review['reviews'],
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 20,
                                        color: yellow,
                                      ),
                                      Text(
                                        review["rating"].toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
  }
}
