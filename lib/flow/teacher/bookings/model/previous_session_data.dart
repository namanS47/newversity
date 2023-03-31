class PreviousSessionData {
  String name;
  String guidanceFor;
  String qualification;
  int totalDuration;
  String date;

  PreviousSessionData(this.name, this.guidanceFor, this.qualification,
      this.totalDuration, this.date);

  static List<PreviousSessionData> listOfPreviousData = [
    PreviousSessionData(
        "Sajilli sen", "JEE main", "+2 Passed", 20, "10 Feb 2023"),
    PreviousSessionData(
        "Nanika Srivastav sen", "JEE main", "+2 Passed", 30, "15 Feb 2023"),
    PreviousSessionData(
        "Akshi Garde ", "JEE advance", "+2 Passed", 15, "10 Mar 2023"),
    PreviousSessionData(
        "Sajilli sen", "JEE main", "+2 Passed", 21, "24 Apr 2023"),
    PreviousSessionData(
        "Sajilli sen", "JEE advance", "+2 Passed", 18, "26 Apr 2023"),
    PreviousSessionData(
        "Sajilli sen", "JEE main", "+2 Passed", 20, "28 Apr 2023"),
    PreviousSessionData(
        "Sajilli sen", "JEE main", "+2 Passed", 21, "01 May 2023"),
    PreviousSessionData(
        "Sajilli sen", "JEE main", "+2 Passed", 12, "10 May 2023"),
  ];
}
