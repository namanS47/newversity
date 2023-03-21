import 'package:flutter/material.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/teacher/data/bloc/teacher_details/teacher_details_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/storage/preferences.dart';
import 'package:newversity/themes/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/common_widgets.dart';
import '../../../../utils/enums.dart';

class TeacherPersonalInfoRoute extends StatefulWidget {
  const TeacherPersonalInfoRoute({Key? key}) : super(key: key);

  @override
  State<TeacherPersonalInfoRoute> createState() =>
      _TeacherPersonalInfoRouteState();
}

class _TeacherPersonalInfoRouteState extends State<TeacherPersonalInfoRoute> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool showErrorText = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<TeacherDetailsBloc, TeacherDetailsState>(
            builder: (BuildContext context, TeacherDetailsState state) {
          if (state is TeacherDetailsInitial) {
            return getContentWidget(false);
          }
          if (state is TeacherDetailsSavingState) {
            return getContentWidget(true);
          }
          return getContentWidget(false);
        }, listener: (BuildContext context, TeacherDetailsState state) {
          if (state is TeacherDetailsSavingSuccessState) {
            Navigator.of(context).pushNamed(AppRoutes.teacherExperienceAndQualificationRoute);
          } else if (state is TeacherDetailsSavingFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Something went wrong",
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget getContentWidget(bool isLoading) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  hintText: "Name",
                  controller: _nameController,
                  isDense: true,
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    bool isCameraPermissionGranted =
                        await askCameraPermission();
                    if (isCameraPermissionGranted) {
                    } else {}
                  },
                  child: Text(
                    "Upload profile picture",
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: CommonWidgets.getRoundedBoxWithText(
                      text: "upload", isSelected: false),
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Title"),
                AppTextFormField(
                  controller: _titleController,
                  hintText: "Your designation",
                ),
                SizedBox(
                  height: 30,
                ),
                Text("About Yourself"),
                AppTextFormField(
                  controller: _infoController,
                  hintText: "Enter here",
                  maxLines: 3,
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Hometown"),
                AppTextFormField(
                  controller: _locationController,
                  hintText: "Enter your home town",
                )
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                getConfirmCta(),
                SizedBox(height: 8,),
                Visibility(
                  visible: showErrorText,
                  child: Text(
                    "Please fill all the details",
                    style: TextStyle(
                      color: AppColors.redColorShadow400
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getConfirmCta() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: AppCta(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            onTap: () async {
              if (isFormValid()) {
                showErrorText = false;
                setState(() {
                  showErrorText = false;
                });
                BlocProvider.of<TeacherDetailsBloc>(context).add(
                  SaveTeacherDetailsEvent(
                    teacherDetails: TeacherDetails(
                      teacherId: CommonUtils().getLoggedInUser(),
                      name: _nameController.text,
                      location: _locationController.text,
                      title: _titleController.text,
                      info: _infoController.text,
                      profilePictureUrl: "yet to be added"
                    ),
                  ),
                );
              } else {
                setState(() {
                  showErrorText = true;
                });
              }
            },
          ),
        )
      ],
    );
  }

  bool isFormValid() {
    print(_nameController.text);
    return _nameController.text.isNotEmpty &&
        _titleController.text.isNotEmpty &&
        _infoController.text.isNotEmpty &&
        _locationController.text.isNotEmpty;
  }

  Future<bool> askCameraPermission() async {
    await Permission.camera.request();
    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }

    return await Permission.camera.isGranted;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _infoController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
