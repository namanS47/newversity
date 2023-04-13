import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'my_session_events.dart';

part 'my_session_states.dart';

class MySessionBloc extends Bloc<MySessionEvents, MySessionStates> {
  int selectedIndex = 0;
  List<String> mySessionCat = ["Upcoming sessions", "Previous sessions"];

  MySessionBloc() : super(MySessionInitialState()) {
    on<ChangeMySessionTabEvent>((event, emit) async {
      await updateMySessionTab(event, emit);
    });
  }

  Future<void> updateMySessionTab(event, emit) async {
    if (event is ChangeMySessionTabEvent) {
      selectedIndex = event.index;
      await emit(UpdatedMySessionTabState());
    }
  }
}
