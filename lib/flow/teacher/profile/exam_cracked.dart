import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:newversity/themes/colors.dart';

import '../../../themes/strings.dart';
import 'bloc/profile_bloc/profile_bloc.dart';
import 'model/tags_response_model.dart';

class ExamsCracked extends StatefulWidget {
  const ExamsCracked({Key? key}) : super(key: key);

  @override
  State<ExamsCracked> createState() => _ExamsCrackedState();
}

class _ExamsCrackedState extends State<ExamsCracked> {
  final _specifyController = TextEditingController();
  List<TagsResponseModel> allExamsTags = [];

  List<TagsResponseModel> allSelectedTags = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProfileBloc>(context)
        .add(FetchExamTagsEvent(tagCat: "exams"));
  }

  bool isRebuildWidgetState(ProfileStates state) {
    return state is FetchingTagsState ||
        state is FetchedExamTagsState ||
        state is FetchingTagsFailure ||
        state is SavedTagsState;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      buildWhen: (previous, current) => isRebuildWidgetState(current),
      listenWhen: (previous, current) => isRebuildWidgetState(current),
      listener: (context, state) {
        if (state is FetchedExamTagsState) {
          allExamsTags = state.listOfTags;
        }
        if (state is SavedTagsState) {
          context.read<ProfileBloc>().changeIndex(
                context.read<ProfileBloc>().currentProfileStep,
              );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getExamCrackedHeader(),
              const SizedBox(
                height: 20,
              ),
              selectExamNames(),
              const SizedBox(
                height: 20,
              ),
              allExamsTags.isNotEmpty ? getExamsLayout() : Container(),
              const SizedBox(
                height: 20,
              ),
              showSpecify ? getTitleHeader() : Container(),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              showSpecify ? getYourDesignation() : Container(),
              AppCta(
                onTap: () => onProceedTap(context),
                text: "Proceed",
              )
            ],
          ),
        );
      },
    );
  }

  Widget getTitleHeader() {
    return const Text(
      AppStrings.specify,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getYourDesignation() {
    return AppTextFormField(
      hintText: "PSC",
      controller: _specifyController,
      isDense: true,
    );
  }

  onProceedTap(BuildContext context) {
    List<TagsWithTeacherIdRequestModel> allRequestedTags = [];
    for (TagsResponseModel x in allSelectedTags) {
      allRequestedTags.add(TagsWithTeacherIdRequestModel(
          tagCategory: x.tagCategory, tagName: x.tagName));
    }
    if (_specifyController.text.isNotEmpty) {
      allRequestedTags.add(TagsWithTeacherIdRequestModel(
          tagCategory: "exams", tagName: _specifyController.text));
    }
    BlocProvider.of<ProfileBloc>(context)
        .add(SaveTagsEvents(listOfTags: allRequestedTags));
  }

  List<String> examsCracked = [
    "SSC Board Exams",
    "CBSE Board Exams",
    "NEET",
    "JEE Main",
    "JEE Advance",
    "HSC Board Exams",
    "Others"
  ];

  Widget getExamsLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 15,
        runSpacing: 12,
        children: List.generate(
          allExamsTags.length,
          (curIndex) {
            return examsView(curIndex);
          },
        ),
      ),
    );
  }

  bool showSpecify = false;
  onSelectedSession(int index) {
    if (index == allExamsTags.length - 1) {
      showSpecify = !showSpecify;
    } else if (allSelectedTags.contains(allExamsTags[index])) {
      allSelectedTags.remove(allExamsTags[index]);
    } else {
      allSelectedTags.add(allExamsTags[index]);
    }
    setState(() {});
  }

  Widget examsView(int curIndex) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onSelectedSession(curIndex),
          child: Container(
            height: 55,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: allSelectedTags.contains(allExamsTags[curIndex])
                    ? AppColors.lightCyan
                    : AppColors.grey35,
                border: Border.all(width: 0.3, color: AppColors.grey32)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                allExamsTags[curIndex].tagName ?? "",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            )),
          ),
        ),
      ],
    );
  }

  Widget getExamCrackedHeader() {
    return const Text(
      AppStrings.examsCracked,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget selectExamNames() {
    return const Text(
      AppStrings.selectExamsInfo,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.blackMerlin),
    );
  }
}
