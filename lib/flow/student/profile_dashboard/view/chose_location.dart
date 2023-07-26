import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';

import '../../../../common/common_utils.dart';
import '../../../../themes/strings.dart';
import '../bloc/profile_dahsbord_bloc.dart';
import '../data/model/student_detail_saving_request_model.dart';

class StudentProfileLocation extends StatefulWidget {
  const StudentProfileLocation({Key? key}) : super(key: key);

  @override
  State<StudentProfileLocation> createState() => _StudentProfileLocationState();
}

class _StudentProfileLocationState extends State<StudentProfileLocation> {
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  bool isLoading = false;
  bool showErrorText = false;

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileDashboardBloc, ProfileDashboardStates>(
      builder: (context, state) {
        return getScreenContent();
      },
      listener: (context, state) {
        if (state is StudentDetailsSavedState) {
          isLoading = false;
          context
              .read<ProfileDashboardBloc>()
              .add(ChangeStudentProfileCardIndexEvent());
        }
      },
    );
  }

  Widget getScreenContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getNameHeader(),
          const SizedBox(
            height: 10,
          ),
          getNameTextField(),
          const SizedBox(
            height: 30,
          ),
          getFindMentorHeader(),
          const SizedBox(
            height: 10,
          ),
          getSearchHeader(),
          const SizedBox(
            height: 10,
          ),
          getFindMentorSearchWidget(),
          const SizedBox(
            height: 20,
          ),
          Align(alignment: Alignment.bottomCenter, child: getNextCTA()),
        ],
      ),
    );
  }

  Widget getFindMentorSearchWidget() {
    return AppTextFormField(
      controller: _searchController,
      hintText: "City Name",
      // prefixIcon: const AppImage(image: ImageAsset.search),
      // prefixIconConstraints: const BoxConstraints(minHeight: 30, minWidth: 30),
    );
  }

  Widget getNameHeader() {
    return const Text(
      AppStrings.yourName,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getNameTextField() {
    return AppTextFormField(
      hintText: "Enter your name",
      controller: _nameController,
    );
  }

  Widget getSearchHeader() {
    return const AppText(
      "Enter your city",
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  Widget getFindMentorHeader() {
    return const AppText(
      "Find a better mentor from your location",
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  Widget getNextCTA() {
    return AppCta(
      text: "Next",
      onTap: () => onProceedTap(),
    );
  }

  isFormValid() {
    return _nameController.text.isNotEmpty;
  }

  onProceedTap() {
    if (isFormValid()) {
      isLoading = true;
      BlocProvider.of<ProfileDashboardBloc>(context).add(StudentDetailSaveEvent(
          studentDetailSavingRequestModel: StudentDetailSavingRequestModel(
              studentId: CommonUtils().getLoggedInUser(),
              name: _nameController.text,
              location: _searchController.text)));
    } else {
      showErrorText = true;
      setState(() {});
    }
  }
}
