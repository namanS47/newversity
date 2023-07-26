import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';
import 'package:newversity/flow/teacher/profile/model/profile_dashboard_arguments.dart';
import 'package:newversity/storage/app_constants.dart';
import 'package:newversity/themes/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/common_utils.dart';
import '../../../common/common_widgets.dart';
import '../../../resources/images.dart';
import '../../../themes/strings.dart';
import '../../../utils/utils.dart';
import '../data/bloc/teacher_details/teacher_details_bloc.dart';
import '../data/model/teacher_details/teacher_details_model.dart';
import 'bloc/profile_bloc/profile_bloc.dart';

class TeacherPersonalInformation extends StatefulWidget {
  final ProfileDashboardArguments profileDashboardArguments;

  const TeacherPersonalInformation(
      {Key? key, required this.profileDashboardArguments})
      : super(key: key);

  @override
  State<TeacherPersonalInformation> createState() =>
      _TeacherPersonalInformationState();
}

class _TeacherPersonalInformationState
    extends State<TeacherPersonalInformation> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _infoController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _languageController = TextEditingController();

  bool showErrorText = false;
  bool isLoading = false;

  List<String>? languageSelected = [];

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _titleController.dispose();
    _infoController.dispose();
    _locationController.dispose();
    _languageController.dispose();
  }

  @override
  void initState() {
    context.read<TeacherDetailsBloc>().add(FetchTeacherDetailEvent());
    super.initState();
  }

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
      } else if (state is FetchTeacherDetailSuccessState) {
        TeacherDetailsModel? details =
            context.read<TeacherDetailsBloc>().teacherDetails;
        _nameController.text = details?.name ?? "";
        _emailController.text = details?.email ?? "";
        _titleController.text = details?.title ?? "";
        _infoController.text = details?.info ?? "";
        _locationController.text = details?.location ?? "";
        if (details?.language != null) {
          languageSelected = details?.language;
        }
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
    return Expanded(
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getPersonalInformationHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getCompleteInstruction(),
                          const SizedBox(
                            height: 10,
                          ),
                          getYourNameHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getYourNameTextField(),
                          const SizedBox(
                            height: 10,
                          ),
                          getYourEmailHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getYourEmailTextField(),
                          const SizedBox(
                            height: 20,
                          ),
                          getUploadPictureHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getUploadPictureBuilder(),
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
                          getLanguageHeader(),
                          const SizedBox(
                            height: 10,
                          ),
                          getYourLanguage(),
                          const SizedBox(
                            height: 20,
                          ),
                          languageSelected != null
                              ? getLanguageSelectedList()
                              : Container(),
                          const SizedBox(
                            height: 200,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(child: Container()),
              Container(
                  decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 0),
                    child: getProceedCTA(context),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget getLanguageSelectedList() {
    return Wrap(
      spacing: 15,
      runSpacing: 12,
      children: List.generate(
        languageSelected!.length,
        (curIndex) {
          return languageView(curIndex);
        },
      ),
    );
  }

  Widget _buildDialogItem(Language language) => Row(
        children: <Widget>[
          Text(language.name),
          const SizedBox(width: 8.0),
          Flexible(child: Text("(${language.isoCode})"))
        ],
      );

  void _openLanguagePickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: LanguagePickerDialog(
                titlePadding: const EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration:
                    const InputDecoration(hintText: 'Search...'),
                isSearchable: true,
                title: const Text('Select your language'),
                onValuePicked: (Language language) => setState(() {
                      if (!languageSelected!.contains(language.name)) {
                        languageSelected?.add(language.name);
                      }
                    }),
                itemBuilder: _buildDialogItem)),
      );

  Widget getYourLanguage() {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _openLanguagePickerDialog();
      },
      child: AppTextFormField(
        isEnable: false,
        hintText: "Add Language",
        controller: _languageController,
      ),
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
      text: !widget.profileDashboardArguments.showBackButton
          ? AppStrings.update
          : AppStrings.proceed,
      isLoading: isLoading,
    );
  }

  Widget getAboutYourSelfTextField() {
    return AppTextFormField(
      controller: _infoController,
      hintText: "Enter here",
      keyboardType: TextInputType.text,
      maxLines: 5,
    );
  }

  Widget getUploadPictureBuilder() {
    return BlocBuilder<TeacherDetailsBloc, TeacherDetailsState>(
      builder: (context, state) {
        if (state is TeacherImageUploadLoadingState) {
          return getUploadPictureLayout(context, true, "Loading");
        }
        if (state is TeacherImageUploadSuccessState) {
          return getUploadPictureLayout(context, false, "Uploaded");
        }
        if (state is TeacherImageUploadFailureState) {
          return getUploadPictureLayout(context, false, "Failed");
        }
        return getUploadPictureLayout(context, false, "Upload");
      },
    );
  }

  Widget getUploadPictureLayout(
      BuildContext context, bool isLoading, String ctaText) {
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
            ),
          ),
        ),
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: isLoading
                    ? CommonWidgets.getCircularProgressIndicator()
                    : Text(
                        ctaText,
                        style: const TextStyle(
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
    XFile? file;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImagePickerOptionBottomSheet(
          onCameraClick: () async {
            final image = await ImagePicker().pickImage(
              source: ImageSource.camera,
              preferredCameraDevice: CameraDevice.front,
              imageQuality: AppConstants.imageUploadQuality,
            );
            if (image != null) {
              file = image;
              Navigator.pop(context);
            }
          },
          onGalleryClick: () async {
            final image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                imageQuality: AppConstants.imageUploadQuality);
            if (image != null) {
              file = image;
              Navigator.pop(context);
            }
          },
        );
      },
    ).whenComplete(() {
      if (file != null) {
        context
            .read<TeacherDetailsBloc>()
            .add(UploadTeacherImageEvent(file: file!));
      }
    });
  }

  Widget getYourNameTextField() {
    return AppTextFormField(
      hintText: "Name",
      keyboardType: TextInputType.text,
      controller: _nameController,
      isDense: true,
    );
  }

  Widget getYourEmailTextField() {
    return AppTextFormField(
      hintText: "email",
      keyboardType: TextInputType.text,
      controller: _emailController,
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

  Widget languageView(int curIndex) {
    return GestureDetector(
      // onTap: () => onSelectedSession(curIndex),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: AppColors.primaryColor,
            border: Border.all(width: 0.3, color: AppColors.grey32)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppText(
                languageSelected?[curIndex] ?? "",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.whiteColor,
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      languageSelected?.removeAt(curIndex);
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

  Widget getLanguageHeader() {
    return const Text(
      AppStrings.language,
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

  Widget getYourEmailHeader() {
    return const Text(
      AppStrings.email,
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
          teacherDetails: TeacherDetailsModel(
            teacherId: CommonUtils().getLoggedInUser(),
            name: _nameController.text,
            email: _emailController.text,
            location: _locationController.text,
            language: languageSelected,
            title: _titleController.text,
            info: _infoController.text,
          ),
        ),
      );
    } else {
      setState(() {
        showErrorText = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please fill all the details",
            ),
          ),
        );
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
