import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/flow/student/profile_dashboard/bloc/profile_dahsbord_bloc.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/add_tag_request_model.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/enums.dart';

import '../../../../themes/strings.dart';
import '../../../teacher/profile/model/tags_response_model.dart';
import '../data/model/student_detail_saving_request_model.dart';
import '../data/model/student_details_model.dart';

class ExamsPreparingFor extends StatefulWidget {
  const ExamsPreparingFor({Key? key}) : super(key: key);

  @override
  State<ExamsPreparingFor> createState() => _ExamsPreparingForState();
}

class _ExamsPreparingForState extends State<ExamsPreparingFor> {
  final _specifyController = TextEditingController();
  List<TagsResponseModel> allExamsTags = [];
  List<TagModelList> allNewTags = [];
  List<String> allSelectedTags = [];
  List<String> allRequestedTags = [];
  bool isLoading = false;
  bool showErrorText = false;
  bool showSpecify = false;
  final _nameController = TextEditingController();
  StudentDetail? studentDetail;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileDashboardBloc>(context)
        .add(FetchExamTagEvent(tagCat: getTagCategory(TagCategory.exams)));
    BlocProvider.of<ProfileDashboardBloc>(context)
        .add(FetchStudentDetailEvent());

    _specifyController.addListener(() {
      if (_specifyController.text.replaceAll(" ", "").isNotEmpty &&
          _specifyController.text.contains(" ")) {
        setState(() {
          allRequestedTags.add(_specifyController.text);
          _specifyController.text = "";
        });
      }
    });
  }

  bool isRebuildWidgetState(ProfileDashboardStates state) {
    return state is FetchingExamTagState ||
        state is FetchedExamTagState ||
        state is FetchingExamTagFailureState ||
        state is StudentDetailsSavedState ||
        state is StudentDetailsSavingState ||
        state is StudentDetailsSavingFailureState ||
        state is FetchedStudentDetailState ||
        state is AddedTagState;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileDashboardBloc, ProfileDashboardStates>(
      buildWhen: (previous, current) => isRebuildWidgetState(current),
      listenWhen: (previous, current) => isRebuildWidgetState(current),
      listener: (context, state) {
        if (state is FetchedExamTagState) {
          allExamsTags = state.listOfExamsTags;
        }
        if (state is FetchedStudentDetailState) {
          studentDetail = context.read<ProfileDashboardBloc>().studentDetail;
          if (studentDetail?.tags != null && studentDetail!.tags!.isNotEmpty) {
            allSelectedTags = studentDetail!.tags!;
          }
        }
        if (state is StudentDetailsSavedState) {
          for (var element in allSelectedTags) {
            allNewTags
                .add(TagModelList(tagName: element, tagCategory: "exams"));
          }
          BlocProvider.of<ProfileDashboardBloc>(context).add(AddTagsEvent(
              addTagRequestModel:
                  AddTagRequestModel(tagModelList: allNewTags)));
        }
        if (state is AddedTagState) {
          isLoading = false;
          context
              .read<ProfileDashboardBloc>()
              .add(ChangeProfileCardIndexEvent());
        } else if (state is StudentDetailsSavingFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText(
                state.msg,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getNameHeader(),
              const SizedBox(
                height: 10,
              ),
              getNameTextField(),
              const SizedBox(
                height: 20,
              ),
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
              showSpecify ? getTitleHeader() : Container(),
              const SizedBox(
                height: 20,
              ),
              showSpecify ? getYourDesignation() : Container(),
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
                height: 50,
              ),
              AppCta(
                isLoading: isLoading,
                onTap: () => onProceedTap(context),
                text: "Next",
              )
            ],
          ),
        );
      },
    );
  }

  Widget getNameTextField() {
    return AppTextFormField(
      hintText: "Enter your name",
      controller: _nameController,
    );
  }

  Widget getTitleHeader() {
    return const AppText(
      AppStrings.specify,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  Widget getYourDesignation() {
    return AppTextFormField(
      hintText: "PSC",
      controller: _specifyController,
      isDense: true,
    );
  }

  isFormValid() {
    return _nameController.text.isNotEmpty;
  }

  onProceedTap(BuildContext context) {
    if (isFormValid()) {
      allSelectedTags.addAll(allRequestedTags);
      if (allSelectedTags.isNotEmpty) {
        isLoading = true;
        BlocProvider.of<ProfileDashboardBloc>(context).add(
            StudentDetailSaveEvent(
                studentDetailSavingRequestModel:
                    StudentDetailSavingRequestModel(
          studentId: CommonUtils().getLoggedInUser(),
          name: _nameController.text,
          tags: allSelectedTags,
        )));
      } else {
        showErrorText = true;
        setState(() {});
      }
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
                allRequestedTags[curIndex],
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
    if (index == allExamsTags.length - 1) {
      showSpecify = !showSpecify;
    } else if (allSelectedTags.contains(allExamsTags[index].tagName)) {
      allSelectedTags.remove(allExamsTags[index].tagName);
    } else {
      allSelectedTags.add(allExamsTags[index].tagName!);
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
            color: allSelectedTags.contains(allExamsTags[curIndex].tagName)
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
      AppStrings.whatAreYouPreparingFor,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getNameHeader() {
    return const Text(
      AppStrings.yourName,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget selectExamNames() {
    return const Text(
      AppStrings.selectAtLeastOneInfo,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.blackMerlin),
    );
  }
}
