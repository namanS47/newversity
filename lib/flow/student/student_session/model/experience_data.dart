
import 'package:newversity/utils/utils.dart';

class ExperienceData {
  String? designation;
  String? institution;
  String? duration;
  String? mode;

  ExperienceData(
      {this.designation, this.institution, this.duration, this.mode});

  static List<ExperienceData> experienceData = [
    ExperienceData(designation: "Assistant Professor",
        institution: "IIT Kharagpur",
        duration: "Jan-2018 - Present",
        mode: "FullTime - Onsite")
  ];
}

class EducationData {
  String? institution;
  String? stream;
  String? duration;
  String? cgpa;

  EducationData({this.institution, this.stream, this.duration, this.cgpa});

  static List<EducationData> educationData = [
    EducationData(institution: "APJ Abdul Kalam University ",
        stream: "B.Tech - Computer Science",
        duration: "Jan-2018 - Present",
        cgpa: "CGPA - 9.86"),
  ];
}

class SessionData {
  String? sessionDuration;
  List<String>? sessionTiming;

  SessionData({this.sessionDuration, this.sessionTiming});

  static List<SessionData> fifteenMinSessions = [
    SessionData(sessionDuration: "2:00 PM - 4:00 PM",sessionTiming: [
      "2.00 PM",
      "2.15 PM",
      "2.30 PM",
      "2.45 PM",
      "3.00 PM",
      "3.15 PM",
      "3.30 PM",
      "3.45 PM",
      "4.00 PM",
    ]),
    SessionData(sessionDuration: "10:00 AM - 10:45 AM",sessionTiming: [
      "10.00 AM",
      "10.15 AM",
      "10.30 AM",
      "10.45 AM",
    ]),
  ];

  static List<SessionData> thirtyMinSession = [
    SessionData(sessionDuration: "2:00 PM - 4:00 PM",sessionTiming: [
      "2.00 PM",
      "2.30 PM",
      "3.00 PM",
      "3.30 PM",
      "4.00 PM",
    ]),
    SessionData(sessionDuration: "10:00 AM - 11:00 AM",sessionTiming: [
      "10.00 AM",
      "10.30 AM",
      "11:00 AM",
    ]),
  ];
}


class SlotData {
  String? slotDay;
  String? slotDate;
  String? slotDuration;

  SlotData({this.slotDay, this.slotDate, this.slotDuration});

  static List<SlotData> slotData = [
    SlotData(slotDay: getCurrentDayName().substring(0, 3).toUpperCase(),
        slotDate: "${getCurrentDate()} ${months[getCurrentMonth() - 1]}",
        slotDuration: "2 Hrs 45 Min"),
    SlotData(slotDay: getDayNameByDiffrence(1).substring(0, 3).toUpperCase(),
        slotDate: "${getTomorrowsDate()}  ${months[getMonthOfTomorrowsDate() -
            1]}",
        slotDuration: "1 Hrs 30 Min"),
    SlotData(slotDay: getDayNameByDiffrence(2).substring(0, 3).toUpperCase(),
        slotDate: "${theyAfterTomorrowsDate()}  ${months[getMonthOfTheyAfterTomorrowsDate() -
            1]}"),
  ];

  static List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
}
