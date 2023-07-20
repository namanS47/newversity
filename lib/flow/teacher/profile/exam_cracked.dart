import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/enums.dart';

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
  List<TagModel> allRequestedTags = [];
  bool isLoading = false;
  bool showErrorText = false;
  late Size _screenSize;

  @override
  void dispose() {
    super.dispose();
    _specifyController.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context)
        .add(FetchExamTagsEvent(tagCat: getTagCategory(TagCategory.exams)));
  }

  bool isRebuildWidgetState(ProfileStates state) {
    return state is FetchingTagsState ||
        state is FetchedExamTagsState ||
        state is FetchingTagsFailure ||
        state is SavedTagsState ||
        state is AddingTagsState;
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return BlocConsumer<ProfileBloc, ProfileStates>(
      buildWhen: (previous, current) => isRebuildWidgetState(current),
      listenWhen: (previous, current) => isRebuildWidgetState(current),
      listener: (context, state) {
        if (state is FetchedExamTagsState) {
          allExamsTags = state.listOfTags;
          final teacherId = context.read<ProfileBloc>().teacherId;
          for (var element in allExamsTags) {
            if (element.teacherTagDetailList?.containsKey(teacherId) == true) {
              allSelectedTags.add(element);
            }
          }
        }
        if (state is SavedTagsState) {
          isLoading = false;
          context.read<ProfileBloc>().changeIndex();
        }
      },
      builder: (context, state) {
        if (state is FetchingTagsState) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.cyanBlue,
                  ),
                )
              ],
            ),
          );
        }
        return Expanded(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 100),
                height: _screenSize.height,
                width: _screenSize.width,
                child: SingleChildScrollView(
                  child: Padding(
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
                        getExamsLayout(),
                        const SizedBox(
                          height: 8,
                        ),
                        getRequestedTagWidget(),
                        const SizedBox(
                          height: 20,
                        ),
                        getTitleHeader(),
                        getYourDesignation(),
                        const SizedBox(
                          height: 10,
                        ),
                        showErrorText
                            ? const AppText(
                                "Please select at least one",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.redColorShadow400,
                              )
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AppCta(
                      isLoading: isLoading,
                      onTap: () => onProceedTap(context),
                      text: "Proceed",
                    ),
                  ),
                ),
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
    return Row(
      children: [
        SizedBox(
          width: _screenSize.width/2+16,
          child: AppTextFormField(
            hintText: "Exam",
            controller: _specifyController,
            isDense: true,
          ),
        ),
        const SizedBox(width: 8,),
        SizedBox(
          width: _screenSize.width/2- 64,
          child: AppCta(
            text: "Add",
            onTap: () {
              setState(() {
                allRequestedTags.add(
                    TagModel(tagCategory: "exams", tagName: _specifyController.text.trim()));
                _specifyController.text = "";
              });
            },
          ),
        )
      ],
    );
  }

  onProceedTap(BuildContext context) {
    if (_specifyController.text.isNotEmpty) {
      allRequestedTags.add(
          TagModel(tagCategory: "exams", tagName: _specifyController.text));
    }
    final List<TagModel> allSelectedTagModel = [];
    for (TagsResponseModel x in allSelectedTags) {
      allSelectedTagModel
          .add(TagModel(tagCategory: x.tagCategory, tagName: x.tagName));
    }

    if (allRequestedTags.isNotEmpty || allSelectedTags.isNotEmpty) {
      isLoading = true;
      BlocProvider.of<ProfileBloc>(context)
          .add(SaveTagsEvents(category: "exams", listOfTags: allRequestedTags + allSelectedTagModel));
    } else {
      showErrorText = true;
      setState(() {});
    }
  }

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

  Widget examsViewForRequestedTag(int curIndex) {
    return GestureDetector(
      // onTap: () => onSelectedSession(curIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.lightCyan,
            border: Border.all(width: 0.3, color: AppColors.grey32)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                allRequestedTags[curIndex].tagName ?? "",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      allRequestedTags.removeAt(curIndex);
                    });
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: AppColors.whiteColor,
                    size: 20,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget getRequestedTagWidget() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        allRequestedTags.length,
        (curIndex) {
          return examsViewForRequestedTag(curIndex);
        },
      ),
    );
  }

  onSelectedSession(int index) {
    if (allSelectedTags.contains(allExamsTags[index])) {
      allSelectedTags.remove(allExamsTags[index]);
    } else {
      allSelectedTags.add(allExamsTags[index]);
    }
    setState(() {});
  }

  Widget examsView(int curIndex) {
    return GestureDetector(
      onTap: () => onSelectedSession(curIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: allSelectedTags.contains(allExamsTags[curIndex])
                ? AppColors.lightCyan
                : AppColors.grey35,
            border: Border.all(width: 0.3, color: AppColors.grey32)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            allExamsTags[curIndex].tagName ?? "",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ),
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
