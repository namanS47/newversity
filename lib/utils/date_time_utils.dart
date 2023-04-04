import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMMM, yyyy');
    return formatter.format(dateTime);
  }

  static String getReturnFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMM dd,yyyy');
    return formatter.format(dateTime).toLowerCase();
  }

  static String getRefundFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('EEEE, dd MMM');
    return formatter.format(dateTime).toLowerCase();
  }

  static String getTimeInAMOrPM(DateTime dateTime){
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String getBankAmtFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('EE, dd MMM');
    return formatter.format(dateTime).toLowerCase();
  }

  static String getEstimateFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(dateTime).toLowerCase();
  }

  static String getBirthFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM, yyyy');
    return formatter.format(dateTime);
  }

  static String getAWSDateFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime).toLowerCase();
  }

  static String getEmploymentDurationDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMM yyyy');
    return formatter.format(dateTime);
  }

  static List<TimeOfDay> getAllAvailableTime() {
    List<TimeOfDay> allTimes = [];
    int minutes = 0;
    for(int i=0;i<96;i++) {
      TimeOfDay timeOfDay = TimeOfDay(hour: minutes~/60, minute: minutes%60);
      allTimes.add(timeOfDay);
      minutes+= 15;
    }
    return allTimes;
  }

  static List<TimeOfDay> getSelectedAvailableTime(TimeOfDay startTime) {
    List<TimeOfDay> allTimes = [];
    int minutes = startTime.hour*60 + startTime.minute + 15;
    while(minutes < 1440) {
      TimeOfDay timeOfDay = TimeOfDay(hour: minutes~/60, minute: minutes%60);
      allTimes.add(timeOfDay);
      minutes+= 15;
    }
    return allTimes;
  }

  static String getTimeFormat(TimeOfDay timeOfDay, BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(timeOfDay);
  }

  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  static DateTime getDateTimeFromTimeOfDay(DateTime dateTime, TimeOfDay timeOfDay) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute);
  }
}