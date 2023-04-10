class SessionDetails {
  String? agenda;
  String? mentorName;
  DateTime? dateTime;

  SessionDetails(
      {required this.agenda, required this.mentorName, required this.dateTime});

  static List<SessionDetails> listOdSessionDetails = [
    SessionDetails(
        agenda: "JEE MAIN doubt clearing",
        mentorName: "Akshat Kamesra",
        dateTime: DateTime(2020)),
    SessionDetails(
        agenda: "JEE MAIN doubt clearing",
        mentorName: "Akshat Kamesra",
        dateTime: DateTime(2020)),
    SessionDetails(
        agenda: "JEE MAIN doubt clearing",
        mentorName: "Akshat Kamesra",
        dateTime: DateTime(2020)),
  ];
}

class MentorDetails {
  String? name;
  String? college;
  String? designation;
  String? profileImageUrl;
  double? shortSessionAmount;
  double? longSessionAmount;
  String? certificates;
  double? rating;
  DateTime? startTime;

  MentorDetails(
      {this.name,
      this.college,
      this.designation,
      this.profileImageUrl,
      this.shortSessionAmount,
      this.longSessionAmount,
      this.certificates,
      this.rating,
      this.startTime});

  static List<MentorDetails> listOfMentorsDetails = [
    MentorDetails(
        name: "Akshat Kamesra",
        college: "IIT BHU",
        designation: "Professional Teacher",
        certificates: "Software development, IIT Entrance exam, +2",
        profileImageUrl:
            "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=612x612&w=0&k=20&c=eU56mZTN4ZXYDJ2SR2DFcQahxEnIl3CiqpP3SOQVbbI=",
        longSessionAmount: 250.0,
        shortSessionAmount: 150.0,
        rating: 5),
    MentorDetails(
        name: "Akshat Kamesra",
        college: "IIT BHU",
        designation: "Professional Teacher",
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        certificates: "Software development, IIT Entrance exam, +2",
        longSessionAmount: 250.0,
        shortSessionAmount: 150.0,
        rating: 5),
    MentorDetails(
        name: "Akshat Kamesra",
        college: "IIT BHU",
        designation: "Professional Teacher",
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        certificates: "Software development, IIT Entrance exam, +2",
        longSessionAmount: 250.0,
        shortSessionAmount: 150.0,
        rating: 5),
    MentorDetails(
        name: "Akshat Kamesra",
        college: "IIT BHU",
        designation: "Professional Teacher",
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        certificates: "Software development, IIT Entrance exam, +2",
        longSessionAmount: 250.0,
        shortSessionAmount: 150.0,
        rating: 5),
    MentorDetails(
        name: "Akshat Kamesra",
        college: "IIT BHU",
        designation: "Professional Teacher",
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        certificates: "Software development, IIT Entrance exam, +2",
        longSessionAmount: 250.0,
        shortSessionAmount: 150.0,
        rating: 5),
  ];
}

class MentorsReview {
  String? profileImageUrl;
  String? mentorName;
  String? review;

  MentorsReview({this.profileImageUrl, this.mentorName, this.review});

  static List<MentorsReview> listOfMentorsReview = [
    MentorsReview(
        profileImageUrl:
            "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=612x612&w=0&k=20&c=eU56mZTN4ZXYDJ2SR2DFcQahxEnIl3CiqpP3SOQVbbI=",
        mentorName: "Akshat Kamesra",
        review:
            "\"Newversity is a game-changer for academic success. Its user-friendly interface and helpful features make studying more manageable and efficient.\""),
    MentorsReview(
        profileImageUrl:
            "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=612x612&w=0&k=20&c=eU56mZTN4ZXYDJ2SR2DFcQahxEnIl3CiqpP3SOQVbbI=",
        mentorName: "Akshat Kamesra",
        review:
            "\"Newversity is a game-changer for academic success. Its user-friendly interface and helpful features make studying more manageable and efficient.\""),
    MentorsReview(
        profileImageUrl:
            "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=612x612&w=0&k=20&c=eU56mZTN4ZXYDJ2SR2DFcQahxEnIl3CiqpP3SOQVbbI=",
        mentorName: "Akshat Kamesra",
        review:
            "\"Newversity is a game-changer for academic success. Its user-friendly interface and helpful features make studying more manageable and efficient.\""),
    MentorsReview(
        profileImageUrl:
            "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=612x612&w=0&k=20&c=eU56mZTN4ZXYDJ2SR2DFcQahxEnIl3CiqpP3SOQVbbI=",
        mentorName: "Akshat Kamesra",
        review:
            "\"Newversity is a game-changer for academic success. Its user-friendly interface and helpful features make studying more manageable and efficient.\""),
    MentorsReview(
        profileImageUrl:
            "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=612x612&w=0&k=20&c=eU56mZTN4ZXYDJ2SR2DFcQahxEnIl3CiqpP3SOQVbbI=",
        mentorName: "Akshat Kamesra",
        review:
            "\"Newversity is a game-changer for academic success. Its user-friendly interface and helpful features make studying more manageable and efficient.\""),
    MentorsReview(
        profileImageUrl:
            "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=612x612&w=0&k=20&c=eU56mZTN4ZXYDJ2SR2DFcQahxEnIl3CiqpP3SOQVbbI=",
        mentorName: "Akshat Kamesra",
        review:
            "\"Newversity is a game-changer for academic success. Its user-friendly interface and helpful features make studying more manageable and efficient.\""),
  ];
}

class StudentReview {
  String? profileImageUrl;
  String? review;

  StudentReview({this.profileImageUrl, this.review});

  static List<StudentReview> listOfStudentReview = [
    StudentReview(
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        review:
            "\“Newversity is an excellent tool for anyone seeking guidance and support. The resources and advice provided are invaluable.\""),
    StudentReview(
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        review:
            "\“Newversity is an excellent tool for anyone seeking guidance and support. The resources and advice provided are invaluable.\""),
    StudentReview(
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        review:
            "\“Newversity is an excellent tool for anyone seeking guidance and support. The resources and advice provided are invaluable.\""),
    StudentReview(
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        review:
            "\“Newversity is an excellent tool for anyone seeking guidance and support. The resources and advice provided are invaluable.\""),
    StudentReview(
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        review:
            "\“Newversity is an excellent tool for anyone seeking guidance and support. The resources and advice provided are invaluable.\""),
  ];
}
