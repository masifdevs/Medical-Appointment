import 'package:flutter/material.dart';
import 'package:flutter_localization_master/constants/colors.dart';

class AppointmentDateGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth > 400.0 ? 3 : 2,
              childAspectRatio: constraints.maxWidth > 400.0 ? 3.0 : 3.0,
              mainAxisSpacing: 0.5,
              crossAxisSpacing: 1.5),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Text(
                    "09:00",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2.0, left: 2.0),
                      child: Center(
                        child: Text(
                          "Booked",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          });
    });
  }
}
