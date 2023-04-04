import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newversity/flow/teacher/profile/model/profile_dashboard_arguments.dart';
import 'package:newversity/themes/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/common_utils.dart';
import '../../../common/common_widgets.dart';
import '../../../resources/images.dart';
import '../../../themes/strings.dart';
import '../../../utils/utils.dart';
import '../data/bloc/teacher_details/teacher_details_bloc.dart';
import '../data/model/teacher_details/teacher_details.dart';
import 'bloc/profile_bloc/profile_bloc.dart';

class PersonalInformation extends StatefulWidget {
  final ProfileDashboardArguments profileDashboardArguments;

  const PersonalInformation({Key? key, required this.profileDashboardArguments})
      : super(key: key);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _infoController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();

  bool showErrorText = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherDetailsBloc, TeacherDetailsState>(
        builder: (BuildContext context, TeacherDetailsState state) {
      if (state is TeacherDetailsInitial) {
        return getContentWidget(context);
      }
      if (state is TeacherDetailsSavingState) {
        return getContentWidget(context);
      }
      return getContentWidget(context);
    }, listener: (BuildContext context, TeacherDetailsState state) {
      if (state is TeacherDetailsSavingSuccessState) {
        isLoading = false;
        context.read<ProfileBloc>().add(ChangeProfileCardIndexEvent());
      } else if (state is TeacherDetailsSavingFailureState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Something went wrong",
            ),
          ),
        );
      }
    });
  }

  Widget getContentWidget(BuildContext context) {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getPersonalInformationHeader(),
                  const SizedBox(
                    height: 10,
                  ),
                  getCompleteInstruction(),
                  const SizedBox(
                    height: 20,
                  ),
                  getYourNameHeader(),
                  const SizedBox(
                    height: 10,
                  ),
                  getYourNameTextField(),
                  const SizedBox(
                    height: 20,
                  ),
                  getUploadPictureHeader(),
                  const SizedBox(
                    height: 10,
                  ),
                  getUploadPictureLayout(context),
                  const SizedBox(
                    height: 20,
                  ),
                  getTitleHeader(),
                  const SizedBox(
                    height: 10,
                  ),
                  getYourDesignation(),
                  const SizedBox(
                    height: 20,
                  ),
                  getAboutYourSelfHeader(),
                  const SizedBox(
                    height: 10,
                  ),
                  getAboutYourSelfTextField(),
                  const SizedBox(
                    height: 20,
                  ),
                  getHomeTownHeader(),
                  const SizedBox(
                    height: 10,
                  ),
                  getYourLocation(),
                  const SizedBox(
                    height: 20,
                  ),
                  getErrorText(),
                  const SizedBox(
                    height: 20,
                  ),
                  getProceedCTA(context),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget getErrorText() {
    return Visibility(
      visible: showErrorText,
      child: const Text(
        "Please fill all the details",
        style: TextStyle(color: AppColors.redColorShadow400),
      ),
    );
  }

  bool isFormValid() {
    return _nameController.text.isNotEmpty &&
        _titleController.text.isNotEmpty &&
        _infoController.text.isNotEmpty &&
        _locationController.text.isNotEmpty;
  }

  Widget getProceedCTA(BuildContext context) {
    return AppCta(
      onTap: () => onTapContinueButton(context),
      text: !widget.profileDashboardArguments.isNewUser
          ? AppStrings.update
          : AppStrings.proceed,
      isLoading: isLoading,
    );
  }

  Widget getAboutYourSelfTextField() {
    return AppTextFormField(
      controller: _infoController,
      hintText: "Enter here",
      maxLines: 5,
      textInputAction: TextInputAction.newline,
    );
  }

  Widget getUploadPictureLayout(BuildContext context) {
    return Row(
      children: [
        Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: AppColors.grey35,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(ImageAsset.uploadProfilePic),
            ))),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () => onPictureUploadButtonTap(context),
          child: Container(
            height: 30,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryColor),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  "Upload",
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        )
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

  onPictureUploadButtonTap(BuildContext context) async {
    bool isCameraPermissionGranted = await askCameraPermission();
    if (isCameraPermissionGranted) {
      upLoadPic(context);
    } else {}
  }

  upLoadPic(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return ProfilePhotoPopUp(
          blocContext: context,
          profileUrl: "",
        );
      },
    );
  }

  Widget getYourNameTextField() {
    return AppTextFormField(
      hintText: "Name",
      controller: _nameController,
      isDense: true,
    );
  }

  Widget getYourDesignation() {
    return AppTextFormField(
      hintText: "Your designation",
      controller: _titleController,
      isDense: true,
    );
  }

  Widget getYourLocation() {
    return AppTextFormField(
      hintText: "Enter your hometown",
      controller: _locationController,
      isDense: true,
    );
  }

  Widget getCompleteInstruction() {
    return Text(
      AppStrings.comInstruct,
      style: TextStyle(
          color: AppColors.blackMerlin.withOpacity(0.42),
          fontSize: 14,
          fontWeight: FontWeight.w400),
    );
  }

  Widget getPersonalInformationHeader() {
    return const Text(
      AppStrings.personalInfo,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getTitleHeader() {
    return const Text(
      AppStrings.title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getHomeTownHeader() {
    return const Text(
      AppStrings.homeTown,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getAboutYourSelfHeader() {
    return const Text(
      AppStrings.aboutYourSelf,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getUploadPictureHeader() {
    return const Text(
      AppStrings.uploadProfilePic,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget getYourNameHeader() {
    return const Text(
      AppStrings.yourName,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  onTapContinueButton(BuildContext context) async {
    if (isFormValid()) {
      setState(() {
        isLoading = true;
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
              profilePictureUrl: "yet to be added"),
        ),
      );
    } else {
      setState(() {
        showErrorText = true;
      });
    }
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
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
