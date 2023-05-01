class UpcomingSessionDetailsModel {
  String? name;
  String? college;
  String? designation;
  String? profileImageUrl;
  String? sessionType;
  String? certificates;
  double? rating;
  double? sessionAmount;
  DateTime? endTime;
  DateTime? startTime;

  UpcomingSessionDetailsModel(
      {this.name,
      this.college,
      this.designation,
      this.profileImageUrl,
      this.sessionType,
      this.certificates,
      this.rating,
      this.endTime,
      this.sessionAmount,
      this.startTime});

  static List<UpcomingSessionDetailsModel> listOfMentorsDetails = [
    UpcomingSessionDetailsModel(
        name: "Akshat Kamesra",
        college: "IIT BHU",
        designation: "Professional Teacher",
        certificates: "Software development, IIT Entrance exam, +2",
        profileImageUrl:
            "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=612x612&w=0&k=20&c=eU56mZTN4ZXYDJ2SR2DFcQahxEnIl3CiqpP3SOQVbbI=",
        sessionType: "30 min session",
        startTime: DateTime(2024),
        sessionAmount: 250,
        rating: 5),
    UpcomingSessionDetailsModel(
        name: "Akshat Kamesra",
        college: "IIT BHU",
        designation: "Professional Teacher",
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        certificates: "Software development, IIT Entrance exam, +2",
        sessionType: "30 min session",
        startTime: DateTime(2024),
        sessionAmount: 250,
        rating: 5),
    UpcomingSessionDetailsModel(
        name: "Akshat Kamesra",
        college: "IIT BHU",
        designation: "Professional Teacher",
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        certificates: "Software development, IIT Entrance exam, +2",
        sessionType: "30 min session",
        startTime: DateTime(2024),
        sessionAmount: 250,
        rating: 5),
    UpcomingSessionDetailsModel(
        name: "Akshat Kamesra",
        college: "IIT BHU",
        designation: "Professional Teacher",
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        certificates: "Software development, IIT Entrance exam, +2",
        sessionType: "30 min session",
        startTime: DateTime(2024),
        sessionAmount: 250,
        rating: 5),
    UpcomingSessionDetailsModel(
        name: "Akshat Kamesra",
        college: "IIT BHU",
        designation: "Professional Teacher",
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        certificates: "Software development, IIT Entrance exam, +2",
        sessionType: "30 min session",
        startTime: DateTime(2024),
        sessionAmount: 250,
        rating: 5),
  ];
}
