import 'package:flutter/material.dart';

import 'date_time_utils.dart';

class StringsUtils {
  static String getAvailabilityStartAndEndTimeString(
      BuildContext context, DateTime startDate, DateTime endDate) {
    return "${DateTimeUtils.getTimeFormat(TimeOfDay.fromDateTime(startDate), context)} - ${DateTimeUtils.getTimeFormat(TimeOfDay.fromDateTime(endDate), context)}";
  }

  static String getTagListTextFromListOfTags(
      List<String> tagList, {required bool showTrimTagList}) {
    String tagListString = "";

    if (tagList.length > 2 && showTrimTagList) {
      tagListString += tagList[0];
      tagListString += ", ";
      tagListString += tagList[1];
      tagListString += ", +${tagList.length - 2}";
    } else {
      for (String tag in tagList) {
        tagListString = "$tagListString$tag,";
      }
    }
    return tagListString;
  }
}
