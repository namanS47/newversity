import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';
import 'package:newversity/utils/enums.dart';
import 'package:newversity/utils/string_extensions.dart';

import '../../../data/bloc/teacher_details/teacher_details_bloc.dart';
import '../../../data/model/teacher_details/teacher_details_model.dart';

class ProfileEditSessionRate extends StatefulWidget {
  const ProfileEditSessionRate(
      {Key? key, this.longSessionFee, this.shortSessionFee})
      : super(key: key);
  final double? longSessionFee;
  final double? shortSessionFee;

  @override
  State<ProfileEditSessionRate> createState() => _ProfileEditSessionRateState();
}

class _ProfileEditSessionRateState extends State<ProfileEditSessionRate> {
  var session15minController = TextEditingController();
  var session30minController = TextEditingController();
  List<String> listOfSession = ["For 15 min session", "For 30 min session"];

  bool showErrorText = false;
  bool isLoading = false;

  onTapContinueButton(BuildContext context) async {}

  bool isFormValid() {
    return session30minController.text.isNotEmpty;
  }

  @override
  void initState() {
    if (widget.shortSessionFee != null) {
      session15minController.text = widget.shortSessionFee.toString();
    }
    if (widget.longSessionFee != null) {
      session30minController.text = widget.longSessionFee.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    session15minController.dispose();
    session30minController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherDetailsBloc, TeacherDetailsState>(
      listener: (context, state) {
        if (state is TeacherDetailsSavingSuccessState) {
          isLoading = false;
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 400,
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            "Set your fee",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          getListOfSessionLayout(),
                          const SizedBox(
                            height: 20,
                          ),
                          showErrorText
                              ? const AppText(
                                  "Amount cannot be empty!",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.redColorShadow400,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    const AppText(
                      "Note : We charge 30% Platform fee (Min INR 99) on each session booking",
                      fontWeight: FontWeight.bold,
                    ),
                    getUpdateCTA(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  onSessionRateUpdate() {
    if (isFormValid()) {
      setState(() {
        isLoading = true;
        showErrorText = false;
      });
      Map<String, double> sessionPrice = {
        SlotType.short.toString().split(".")[1]:
            session15minController.text.toDouble,
        SlotType.long.toString().split(".")[1]:
            session30minController.text.toDouble,
      };
      BlocProvider.of<TeacherDetailsBloc>(context).add(
        SaveTeacherDetailsEvent(
          teacherDetails: TeacherDetailsModel(sessionPricing: sessionPrice),
        ),
      );
    } else {
      setState(() {
        showErrorText = true;
      });
    }
  }

  Widget getUpdateCTA() {
    return AppCta(
      text: AppStrings.update,
      isLoading: isLoading,
      onTap: () => onSessionRateUpdate(),
    );
  }

  Widget getListOfSessionLayout() {
    return Wrap(
      spacing: 30,
      runSpacing: 12,
      children: List.generate(
        // listOfSession.length,
        1,
        (curIndex) {
          return sessionEditView(1);
        },
      ),
    );
  }

  Widget sessionEditView(int index) {
    return Row(
      children: [
        Expanded(
            child: AppText(
          listOfSession[index],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        )),
        Container(
          width: 144,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.grey32.withOpacity(0.45),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: index == 0
                    ? session15minController
                    : session30minController,
                decoration: InputDecoration(
                    hintText: index == 0 ? "₹150" : "₹250",
                    hintStyle: const TextStyle(
                        fontSize: 16,
                        color: AppColors.grey55,
                        fontWeight: FontWeight.w200),
                    border: InputBorder.none),
              ),
            ),
          ),
        )
      ],
    );
  }
}
