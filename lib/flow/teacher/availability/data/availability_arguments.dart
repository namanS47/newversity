import 'package:flutter/material.dart';

class AvailabilityArguments {
  AvailabilityArguments({
    this.selectedDate,
    this.selectedStartTime,
    this.selectedEndTime,
    this.booked,
  });

  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  bool? booked;
}
