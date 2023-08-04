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
}

class MentorsReview {
  String? profileImageUrl;
  String? mentorName;
  String? review;
  String? title;

  MentorsReview({this.profileImageUrl, this.mentorName, this.review, this.title});

  static List<MentorsReview> listOfMentorsReview = [
    MentorsReview(
        profileImageUrl:
            "https://newversity.s3.ap-south-1.amazonaws.com/WhatsApp+Image+2023-08-04+at+16.19.10.jpeg",
        mentorName: "Aprajit Lohan",
        title: "IPS 2020, Rank 174, UPSC CSE 2019",
        review:
            "\"Newversity is the heartbeat of knowledge exchange, where mentors and students thrive. Inspiring the next generation of leaders on Newversity is an honor that fuels my passion.\""),
    MentorsReview(
        profileImageUrl:
            "https://newversity.s3.amazonaws.com/20230730162717985474z1visWaXKEMqFzsgoGjqxt53CUY2.jpg",
        mentorName: "Rohit MR",
        title: "NIT & IIM Alumus, Ex- Global business head ",
        review:
            "\"Newversity is a much-needed breakthrough catering to young aspiring minds to be informed and Inspired for their career & academic success.\""),
    MentorsReview(
        profileImageUrl:
            "https://newversity.s3.amazonaws.com/20230729181532149701LrVzNgg1UMQkEJJLRrrSocQEqga2.jpg",
        mentorName: "Onkar Shaligram",
        title: "IIT Bombay & IIM Alumus",
        review:
            "\"Newversity is a great platform that allows students to connect with mentors with similar interests and backgrounds with an easy-to-use app.\""),
  ];
}

class StudentReview {
  String? profileImageUrl;
  String? review;
  String? name;

  StudentReview({this.profileImageUrl, this.review, this.name});

  static List<StudentReview> listOfStudentReview = [
    StudentReview(
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        name: "Anuradha Soni (UPSC Aspirant)",
        review:
            "“Career guidance & decision making is one of the key challenge in every student's life. Newversity has made it very easy to connect with the right person & learn from their experience\""),
    StudentReview(
        profileImageUrl:
            "https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?b=1&s=612x612&w=0&k=20&c=eU56mZTN4ZXYDJ2SR2DFcQahxEnIl3CiqpP3SOQVbbI=",
        name: "Krishna (College Student)",
        review:
            "“I was always confused about career options in my stream, Newversity enabled me to conenct with right expert and have real insights from him\""),
    StudentReview(
        profileImageUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
        name: "Anuskha (College Student)",
        review:
            "“Thanks to newversity, I connected with an industry expert who provided invaluable guidance, helping me navigate my career path with confidence and clarity.\""),
  ];
}
