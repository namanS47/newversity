class SessionData {
  String nextSessionTopic;
  String mentor;
  String dateTime;
  String timeLeft;

  SessionData(this.nextSessionTopic, this.mentor, this.dateTime, this.timeLeft);

  static List<SessionData> sessionDataList = [
    SessionData("JEE MAIN session doubt", "Mahesh", "FEB 11  06:45 PM",
        "In 34 M : 17 S"),
    SessionData("JEE ADVANCE session doubt", "Suresh", "MAR 15  02:45 PM",
        "In 30 M : 18 S"),
    SessionData(
        "NEET  session doubt", "Kamlesh", "APR 21  03:45 PM", "In 44 M : 27 S"),
    SessionData("UPSC MAIN session doubt", "Animesh", "JUL 01  08:45 PM",
        "In 54 M : 37 S"),
  ];





}
