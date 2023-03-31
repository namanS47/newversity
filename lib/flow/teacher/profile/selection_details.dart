import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/profile/model/profile_dashboard_arguments.dart';
import 'package:newversity/navigation/app_routes.dart';

import '../../../common/common_widgets.dart';
import '../../../themes/colors.dart';
import '../../../themes/strings.dart';
import 'bloc/profile_bloc/profile_bloc.dart';
import 'model/tags_response_model.dart';
import 'model/tags_with_teacher_id_request_model.dart';

class SelectionDetails extends StatefulWidget {
  ProfileDashboardArguments profileDashboardArguments;
  SelectionDetails({Key? key, required this.profileDashboardArguments})
      : super(key: key);

  @override
  State<SelectionDetails> createState() => _SelectionDetailsState();
}

class _SelectionDetailsState extends State<SelectionDetails> {
  final _specifyController = TextEditingController();
  List<TagsResponseModel> allMentorsTags = [];

  List<TagsResponseModel> allSelectedTags = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProfileBloc>(context)
        .add(FetchMentorshipTag(tagCat: "guidance"));
  }

  bool isRebuildWidgetState(ProfileStates state) {
    return state is FetchingTagsState ||
        state is FetchedMentorshipTagsState ||
        state is FetchingTagsFailure ||
        state is SavedTagsState;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      buildWhen: (previous, current) => isRebuildWidgetState(current),
      listenWhen: (previous, current) => isRebuildWidgetState(current),
      listener: (context, state) {
        if (state is FetchedMentorshipTagsState) {
          allMentorsTags = state.listOfMentorshipTags;
        }
        if (state is SavedTagsState) {
          Navigator.of(context).pushNamed(AppRoutes.teacherHomePageRoute);
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getSelectionHeader(),
              const SizedBox(
                height: 20,
              ),
              selectExamNames(),
              const SizedBox(
                height: 20,
              ),
              allMentorsTags.isNotEmpty
                  ? getSelectedComptetiveExams()
                  : Container(),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppCta(
                  onTap: () => onProceedTap(context),
                  text: !widget.profileDashboardArguments.isNewUser
                      ? AppStrings.update
                      : AppStrings.proceed,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  onProceedTap(BuildContext context) {
    List<TagModel> allRequestedTags = [];
    for (TagsResponseModel x in allSelectedTags) {
      allRequestedTags.add(TagModel(
          tagCategory: x.tagCategory, tagName: x.tagName));
    }
    if (_specifyController.text.isNotEmpty) {
      allRequestedTags.add(TagModel(
          tagCategory: "guidance", tagName: _specifyController.text));
    }
    BlocProvider.of<ProfileBloc>(context)
        .add(SaveTagsEvents(listOfTags: allRequestedTags));
  }

  bool showSpecify = false;
  onSelectedSession(int index) {
    if (index == allMentorsTags.length - 1) {
      showSpecify = !showSpecify;
    } else if (allSelectedTags.contains(allMentorsTags[index])) {
      allSelectedTags.remove(allMentorsTags[index]);
    } else {
      allSelectedTags.add(allMentorsTags[index]);
    }
    setState(() {});
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

  List<String> examsCracked = [
    "Personal Mentorship",
    "Exam prep strategy",
    "Career/Market/Industry insights/Future Trends",
    "College Planning",
    "Course/Stream Planning",
    "Interview prep",
    "Job preparation",
    "Professional life experience",
    "Others",
  ];

  Widget getSelectedComptetiveExams() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        allMentorsTags.length,
        (curIndex) {
          return examsView(curIndex);
        },
      ),
    );
  }

  Widget examsView(int curIndex) {
    return GestureDetector(
      onTap: () => onSelectedSession(curIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: allSelectedTags.contains(allMentorsTags[curIndex])
                ? AppColors.lightCyan
                : AppColors.grey35,
            border: Border.all(width: 0.3, color: AppColors.grey32)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            allMentorsTags[curIndex].tagName ?? "",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  Widget getSelectionHeader() {
    return const Text(
      AppStrings.examsSelectionHeader,
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
