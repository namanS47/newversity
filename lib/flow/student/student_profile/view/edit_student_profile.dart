import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/common_utils.dart';
import '../../../../common/common_widgets.dart';
import '../../../../resources/images.dart';
import '../../../../themes/colors.dart';
import '../../../../utils/enums.dart';
import '../../../teacher/profile/model/tags_response_model.dart';
import '../../profile_dashboard/data/model/student_detail_saving_request_model.dart';
import '../bloc/student_profile_bloc.dart';

class EditStudentProfile extends StatefulWidget {
  const EditStudentProfile({Key? key}) : super(key: key);

  @override
  State<EditStudentProfile> createState() => _EditStudentProfileState();
}

class _EditStudentProfileState extends State<EditStudentProfile> {
  StudentDetail? studentDetail;
  List<TagsResponseModel> allExamsTags = [];
  List<String> targetExams = [];
  String? targetExam;
  List<String> allSelectedTag = [];
  bool isLoading = false;
  String showTextError = "";
  bool isShowError = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _homeTownController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _mobileNumberController.dispose();
    _locationController.dispose();
    _emailIdController.dispose();
    _homeTownController.dispose();
    _aboutMeController.dispose();
    _languageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentProfileBloc>(context)
        .add(FetchExamTagEvent(tagCat: getTagCategory(TagCategory.exams)));
    BlocProvider.of<StudentProfileBloc>(context).add(FetchStudentEvent());
  }

  onPictureUploadButtonTap(BuildContext context) async {
    bool isCameraPermissionGranted = await askCameraPermission();
    if (isCameraPermissionGranted) {
      upLoadPic(context);
    } else {
      await askCameraPermission();
    }
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
                preferredCameraDevice: CameraDevice.front);
            if (image != null) {
              file = image;
              Navigator.pop(context);
            }
          },
          onGalleryClick: () async {
            final image =
                await ImagePicker().pickImage(source: ImageSource.gallery);
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
            .read<StudentProfileBloc>()
            .add(UploadStudentImageEvent(file: file!));
      }
    });
  }

  Future<bool> askCameraPermission() async {
    await Permission.camera.request();
    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }

    return await Permission.camera.isGranted;
  }

  StudentDetail? profilePicUploadedStudent;

  Widget getProfileImage() {
    return BlocBuilder<StudentProfileBloc, StudentProfileStates>(
      builder: (context, state) {
        if (state is StudentImageUploadingState) {
          return getProfilePicture(context, "Loading");
        }
        if (state is StudentImageUploadedState) {
          profilePicUploadedStudent = state.studentDetail;
          return profilePicUploadedStudent != null
              ? getCurrentUploadedPicture(context, "Uploaded")
              : getProfilePicture(context, "Failed");
        }
        if (state is StudentImageUploadingFailureState) {
          return getProfilePicture(context, "Failed");
        }
        if (state is StudentImageUploadingFailureState) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: AppText(state.msg),
          );
        }
        return getProfilePicture(context, "Upload");
      },
    );
  }

  Widget getCurrentUploadedPicture(BuildContext context, String status) {
    return Stack(
      children: [
        Container(
          height: 73,
          width: 73,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: SizedBox(
              height: 66,
              width: 66,
              child: CircleAvatar(
                radius: 30.0,
                foregroundImage:
                    profilePicUploadedStudent?.profilePictureUrl != null
                        ? NetworkImage(
                            profilePicUploadedStudent!.profilePictureUrl ?? "")
                        : null,
                child: profilePicUploadedStudent?.profilePictureUrl == null
                    ? const AppImage(
                        image: ImageAsset.blueAvatar,
                      )
                    : CommonWidgets.getCircularProgressIndicator(),
              ),
            ),
          ),
        ),
        Positioned(
            right: -2,
            bottom: 5,
            child: GestureDetector(
              onTap: () => onPictureUploadButtonTap(context),
              child: const AppImage(
                image: ImageAsset.icCamera,
              ),
            ))
      ],
    );
  }

  Widget getProfilePicture(BuildContext context, String status) {
    return Stack(
      children: [
        Container(
          height: 73,
          width: 73,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: SizedBox(
              height: 66,
              width: 66,
              child: CircleAvatar(
                radius: 30.0,
                foregroundImage: studentDetail?.profilePictureUrl != null
                    ? NetworkImage(studentDetail!.profilePictureUrl ?? "")
                    : null,
                child: studentDetail?.profilePictureUrl == null
                    ? const AppImage(
                        image: ImageAsset.blueAvatar,
                      )
                    : CommonWidgets.getCircularProgressIndicator(),
              ),
            ),
          ),
        ),
        Positioned(
            right: -2,
            bottom: 5,
            child: GestureDetector(
              onTap: () => onPictureUploadButtonTap(context),
              child: const AppImage(
                image: ImageAsset.icCamera,
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 133,
                decoration:
                    const BoxDecoration(color: AppColors.perSessionRate),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => {Navigator.pop(context)},
                              child:
                                  const AppImage(image: ImageAsset.arrowBack)),
                          const SizedBox(
                            width: 20,
                          ),
                          const AppText(
                            "Edit Personal Information",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            bottom: 10,
            top: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocConsumer<StudentProfileBloc, StudentProfileStates>(
                listener: (context, state) {
                  if (state is FetchedStudentState) {
                    studentDetail = state.studentDetail;
                    _nameController.text = studentDetail?.name ?? "";
                    _mobileNumberController.text =
                        studentDetail?.mobileNumber ?? "";
                    _homeTownController.text = studentDetail?.location ?? "";
                    _aboutMeController.text = studentDetail?.info ?? "";
                    languageSelected = studentDetail?.language ?? [];
                    allSelectedTag = studentDetail?.tags ?? [];
                    _locationController.text = studentDetail?.location ?? "";
                    _aboutMeController.text = studentDetail?.info ?? "";
                  }
                  if (state is FetchedExamTagState) {
                    allExamsTags = state.listOfExamsTags;
                    for (TagsResponseModel element in allExamsTags) {
                      targetExams.add(element.tagName ?? "");
                    }
                  }
                  if (state is SavedStudentDetailsState) {
                    isLoading = false;
                    Navigator.pop(context);
                  }
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 110,
                      ),
                      getProfileImage(),
                      Expanded(
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                              child: studentDetail != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        getNameLayout(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        getMobileNumberLayout(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        getEmailIdLayout(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        targetExams.isNotEmpty
                                            ? getTargetExamLayout()
                                            : Container(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        getYourLanguage(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        getHomeTownLayout(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        getAboutLayout(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        isShowError
                                            ? AppText(
                                                showTextError,
                                                color:
                                                    AppColors.redColorShadow400,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )
                                            : Container(),
                                        AppCta(
                                          onTap: () => onStudentAdd(),
                                          text: "Save",
                                          isLoading: isLoading,
                                        )
                                      ],
                                    )
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Column(
                                        children: const [
                                          Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.cyanBlue,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  onStudentAdd() {
    if (isFormValid()) {
      isLoading = true;
      BlocProvider.of<StudentProfileBloc>(context).add(SaveStudentDetailsEvent(
          studentDetailSavingRequestModel: StudentDetailSavingRequestModel(
        studentId: CommonUtils().getLoggedInUser(),
        name: _nameController.text,
        mobileNumber: _mobileNumberController.text,
        location: _locationController.text,
        info: _aboutMeController.text,
        email: _emailIdController.text,
        language: languageSelected,
        tags: allSelectedTag,
      )));
    } else {
      isLoading = false;
      isShowError = true;
      setState(() {});
    }
  }

  bool isFormValid() {
    if (_nameController.text.isEmpty) {
      showTextError = "please enter your name";
      return false;
    } else if (_mobileNumberController.text.isEmpty) {
      showTextError = "please enter your name";
      return false;
    } else if (allSelectedTag.isEmpty) {
      showTextError = "please select at least one target exam";
      return false;
    } else if (languageSelected.isEmpty) {
      showTextError = "please select at lease a language";
      return false;
    } else if (_locationController.text.isEmpty) {
      showTextError = "please enter your city name";
      return false;
    } else {
      return true;
    }
  }

  Widget getHomeTownLayout() {
    return Column(
      children: [
        Row(
          children: [
            getHeaderText("Hometown/City(state)"),
            const SizedBox(
              width: 10,
            ),
            getCompulsuryWidget()
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        AppTextFormField(
          hintText: "Enter city name",
          controller: _locationController,
        ),
      ],
    );
  }

  Widget getAboutLayout() {
    return Column(
      children: [
        Row(
          children: [
            getHeaderText("About me"),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        AppTextFormField(
          hintText: "Describe yourself",
          controller: _aboutMeController,
        ),
      ],
    );
  }

  List<String> languageSelected = [];

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
                      if (!languageSelected.contains(language.name)) {
                        languageSelected.add(language.name);
                      }
                      _languageController.text = languageSelected.toString();
                    }),
                itemBuilder: _buildDialogItem)),
      );

  Widget getYourLanguage() {
    return Column(
      children: [
        Row(
          children: [
            getHeaderText("Communication language"),
            const SizedBox(
              width: 10,
            ),
            getCompulsuryWidget()
          ],
        ),
        SizedBox(
          height: 12,
        ),
        InkWell(
          onTap: () => _openLanguagePickerDialog(),
          child: AppTextFormField(
            isEnable: false,
            hintText: languageSelected.isNotEmpty
                ? languageSelected.toString()
                : "Multiple select",
            controller: _languageController,
          ),
        ),
      ],
    );
  }

  Widget getTargetExamLayout() {
    return Column(
      children: [
        Row(
          children: [
            getHeaderText("Target exam"),
            const SizedBox(
              width: 10,
            ),
            getCompulsuryWidget()
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        getTargetDropDown()
      ],
    );
  }

  final List<String> allExamTags = ['Salaried', 'Self Employed'];

  Widget getTargetDropDown() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.grey35,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppDropdownButton(
            hint: allSelectedTag.isNotEmpty
                ? "${allSelectedTag}select more target exams.."
                : '-Select-',
            value: targetExam,
            dropdownItems: targetExams,
            onChanged: (value) => selectTargetExamTag(value ?? ""),
          ),
        ),
      ),
    );
  }

  void selectTargetExamTag(String value) {
    if (!allSelectedTag.contains(value)) {
      allSelectedTag.add(value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            "$value added to selected tag ",
            color: Colors.yellowAccent,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            "$value already added ",
            color: AppColors.redColorShadow400,
          ),
        ),
      );
    }
    targetExam = value;
    setState(() {});
  }

  Widget getMobileNumberLayout() {
    return Column(
      children: [
        Row(
          children: [
            getHeaderText("Mobile no."),
            const SizedBox(
              width: 10,
            ),
            getCompulsuryWidget()
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        AppTextFormField(
          hintText: "Enter mobile",
          controller: _mobileNumberController,
        ),
      ],
    );
  }

  Widget getEmailIdLayout() {
    return Column(
      children: [
        Row(
          children: [
            getHeaderText("Email Id"),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        AppTextFormField(
          hintText: "Enter email id",
          controller: _emailIdController,
        ),
      ],
    );
  }

  Widget getNameLayout() {
    return Column(
      children: [
        Row(
          children: [
            getHeaderText("Name"),
            const SizedBox(
              width: 10,
            ),
            getCompulsuryWidget()
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        AppTextFormField(
          hintText: "Enter name",
          controller: _nameController,
        ),
      ],
    );
  }

  Widget getCompulsuryWidget() {
    return const Icon(
      Icons.star_purple500_outlined,
      size: 10,
      color: AppColors.redColorShadow400,
    );
  }

  Widget getHeaderText(String header) {
    return AppText(
      header,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }
}
