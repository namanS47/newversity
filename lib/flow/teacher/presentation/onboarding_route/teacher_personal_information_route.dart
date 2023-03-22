import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/teacher/data/bloc/teacher_details/teacher_details_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';
import 'package:newversity/storage/preferences.dart';
import 'package:newversity/themes/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/common_widgets.dart';
import '../../../../resources/images.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/utils.dart';

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
            Navigator.of(context).pushNamed(AppRoutes.studentHome);
          } else if (state is TeacherDetailsSavingFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
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
                const Text(
                    "Complete the following steps for reviewing your registration"),
                const SizedBox(
                  height: 20,
                ),
                const Text("Your Name"),
                AppTextFormField(
                  hintText: "Name",
                  controller: _nameController,
                  isDense: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    bool isCameraPermissionGranted =
                        await askCameraPermission();
                    if (isCameraPermissionGranted) {
                    } else {}
                  },
                  child: const Text(
                    "Upload profile picture",
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: CommonWidgets.getRoundedBoxWithText(
                      text: "upload", isSelected: false),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text("Title"),
                AppTextFormField(
                  controller: _titleController,
                  hintText: "Your designation",
                ),
                const SizedBox(
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
                SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: showErrorText,
                  child: Text(
                    "Please fill all the details",
                    style: TextStyle(color: AppColors.redColorShadow400),
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
              print("naman");
              if (isFormValid()) {
                showErrorText = false;
                // setState(() {
                //   showErrorText = false;
                // });
                final mobileNumber =
                    await DI.inject<Preferences>().getMobileNumber();
                BlocProvider.of<TeacherDetailsBloc>(context).add(
                  SaveTeacherDetailsEvent(
                    teacherDetails: TeacherDetails(
                        teacherId: CommonUtils().getLoggedInUser(),
                        name: _nameController.text,
                        mobileNumber: mobileNumber,
                        location: _locationController.text,
                        title: _titleController.text,
                        info: _infoController.text,
                        profilePictureUrl: "yet to be added"),
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

class ProfilePhotoPopUp extends StatelessWidget {
  ProfilePhotoPopUp({
    Key? key,
    required this.blocContext,
    required this.profileUrl,
  }) : super(key: key);

  final BuildContext blocContext;
  final String profileUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: SvgPicture.asset(ImageAsset.cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: isNullOrEmpty(profileUrl)
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        child: SvgPicture.asset(
                          ImageAsset.blueAvatar,
                          width: 100,
                          height: 100,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        foregroundImage: NetworkImage(
                          profileUrl,
                        ),
                        backgroundColor: Colors.white,
                        child: const CircularProgressIndicator(),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  AppStrings.profilePhoto,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () async {
                    final _pickedFile = await _picker.pickImage(
                        source: ImageSource.camera, imageQuality: 50);
                    Navigator.pop(context);
                    if (_pickedFile != null) {
                      // BlocProvider.of<ProfileBloc>(blocContext).add(
                      //   UploadToCloudinaryEvent(
                      //     pickedFile: File(_pickedFile.path),
                      //   ),
                      // );
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        color: AppColors.grey32,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          AppStrings.clickFromCamera,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final _pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                  if (_pickedFile != null) {
                    // BlocProvider.of<ProfileBloc>(blocContext).add(
                    //   UploadToCloudinaryEvent(
                    //     pickedFile: File(_pickedFile.path),
                    //   ),
                    // );
                  }
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.movie,
                      color: AppColors.grey32,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        AppStrings.clickFromGallery,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
