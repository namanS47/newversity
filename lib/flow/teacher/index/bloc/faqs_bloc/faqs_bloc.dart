import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../profile/model/expanded_item.dart';

part 'faqs_event.dart';

part 'faqs_state.dart';

class FaqsBloc extends Bloc<FaqsEvents, FaqsStates> {
  List<ExpandedItemModel> data = ExpandedItemModel.listOfExpandedItem;

  FaqsBloc() : super(FaqsInitialState()) {
    on<SearchFaqsEvents>((event, emit) async {
      searchFaqsEvents(event, emit);
    });

    on<OnFaqExpandEvent>((event, emit) async {
      expandFaq(event, emit);
    });
  }

  Future<void> searchFaqsEvents(event, emit) async {
    List<ExpandedItemModel> listOfExpandedModel = [];
    if (event is SearchFaqsEvents) {
      if (event.searchedText.isEmpty) {
        data = ExpandedItemModel.listOfExpandedItem;
      } else {
        for (ExpandedItemModel expandedItemModel in data) {
          if (expandedItemModel.questionAnsModel.question != null &&
              expandedItemModel.questionAnsModel.question != null) {
            if (expandedItemModel.questionAnsModel.question!
                    .toLowerCase()
                    .contains(event.searchedText.toLowerCase()) ||
                expandedItemModel.questionAnsModel.question!
                    .toLowerCase()
                    .contains(event.searchedText.toLowerCase())) {
              listOfExpandedModel.add(expandedItemModel);
            }
          }
        }
        data = listOfExpandedModel;
      }
      SearchedFaqsState();
    }
  }

  Future<void> expandFaq(event, emit) async {
    if (event is OnFaqExpandEvent) {
      data[event.index].isExpanded = !data[event.index].isExpanded;
      emit(ExpandedFaqsState());
    }
  }
}
