import 'package:flutter/material.dart';

import 'date_time_utils.dart';

class StringsUtils {
  static String getAvailabilityStartAndEndTimeString(
      BuildContext context, DateTime startDate, DateTime endDate) {
    return "${DateTimeUtils.getTimeFormat(TimeOfDay.fromDateTime(startDate), context)} - ${DateTimeUtils.getTimeFormat(TimeOfDay.fromDateTime(endDate), context)}";
  }

}