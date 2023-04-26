import 'package:flutter/material.dart';
import 'package:newversity/utils/enums.dart';

class AvailabilityArguments {
  AvailabilityArguments(
      {this.selectedDate,
      this.selectedStartTime,
      this.selectedEndTime,
      this.booked,
      this.availabilityId,
      this.sessionType});

  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  bool? booked;
  SlotType? sessionType;
  String? availabilityId;
}
