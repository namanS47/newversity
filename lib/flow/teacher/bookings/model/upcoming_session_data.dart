class UpComingSessionData {
  String name;
  String trainingFor;
  String qualification;
  bool crossedThresholdTime;

  UpComingSessionData(this.name, this.trainingFor, this.qualification,
      this.crossedThresholdTime);

  static List<UpComingSessionData> listOfUpComingData = [
    UpComingSessionData("Ikshit Anand", "JEE main", "+2 passed", true),
    UpComingSessionData("Ikshit Anand", "JEE main", "+2 passed", false),
    UpComingSessionData("Ikshit Anand", "JEE main", "+2 passed", false),
    UpComingSessionData("Ikshit Anand", "JEE main", "+2 passed", false),
    UpComingSessionData("Ikshit Anand", "JEE main", "+2 passed", false),
    UpComingSessionData("Ikshit Anand", "JEE main", "+2 passed", false),
    UpComingSessionData("Ikshit Anand", "JEE main", "+2 passed", false),
    UpComingSessionData("Ikshit Anand", "JEE main", "+2 passed", false),
  ];
}
