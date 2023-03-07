import 'package:flutter/material.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/flow/teacher/data/bloc/teacher_details/teacher_details_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/navigation/app_routes.dart';

import '../../../../common/common_widgets.dart';
import '../../../../utils/enums.dart';

class TeacherPersonalInfoRoute extends StatefulWidget {
  const TeacherPersonalInfoRoute({Key? key}) : super(key: key);

  @override
  State<TeacherPersonalInfoRoute> createState() =>
      _TeacherPersonalInfoRouteState();
}

class _TeacherPersonalInfoRouteState extends State<TeacherPersonalInfoRoute> {
  final TextEditingController _controller = TextEditingController();
  Gender? selectedGender;
  String? selectedAgeGroup;
  List<String> ageGroupString = [
    "18-22 yrs",
    "22-25 yrs",
    "25-30 yrs",
    "30-40 yrs",
    "40+yrs"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<TeacherDetailsBloc, TeacherDetailsState>(
          builder: (BuildContext context, TeacherDetailsState state) {
            if(state is TeacherDetailsInitial) {
              return getContentWidget(false);
            }
            if(state is TeacherDetailsSavingState) {
              return getContentWidget(true);
            }
            return getContentWidget(false);
          },
          listener: (BuildContext context, TeacherDetailsState state) {
            if(state is TeacherDetailsSavingSuccessState) {
              Navigator.of(context).pushNamed(AppRoutes.homeScreen);
            } else if(state is TeacherDetailsSavingFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Something went wrong",
                  ),
                ),
              );
            }
          }
         ),
      ),
    );
  }

  Widget getContentWidget(bool isLoading) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Update your personal information"),
              Text(
                  "Complete the following steps for reviewing your registration"),
              SizedBox(
                height: 20,
              ),
              Text("Your Name"),
              AppTextFormField(
                textEditingController: _controller,
                isDense: true,
              ),
              SizedBox(
                height: 30,
              ),
              Text("Upload profile picture"),
              GestureDetector(
                onTap: () {},
                child: CommonWidgets.getRoundedBoxWithText(
                    text: "upload", isSelected: false),
              ),
              SizedBox(
                height: 30,
              ),
              Text("About Yourself"),
              AppTextFormField(
                maxLines: 3,
              ),
              SizedBox(
                height: 30,
              ),
              Text("Your gender"),
              Row(
                children: [
                  getGenderWidget(Gender.male),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: getGenderWidget(Gender.female),
                  ),
                  getGenderWidget(Gender.other)
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Wrap(
                children: ageGroupString
                    .map((ageGroup) => getAgeSelectionWidget(ageGroup))
                    .toList(),
              ),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: getConfirmCta(),
        )
      ],
    );
  }

  Widget getGenderWidget(Gender gender) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: CommonWidgets.getRoundedBoxWithText(
          text: CommonUtils().getGenderString(gender),
          isSelected: gender == selectedGender),
    );
  }

  Widget getAgeSelectionWidget(String ageGroup) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAgeGroup = ageGroup;
        });
      },
      child: CommonWidgets.getRoundedBoxWithText(
          text: ageGroup, isSelected: ageGroup == selectedAgeGroup),
    );
  }

  Widget getConfirmCta() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              print("naman");
              BlocProvider.of<TeacherDetailsBloc>(context).add(SaveTeacherDetailsEvent(teacherDetails: TeacherDetails(teacherId: "namannaman", name: "himanshu", mobileNumber: "894832")));
            },
            child: Container(
              height: 50,
              color: Colors.red,
              child: Center(child: Text("Confirm")),
            ),
          ),
        ),
      ],
    );
  }
}
