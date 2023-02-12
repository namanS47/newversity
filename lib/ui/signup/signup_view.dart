import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newversity/controllers/signup_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../generated/l10n.dart';
import '../../utils/new_versity_color_constant.dart';
import '../../utils/new_versity_elevated_button.dart';
import '../../utils/new_versity_error_text.dart';
import '../../utils/new_versity_text.dart';
import '../../utils/new_versity_text_form_field.dart';

class RegistrationFormView extends StatelessWidget {
  User? user;

  final controller = Get.find<SignUpController>();

  RegistrationFormView({Key? key,this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: true,
      children: [
        SizedBox(
          height: 5.h,
        ),
        const SignUpHeader(),
        SizedBox(height: 16.px),
        NameView(),
        SizedBox(height: 16.px),
        EmailView(),
        SizedBox(height: 36.px),
        ClassView(),
        SizedBox(height: 30.px),
        FieldOfInterestView(),
        SizedBox(height: 15.h),
        FlutterDemoElevatedButton(
          buttonRadius: 8.px,
          buttonHeight: 55.px,
          buttonWidth: 296.px,
          buttonColor: FlutterDemoColorConstant.appPrimaryColor,
          buttonName: S.of(context).createAcc,
          padding: EdgeInsets.symmetric(horizontal: 24.px),
          onPressed: () => controller.validateSignUpForm(context,user),
        ),
      ],
    );
  }
}

class ClassView extends StatelessWidget {
  final signUpController = Get.find<SignUpController>();

  ClassView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlutterDemoText(
            S.of(context).tellUsMore,
            fontSize: 20.px,
            fontWeight: FontWeight.w400,
            color: FlutterDemoColorConstant.appBlue,
          ),
          SizedBox(height: 5.h),
          RoundedTextFormField(
            width: 296.px,
            height: 42.px,
            controller: signUpController.classController,
            hintText: S.of(context).whichClass,
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 1.h,
          ),
          if (signUpController.classError.value.isNotEmpty)
            ErrorText(errorText: signUpController.classError.value),
        ],
      ),
    );
  }
}

class FieldOfInterestView extends StatelessWidget {
  final signUpController = Get.find<SignUpController>();

  FieldOfInterestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.px),
          child: SizedBox(
            child: FlutterDemoText(
              S.of(context).whatIsFieldOfIntrest,
              fontSize: 12.px,
              fontWeight: FontWeight.w400,
              color: FlutterDemoColorConstant.appLightBlack,
            ),
          ),
        ),
        SizedBox(height: 16.px),
        SizedBox(
          height: 42.px,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.px),
            primary: false,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () =>
                    signUpController.updateSelectedFieldOfInterest(index),
                child: Container(
                  width: 100.px,
                  decoration: BoxDecoration(
                    color: signUpController.selectedField.value == index
                        ? FlutterDemoColorConstant.appStatusColor
                        : FlutterDemoColorConstant.appSuggestionBorder,
                    borderRadius: BorderRadius.circular(8.px),
                    boxShadow: signUpController.selectedField.value == index
                        ? FlutterDemoColorConstant.appBoxShadow
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlutterDemoText(
                        signUpController.fieldOfInterest[index],
                        color: FlutterDemoColorConstant.lightGreyColor,
                        fontSize: 14.px,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 14.px),
            itemCount: signUpController.fieldOfInterest.length,
          ),
        ),
      ],
    );
  }
}

class EmailView extends StatelessWidget {
  final signUpController = Get.find<SignUpController>();

  EmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedTextFormField(
            controller: signUpController.emailController,
            hintText: S.of(context).email,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 1.h,
          ),
          if (signUpController.emailError.value.isNotEmpty)
            ErrorText(errorText: signUpController.emailError.value),
        ],
      ),
    );
  }
}

class NameView extends StatelessWidget {
  final signUpController = Get.find<SignUpController>();

  NameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedTextFormField(
            height: 48.px,
            width: 296.px,
            controller: signUpController.nameController,
            hintText: S.of(context).name,
          ),
          SizedBox(
            height: 1.h,
          ),
          if (signUpController.nameError.value.isNotEmpty)
            ErrorText(errorText: signUpController.nameError.value),
        ],
      ),
    );
  }
}

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlutterDemoText(
        S.of(context).createAccount,
        fontSize: 30.px,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
