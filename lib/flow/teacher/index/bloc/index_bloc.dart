import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/availability/availability_route.dart';
import 'package:newversity/flow/teacher/bookings/bloc/session_details_bloc/session_details_bloc.dart';
import 'package:newversity/flow/teacher/bookings/bloc/teacher_bookings_bloc.dart';
import 'package:newversity/flow/teacher/bookings/view/bookings.dart';
import 'package:newversity/flow/teacher/home/bloc/session_bloc/session_details_bloc.dart';
import 'package:newversity/resources/images.dart';

import '../../availability/availability_bloc/availability_bloc.dart';
import '../../home/home.dart';

part 'index_event.dart';

part 'index_state.dart';

class IndexBloc extends Bloc<IndexEvents, IndexState> {
  int selectedIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> indexPages = <Widget>[
    BlocProvider(
      create: (context) => SessionBloc(),
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

  List<String> drawerOptions = <String>[
    ImageAsset.user,
    ImageAsset.bank,
    ImageAsset.settings,
    ImageAsset.privacyPolicy,
    ImageAsset.termsAndCondition,
    ImageAsset.helpAndSupport,
    ImageAsset.faqs,
  ];

  List<Map<String, String>> pagesNameWithImageIcon = <Map<String, String>>[
    {'image': ImageAsset.home, 'name': 'Home'},
    {'image': ImageAsset.bookings, 'name': 'My Bookings'},
    {'image': ImageAsset.availability, 'name': 'Availability'},
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
