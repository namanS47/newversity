class SessionBookingArgument {
  String studentId;
  String teacherId;
  DateTime startTime;
  DateTime endTime;
  String sessionType;
  double amount;

  SessionBookingArgument(this.studentId, this.teacherId, this.startTime,
      this.endTime, this.sessionType, this.amount);

  @override
  String toString() {
    return 'SessionBookingArgument{studentId: $studentId, teacherId: $teacherId, startTime: $startTime, endTime: $endTime, sessionType: $sessionType, amount: $amount}';
  }
}
