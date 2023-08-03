import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../flow/teacher/availability/data/model/availability_model.dart';

class DateTimeUtils {
  static const secondsInOneDay = 60 * 60 * 24;

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

  static String getTimeInAMOrPM(DateTime dateTime) {
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
    for (int i = 0; i < 48; i++) {
      TimeOfDay timeOfDay =
          TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
      allTimes.add(timeOfDay);
      minutes += 30;
    }
    return allTimes;
  }

  static List<TimeOfDay> getSelectedAvailableTime(
      TimeOfDay startTime, int minuteInterval, bool forStartTime) {

    TimeOfDay now = TimeOfDay.now();
    int minuteNow = now.hour*60 + now.minute;
    int minutes = forStartTime ? (minuteNow~/30)*30 + 30 : startTime.hour * 60 + startTime.minute + minuteInterval;


    List<TimeOfDay> allTimes = [];
    while (minutes < 1440) {
      TimeOfDay timeOfDay =
          TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
      allTimes.add(timeOfDay);
      minutes += minuteInterval;
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

  static DateTime getDateTimeFromTimeOfDay(
      DateTime dateTime, TimeOfDay timeOfDay) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour,
        timeOfDay.minute);
  }

  static String getDayName(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime).substring(0, 3).toUpperCase();
  }

  static int getCurrentMonth(DateTime dateTime) {
    return dateTime.month;
  }

  static DateTime getDateTime(String dateTime) {
    return DateFormat('d MMMM, yyyy', 'en_US').parse(dateTime);
  }

  static String getTotalDuration(List<AvailabilityModel> lisOfModel) {
    String timeLeft = "";
    int totalMinute = 0;
    for (var element in lisOfModel) {
      totalMinute = totalMinute +
          element.endDate!.difference(element.startDate!).inMinutes;
    }
    int hour = totalMinute ~/ 60;
    int minutes = totalMinute % 60;
    if (hour > 0 && minutes > 0) {
      timeLeft = "$hour Hrs $minutes Min";
    } else if (hour > 0 && minutes <= 0) {
      timeLeft = "$hour Hrs";
    } else if (hour <= 0 && minutes > 0) {
      timeLeft = "$minutes Min";
    }
    return timeLeft;
  }

  static String getTotalDurationInDeci(List<AvailabilityModel> lisOfModel) {
    String timeLeft = "";
    int totalMinute = 0;
    for (var element in lisOfModel) {
      totalMinute = totalMinute +
          element.endDate!.difference(element.startDate!).inMinutes;
    }
    int hour = totalMinute ~/ 60;
    int minutes = totalMinute % 60;
    if (hour > 0 && minutes > 0) {
      timeLeft = "$hour.$minutes Hr";
    } else if (hour > 0 && minutes <= 0) {
      timeLeft = "$hour Hr";
    } else if (hour <= 0 && minutes > 0) {
      timeLeft = "$minutes Min";
    }
    return timeLeft;
  }

  bool isDaySame(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
}
