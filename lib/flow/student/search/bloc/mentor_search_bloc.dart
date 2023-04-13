import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'mentor_search_events.dart';
part 'mentor_search_states.dart';

class MentorSearchBloc extends Bloc<MentorSearchEvents,MentorSearchStates>{

  MentorSearchBloc():super(MentorSearchInitialState()){

  }
}