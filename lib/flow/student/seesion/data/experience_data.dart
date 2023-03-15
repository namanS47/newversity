class ExperienceData {
  String? designation;
  String? institution;
  String? duration;
  String? mode;

  ExperienceData(
      {this.designation, this.institution, this.duration, this.mode});

  static List<ExperienceData> experienceData = [
    ExperienceData(
        designation: "Assistant Professor",
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
    EducationData(
        institution: "APJ Abdul Kalam University ",
        stream: "B.Tech - Computer Science",
        duration: "Jan-2018 - Present",
        cgpa: "CGPA - 9.86"),
  ];
}
