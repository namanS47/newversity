import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/student/search/data/search_repository.dart';

part 'mentor_search_events.dart';
part 'mentor_search_states.dart';

class MentorSearchBloc extends Bloc<MentorSearchEvents,MentorSearchStates>{
  final SearchRepository _searchRepository = DI.inject<SearchRepository>();
  List<String> resultedTags = [];

  MentorSearchBloc():super(MentorSearchInitialState()){
    on<GetTagsBySearchKeywordEvent>((event, emit) async {
      emit(FetchingTagBySearchKeywordLoadingState());
      try{
        final response = await _searchRepository.fetchTagsListBySearchKeyword(event.searchKeyword);
        resultedTags = response ?? [];
        emit(FetchingTagBySearchKeywordSuccessState());
      } catch(exception) {
        emit(FetchingTagBySearchKeywordFailureState());
      }
    });
  }
}