class StudentNotificationModel {
  String? senderProfilePicture;
  String? msg;
  DateTime? msgDatetime;
  String? action;

  StudentNotificationModel(
      {this.senderProfilePicture, this.msg, this.msgDatetime, this.action});

  static List<StudentNotificationModel> listOfStudentNotificationModel = [
    StudentNotificationModel(
        senderProfilePicture:
            "https://imgs.search.brave.com/9PnU8ROt99xL53Je7rexAlefNDKJpr0Mw8u2V8OzYgY/rs:fit:720:707:1/g:ce/aHR0cDovL2dvb2Rt/b3JuaW5naW1hZ2Vz/Zm9ybG92ZXIuY29t/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDE4/LzA5L2dmZDU2NWRm/LmpwZw",
        msg: "Akshat kamesra has rescheduled the booking",
        msgDatetime: DateTime(2024),
        action: "View details"),
    StudentNotificationModel(
        senderProfilePicture:
            "https://imgs.search.brave.com/9PnU8ROt99xL53Je7rexAlefNDKJpr0Mw8u2V8OzYgY/rs:fit:720:707:1/g:ce/aHR0cDovL2dvb2Rt/b3JuaW5naW1hZ2Vz/Zm9ybG92ZXIuY29t/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDE4/LzA5L2dmZDU2NWRm/LmpwZw",
        msg: "Akshat kamesra has cancelled the booking ",
        msgDatetime: DateTime(2024),
        action: "Join call"),
    StudentNotificationModel(
        senderProfilePicture:
            "https://imgs.search.brave.com/9PnU8ROt99xL53Je7rexAlefNDKJpr0Mw8u2V8OzYgY/rs:fit:720:707:1/g:ce/aHR0cDovL2dvb2Rt/b3JuaW5naW1hZ2Vz/Zm9ybG92ZXIuY29t/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDE4/LzA5L2dmZDU2NWRm/LmpwZw",
        msg: "Akshat kamesra has rescheduled the booking",
        msgDatetime: DateTime(2024),
        action: "View reasons"),
    StudentNotificationModel(
        senderProfilePicture:
            "https://imgs.search.brave.com/9PnU8ROt99xL53Je7rexAlefNDKJpr0Mw8u2V8OzYgY/rs:fit:720:707:1/g:ce/aHR0cDovL2dvb2Rt/b3JuaW5naW1hZ2Vz/Zm9ybG92ZXIuY29t/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDE4/LzA5L2dmZDU2NWRm/LmpwZw",
        msg: "Akshat kamesra has rescheduled the booking",
        msgDatetime: DateTime(2024),
        action: "Book session"),
    StudentNotificationModel(
        senderProfilePicture:
            "https://imgs.search.brave.com/9PnU8ROt99xL53Je7rexAlefNDKJpr0Mw8u2V8OzYgY/rs:fit:720:707:1/g:ce/aHR0cDovL2dvb2Rt/b3JuaW5naW1hZ2Vz/Zm9ybG92ZXIuY29t/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDE4/LzA5L2dmZDU2NWRm/LmpwZw",
        msg: "Akshat kamesra has rescheduled the booking",
        msgDatetime: DateTime(2024),
        action: "Start call"),
    StudentNotificationModel(
        senderProfilePicture:
            "https://imgs.search.brave.com/9PnU8ROt99xL53Je7rexAlefNDKJpr0Mw8u2V8OzYgY/rs:fit:720:707:1/g:ce/aHR0cDovL2dvb2Rt/b3JuaW5naW1hZ2Vz/Zm9ybG92ZXIuY29t/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDE4/LzA5L2dmZDU2NWRm/LmpwZw",
        msg: "Akshat kamesra has rescheduled the booking",
        msgDatetime: DateTime(2024),
        action: "View details"),
  ];
}
