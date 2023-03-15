import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/flow/teacher/data/bloc/teacher_details/teacher_details_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';
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
          if (state is TeacherDetailsInitial) {
            return getContentWidget(false);
          }
          if (state is TeacherDetailsSavingState) {
            return getContentWidget(true);
          }
          return getContentWidget(false);
        }, listener: (BuildContext context, TeacherDetailsState state) {
          if (state is TeacherDetailsSavingSuccessState) {
            Navigator.of(context).pushNamed(AppRoutes.homeScreen);
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
              GestureDetector(
                onTap: () async {

                  bool isCameraPermissionGranted = await askCameraPermission();
                  if (isCameraPermissionGranted) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return ProfilePhotoPopUp(
                            blocContext: context,
                            profileUrl:"",
                          );
                        });

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
              BlocProvider.of<TeacherDetailsBloc>(context).add(
                  SaveTeacherDetailsEvent(
                      teacherDetails: TeacherDetails(
                          teacherId: "namannaman",
                          name: "himanshu",
                          mobileNumber: "894832")));
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

  Future<bool> askCameraPermission() async {
    await Permission.camera.request();
    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }

    return await Permission.camera.isGranted;
  }
}

class ProfilePhotoPopUp extends StatelessWidget {
  ProfilePhotoPopUp(
      {Key? key,
      required this.blocContext,
      required this.profileUrl,})
      : super(key: key);

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
