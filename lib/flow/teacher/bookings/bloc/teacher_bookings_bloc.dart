import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'teacher_booking_events.dart';

part 'teacher_booking_states.dart';

class TeacherBookingsBloc
    extends Bloc<TeacherBookingEvent, TeacherBookingStates> {
  int selectedIndex = 0;
  List<String> sessionCategory = ["Upcoming Bookings", "Previous Booking"];

  TeacherBookingsBloc() : super(TeacherBookingInitial()) {
    on<ChangeSessionTabEvent>((event, emit) async {
      await updateSessionTab(event, emit);
    });
  }

  Future<void> updateSessionTab(event, emit) async {
    if (event is ChangeSessionTabEvent) {
      selectedIndex = event.index;
      await emit(UpdatedSessionState());
    }
  }
}
