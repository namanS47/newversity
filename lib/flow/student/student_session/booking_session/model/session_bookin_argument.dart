class SessionBookingArgument {
  String studentId;
  String teacherId;
  DateTime startTime;
  DateTime endTime;
  String sessionType;
  double amount;
  String availabilityId;

  SessionBookingArgument(this.studentId, this.teacherId, this.startTime,
      this.endTime, this.sessionType, this.amount, this.availabilityId);

  @override
  String toString() {
    return 'SessionBookingArgument{studentId: $studentId, teacherId: $teacherId, startTime: $startTime, endTime: $endTime, sessionType: $sessionType, amount: $amount}';
  }
}
