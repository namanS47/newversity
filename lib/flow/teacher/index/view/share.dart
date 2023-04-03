import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:newversity/flow/teacher/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:newversity/themes/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../common/common_widgets.dart';
import '../../../../resources/images.dart';
import '../../data/bloc/teacher_details/teacher_details_bloc.dart';
import '../../data/model/teacher_details/teacher_details.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  var profileUrlEditController = TextEditingController();
  TeacherDetails? teacherDetails;
  bool isProfileUrlEditMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(FetchTeacherDetails());
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'Profile URL',
      text: 'Sharing Profile Url',
      linkUrl: teacherDetails?.profileUrl ?? "",
    );
  }

  bool isRebuildWidgetState(ProfileStates state) {
    return state is FetchingTeacherProfile ||
        state is FetchedTeachersProfile ||
        state is FetchingTeachersProfileFailure;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      buildWhen: (previous, current) => isRebuildWidgetState(current),
      listenWhen: (previous, current) => isRebuildWidgetState(current),
      listener: (context, state) {
        if (state is FetchedTeachersProfile) {
          teacherDetails = state.teacherDetails;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                    onTap: () => {Navigator.pop(context)},
                                    child: const AppImage(
                                        image: ImageAsset.arrowBack)),
                                const SizedBox(
                                  width: 10,
                                ),
                                const AppText(
                                  "Share your profile",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        AppText(
                          teacherDetails?.name ?? "",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        getQRCode(),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const AppText(
                          "Edit your custom URL",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        getProfileUrl(),
                        getProfileUrlEditor(),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        getAttachAndShareView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getProfileUrlEditor() {
    profileUrlEditController.text = teacherDetails?.profileUrl ?? "ahbjhbahjb";
    return Visibility(
      visible: isProfileUrlEditMode,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.dividerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                        controller: profileUrlEditController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ))),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () => onConfirmAddingUrlTap(),
                    child: const AppImage(image: ImageAsset.editCheck)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onConfirmAddingUrlTap() {
    isProfileUrlEditMode = false;
    if (isFormValid()) {
      setState(() {
        showErrorText = false;
      });
      BlocProvider.of<TeacherDetailsBloc>(context).add(
        SaveTeacherDetailsEvent(
          teacherDetails:
              TeacherDetails(profileUrl: profileUrlEditController.text),
        ),
      );
    } else {
      setState(() {
        showErrorText = true;
      });
    }
    BlocProvider.of<ProfileBloc>(context).add(FetchTeacherDetails());
  }

  Widget getAttachAndShareView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 80,
          width: 80,
          child: CircleAvatar(
            backgroundColor: AppColors.cyanBlue,
            child: Center(
              child: AppImage(
                color: AppColors.whiteColor,
                image: ImageAsset.attach,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 25,
        ),
        InkWell(
          onTap: () => share(),
          child: const SizedBox(
            height: 80,
            width: 80,
            child: CircleAvatar(
              backgroundColor: AppColors.cyanBlue,
              child: Center(
                child: AppImage(
                  height: 32,
                  width: 32,
                  image: ImageAsset.share,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getProfileUrl() {
    return Visibility(
      visible: !isProfileUrlEditMode,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            teacherDetails?.profileUrl ?? "abhjjhabhabjba",
            color: AppColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
              onTap: () => onProfileEditTap(),
              child: const AppImage(image: ImageAsset.edit)),
        ],
      ),
    );
  }

  bool isFormValid() {
    return profileUrlEditController.text.isNotEmpty;
  }

  bool showErrorText = false;

  onProfileEditTap() {
    isProfileUrlEditMode = true;
    setState(() {});
  }

  Widget getQRCode() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 254,
        width: 254,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.grey32.withOpacity(0.34),
            border: Border.all(width: 1, color: AppColors.grey32)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: QrImage(
              data: teacherDetails?.profileUrl ?? "abjhbajhba",
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
