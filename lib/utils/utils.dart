import 'package:intl/intl.dart';

bool isNullOrEmpty(String? str) {
  return str == null || str.isEmpty;
}

int getCurrentDate(){
  return DateTime.now().day;
}

int getCurrentMonth(){
  return DateTime.now().month;
}

int getMonthOfTomorrowsDate(){
  return DateTime.now().add(const Duration(days: 1)).month;
}

int getMonthOfTheyAfterTomorrowsDate(){
  return DateTime.now().add(const Duration(days: 2)).month;
}

int getTomorrowsDate(){
  return DateTime.now().add(const Duration(days: 1)).day;
}

int theyAfterTomorrowsDate(){
  return DateTime.now().add(const Duration(days: 2)).day;
}

String getCurrentDayName(){
  return DateFormat('EEEE').format(DateTime.now());
}

String getDayNameByDiffrence(int afterDay){
  return DateFormat('EEEE').format(DateTime.now().add(Duration(days: afterDay)));
}

String enumToString(String enumString) {
  return enumString.split('.')[1];
}