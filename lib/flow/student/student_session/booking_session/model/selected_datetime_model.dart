class SelectedDateTimeModel {
  DateTime? dateTime;
  String? time;
  DateTime currentSelectedDateTime;
  String? sessionType;
  SelectedDateTimeModel(
      {required this.dateTime, required this.time, required this.sessionType,required this.currentSelectedDateTime});

  @override
  bool operator ==(Object other) {
    return other is SelectedDateTimeModel &&
        time == other.time &&
        dateTime == other.dateTime &&
        sessionType == other.sessionType;
  }

  @override
  int get hashCode => time.hashCode;

  @override
  String toString() => '{ id: $dateTime }';
}
