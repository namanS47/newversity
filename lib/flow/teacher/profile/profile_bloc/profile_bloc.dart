import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'profile_events.dart';

part 'profile_states.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileStates> {
  int currentProfileStep = 0;
  double sliderWidth = 195.0;
  double sliderPadding = 0.0;
  int selectedSkinTone = 0;

  ProfileBloc() : super(ProfileInitial()) {
    on<ChangeProfilecardIndex>((event, emit) async {
      await changeIndex(event.index, isBack: event.isBack);
    });


  }


  List<Widget> profileCardList = <Widget>[];

  Future<void> changeIndex(int index, {bool isBack = false}) async {
    emit(ProfileLoading());
    double singlePart = sliderWidth / (profileCardList.length - 1);
    isBack ? sliderPadding -= singlePart : sliderPadding += singlePart;
    isBack ? currentProfileStep -= 1 : currentProfileStep += 1;
    emit(ProfileCardChangedState());
  }
}
