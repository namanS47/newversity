import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/profile/model/experience_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/profile_dashboard_arguments.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/utils/date_time_utils.dart';

import '../../../common/common_widgets.dart';
import '../../../themes/strings.dart';
import '../../student/seesion/data/experience_data.dart';
import 'bloc/profile_bloc/profile_bloc.dart';
import 'model/education_response_model.dart';

class ExperienceAndEducation extends StatefulWidget {
  final ProfileDashboardArguments profileDashboardArguments;
  const ExperienceAndEducation(
      {Key? key, required this.profileDashboardArguments})
      : super(key: key);

  @override
  State<ExperienceAndEducation> createState() => _ExperienceAndEducationState();
}

class _ExperienceAndEducationState extends State<ExperienceAndEducation> {
  List<ExperienceResponseModel> lisOfExperienceModel = [];
  List<EducationResponseModel> listOfEducationModel = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(FetchTeachersExperienceEvent());
    BlocProvider.of<ProfileBloc>(context).add(FetchTeachersEducationEvents());
  }

  bool isRebuildWidgetState(ProfileStates state) {
    return state is FetchingTeachersExperiencesState ||
        state is FetchingTeachersEducationState ||
        state is FetchedTeachersExperiencesState ||
        state is FetchedTeacherEducationState ||
        state is FetchingTeacherExperienceFailureState ||
        state is FetchingTeacherEducationFailureState;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      buildWhen: (previous, current) => isRebuildWidgetState(current),
      listenWhen: (previous, current) => isRebuildWidgetState(current),
      listener: (context, state) {
        if (state is FetchedTeachersExperiencesState) {
          lisOfExperienceModel = state.listOfTeacherExperience;
        }
        if (state is FetchedTeacherEducationState) {
          listOfEducationModel = state.listOfTeacherEducation;
        }
      },
      builder: (context, state) {
        return getExperienceAndQualificationContent();
      },
    );
  }

  Widget getExperienceAndQualificationContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              getExperienceAndQualificationHeader(),
              const SizedBox(
                height: 20,
              ),
              getContainerHeaderLayout(AppStrings.experience, context),
              const SizedBox(
                height: 10,
              ),
              lisOfExperienceModel.isNotEmpty
                  ? getExperienceLayout()
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              getEducationContainerLayout(AppStrings.education, context),
              const SizedBox(
                height: 10,
              ),
              listOfEducationModel.isNotEmpty
                  ? getEducationLayout()
                  : Container(),
            ],
          ),
        ),
        Container(),
        const SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AppCta(
            text: !widget.profileDashboardArguments.isNewUser
                ? AppStrings.update
                : AppStrings.proceed,
            isLoading: false,
            onTap: () => onTapContinueButton(context),
          ),
        )
      ],
    );
  }

  List<EducationData> educationData = EducationData.educationData;

  Widget getEducationLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 30,
        runSpacing: 12,
        children: List.generate(
          listOfEducationModel.length,
          (curIndex) {
            return getEducationView(curIndex);
          },
        ),
      ),
    );
  }

  Widget getEducationView(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.lightCyan,
          child: AppImage(image: ImageAsset.education),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getEducationalInstitute(index),
              const SizedBox(
                height: 5,
              ),
              getStream(index),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getEducationalDuration(index),
                  getCGPA(index),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<ExperienceData> experienceData = ExperienceData.experienceData;

  Widget getExperienceLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 30,
        runSpacing: 12,
        children: List.generate(
          lisOfExperienceModel.length,
          (curIndex) {
            return getExperienceView(curIndex);
          },
        ),
      ),
    );
  }

  Widget getExperienceView(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.lightCyan,
          child: AppImage(image: ImageAsset.experience),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDesignation(index),
              const SizedBox(
                height: 5,
              ),
              getInstitute(index),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  getDuration(index),
                  const Spacer(),
                  getMode(index),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getStream(int index) {
    return Text(
      "${listOfEducationModel[index].degree}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getEducationalDuration(int index) {
    String durationString = DateTimeUtils.getEmploymentDurationDateTime(
        listOfEducationModel[index].startDate ?? DateTime.now());
    durationString += " - ";
    if (listOfEducationModel[index].currentlyWorkingHere == true) {
      durationString += "Present";
    } else {
      durationString += DateTimeUtils.getEmploymentDurationDateTime(
          listOfEducationModel[index].endDate ?? DateTime.now());
    }
    return Text(
      durationString,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getEducationalInstitute(int index) {
    return Text(
      "${listOfEducationModel[index].name}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getMode(int index) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        "${lisOfExperienceModel[index].location}",
        style: const TextStyle(
            color: AppColors.secColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget getCGPA(int index) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        "CGPA-${listOfEducationModel[index].grade}",
        style: const TextStyle(
            color: AppColors.secColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget getDuration(int index) {
    String durationString = DateTimeUtils.getEmploymentDurationDateTime(
        lisOfExperienceModel[index].startDate ?? DateTime.now());
    durationString += " - ";
    if (lisOfExperienceModel[index].currentlyWorkingHere == true) {
      durationString += "Present";
    } else {
      durationString += DateTimeUtils.getEmploymentDurationDateTime(
          lisOfExperienceModel[index].endDate ?? DateTime.now());
    }

    return Text(
      durationString,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget getDesignation(int index) {
    return Text(
      "${lisOfExperienceModel[index].title}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getInstitute(int index) {
    return Text(
      "${lisOfExperienceModel[index].companyName}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  onAddingEducation(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.addEducation);
    BlocProvider.of<ProfileBloc>(context).add(FetchTeachersExperienceEvent());
    BlocProvider.of<ProfileBloc>(context).add(FetchTeachersEducationEvents());
  }

  onAddingExperience(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.addExperience);
    BlocProvider.of<ProfileBloc>(context).add(FetchTeachersExperienceEvent());
    BlocProvider.of<ProfileBloc>(context).add(FetchTeachersEducationEvents());
  }

  Widget getContainerHeaderLayout(String headerName, context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.grey35.withOpacity(0.90)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getContainerHeader(headerName),
              InkWell(
                onTap: () => onAddingExperience(context),
                child: Icon(
                  Icons.add,
                  color: AppColors.blackMerlin.withOpacity(0.73),
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getEducationContainerLayout(String headerName, context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.grey35.withOpacity(0.90)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getContainerHeader(headerName),
              InkWell(
                onTap: () => onAddingEducation(context),
                child: Icon(
                  Icons.add,
                  color: AppColors.blackMerlin.withOpacity(0.73),
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getContainerHeader(String headerName) {
    return Text(
      headerName,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget getExperienceAndQualificationHeader() {
    return const Text(
      AppStrings.experienceAndEducation,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  onTapContinueButton(BuildContext context) async {
    BlocProvider.of<ProfileBloc>(context).add(ChangeProfileCardIndexEvent());
  }
}
