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
    return formatter.format(dateTime).toLowerCase();
  }

  static String getAWSDateFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime).toLowerCase();
  }

  static String getEmploymentDurationDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMM yyyy');
    return formatter.format(dateTime);
  }
}