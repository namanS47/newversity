import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/campus/bloc/campus_bloc/campus_bloc.dart';
import 'package:newversity/flow/student/campus/view/student_campus.dart';
import 'package:newversity/flow/student/home/bloc/student_home_bloc.dart';
import 'package:newversity/flow/student/home/view/student_home.dart';
import 'package:newversity/flow/student/student_session/my_session/bloc/my_session_bloc.dart';
import 'package:newversity/flow/student/student_session/my_session/view/my_sessession_screen.dart';
import 'package:newversity/flow/teacher/availability/availability_route.dart';
import 'package:newversity/flow/teacher/bookings/bloc/teacher_bookings_bloc.dart';
import 'package:newversity/flow/teacher/bookings/view/bookings.dart';
import 'package:newversity/flow/teacher/home/bloc/home_session_bloc/home_session_details_bloc.dart';
import 'package:newversity/resources/images.dart';

import '../../availability/availability_bloc/availability_bloc.dart';
import '../../home/home.dart';

part 'index_event.dart';

part 'index_state.dart';

class IndexBloc extends Bloc<IndexEvents, IndexState> {
  int selectedIndex = 0;
  List<Widget> indexPages = <Widget>[
    BlocProvider(
      create: (context) => HomeSessionBloc(),
      child: const Home(),
    ),
    BlocProvider(
      create: (context) => TeacherBookingsBloc(),
      child: const Bookings(),
    ),
    BlocProvider<AvailabilityBloc>(
      create: (context) => AvailabilityBloc(),
      child: const AvailabilityRoute(),
    )
  ];

  List<Widget> studentIndexPage = <Widget>[
    BlocProvider<StudentHomeBloc>(
      create: (context) => StudentHomeBloc(),
      child: const StudentHomeScreen(),
    ),
    BlocProvider<MySessionBloc>(
      create: (context) => MySessionBloc(),
      child: const MySessionScreen(),
    ),
    BlocProvider<StudentCampusBloc>(
      create: (context) => StudentCampusBloc(),
      child: const StudentCampusScreen(),
    )
  ];

  List<Map<String, String>> pagesNameWithImageIcon = <Map<String, String>>[
    {'image': ImageAsset.home, 'name': 'Home'},
    {'image': ImageAsset.bookings, 'name': 'My Bookings'},
    {'image': ImageAsset.availability, 'name': 'Availability'},
  ];

  List<Map<String, String>> studentPagesNameWithImageIcon =
      <Map<String, String>>[
    {'image': ImageAsset.home, 'name': 'Home'},
    {'image': ImageAsset.session, 'name': 'My Session'},
    {'image': ImageAsset.campus, 'name': 'Campus'},
  ];

  IndexBloc() : super(IndexInitialState()) {
    on<IndexPageUpdateEvent>((event, emit) async {
      updatePageIndex(event, emit);
    });
  }

  Future<void> updatePageIndex(event, emit) async {
    if (event is IndexPageUpdateEvent) {
      selectedIndex = event.index;
      emit(PageUpdatedState());
    }
  }
}
