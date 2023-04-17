import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/student/search/data/search_repository.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';

part 'mentor_search_events.dart';

part 'mentor_search_states.dart';

class MentorSearchBloc extends Bloc<MentorSearchEvents, MentorSearchStates> {
  final SearchRepository _searchRepository = DI.inject<SearchRepository>();

  List<String> resultedTags = [];

  MentorSearchBloc() :super(MentorSearchInitialState()) {
    on<GetTagsBySearchKeywordEvent>((event, emit) async {
      emit(FetchingTagBySearchKeywordLoadingState());
      try {
        final response = await _searchRepository.fetchTagsListBySearchKeyword(
            event.searchKeyword);
        resultedTags = response ?? [];
        if (response?.isNotEmpty == true) {
          emit(FetchingTagBySearchKeywordSuccessState());
        } else {
          emit(FetchingTagBySearchKeywordFailureState());
        }
      } catch (exception) {
        emit(FetchingTagBySearchKeywordFailureState());
      }
    });

    on<FetchTeacherListByTagNameEvent>((event, emit) async {
      emit(FetchTeacherListByTagNameLoadingState());
      try {
        final response = await _searchRepository.fetchTeachersListByTagName(
            TagRequestModel(tagModelList: [TagModel(tagName: event.tagName)]));
        emit(FetchTeacherListByTagNameSuccessState(teacherDetailsList: response ?? []));
      } catch (exception) {
        emit(FetchTeacherListByTagNameFailureState());
      }
    });
  }
}