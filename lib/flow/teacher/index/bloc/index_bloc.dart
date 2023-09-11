import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/home/bloc/student_home_bloc.dart';
import 'package:newversity/flow/student/home/view/student_home.dart';
import 'package:newversity/flow/student/student_session/my_session/bloc/my_session_bloc.dart';
import 'package:newversity/flow/student/student_session/my_session/view/my_sessession_screen.dart';
import 'package:newversity/flow/student/webinar/bloc/webinar_bloc.dart';
import 'package:newversity/flow/student/webinar/ui/webinar_route.dart';
import 'package:newversity/flow/teacher/availability/availabality.dart';
import 'package:newversity/flow/teacher/bookings/bloc/teacher_bookings_bloc.dart';
import 'package:newversity/flow/teacher/bookings/view/bookings.dart';
import 'package:newversity/flow/teacher/home/bloc/home_session_bloc/home_session_details_bloc.dart';
import 'package:newversity/flow/teacher/profile/model/profile_completion_percentage_response.dart';
import 'package:newversity/resources/images.dart';

import '../../../../common/common_utils.dart';
import '../../../../di/di_initializer.dart';
import '../../../../network/webservice/exception.dart';
import '../../../student/webservice/student_base_repository.dart';
import '../../availability/availability_bloc/availability_bloc.dart';
import '../../home/home.dart';
import '../../webservice/teacher_base_repository.dart';

part 'index_event.dart';

part 'index_state.dart';

class IndexBloc extends Bloc<IndexEvents, IndexState> {
  final TeacherBaseRepository _teacherBaseRepository =
      DI.inject<TeacherBaseRepository>();

  final StudentBaseRepository _studentBaseRepository =
      DI.inject<StudentBaseRepository>();

  var userId = CommonUtils().getLoggedInUser();
  int selectedIndex = 0;
  List<Widget> indexPages = <Widget>[];

  List<bool> indexPageLoadedList = [true, false, false];

  List<Widget> studentIndexPage = <Widget>[];

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
    updateIndexPageList();

    on<IndexPageUpdateEvent>((event, emit) async {
      updatePageIndex(event, emit);
    });

    on<FetchTeacherProfileCompletenessPercentageEvent>((event, emit) async {
      await getTeacherProfileCompletenessInfo(event, emit);
    });
  }

  Future<void> updatePageIndex(event, emit) async {
    if (event is IndexPageUpdateEvent) {
      indexPageLoadedList[event.index] = true;
      updateIndexPageList();
      selectedIndex = event.index;
      emit(PageUpdatedState());
    }
  }

  Future<void> getTeacherProfileCompletenessInfo(
      event, Emitter<IndexState> emit) async {
    try {
      emit(FetchingProfileCompletionInfoState());
      if (event is FetchTeacherProfileCompletenessPercentageEvent) {
        final response =
            await _teacherBaseRepository.getProfileCompletionInfo(userId);
        emit(FetchedProfileCompletionInfoState(
            profileCompletionPercentageResponse: response));
      } else if (event is FetchStudentProfileCompletenessPercentageEvent) {
        final response =
            await _studentBaseRepository.getProfileCompletionInfo(userId);
        emit(FetchedProfileCompletionInfoState(
            profileCompletionPercentageResponse: response));
      }
    } catch (exception) {
      if (exception is BadRequestException) {
        emit(FetchingProfileCompletionInfoFailureState(
            msg: exception.message.toString()));
      }
    }
  }

  updateIndexPageList() {
    studentIndexPage = [
      BlocProvider<StudentHomeBloc>(
        create: (context) => StudentHomeBloc(),
        child: const StudentHomeScreen(),
      ),
      indexPageLoadedList[1]
          ? BlocProvider<MySessionBloc>(
              create: (context) => MySessionBloc(),
              child: const MySessionScreen(),
            )
          : Container(),
      indexPageLoadedList[2]
          ? BlocProvider<WebinarBloc>(
              create: (context) => WebinarBloc(),
              child: const WebinarTab(),
            )
          : Container()
    ];

    indexPages = [
      BlocProvider(
        create: (context) => HomeSessionBloc(),
        child: const Home(),
      ),
      indexPageLoadedList[1]
          ? BlocProvider(
              create: (context) => TeacherBookingsBloc(),
              child: const Bookings(),
            )
          : Container(),
      indexPageLoadedList[2]
          ? BlocProvider<AvailabilityBloc>(
              create: (context) => AvailabilityBloc(),
              child: const Availability(),
            )
          : Container()
    ];
  }
}
