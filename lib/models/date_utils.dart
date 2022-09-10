import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
  static DateTime toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }
}
