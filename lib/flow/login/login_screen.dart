import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newversity/common/common_widgets.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';
import 'package:newversity/utils/enums.dart';
import 'package:newversity/utils/validaters.dart';

import '../../di/di_initializer.dart';
import '../../firestore/data/firestore_repository.dart';
import '../../firestore/model/user.dart';
import 'login_arguments.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();
  String _phoneNumber = "";
  bool _fetchingOtp = false;
  bool? _phoneNumberValid;
  UserType userType = UserType.teacher;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: getScreeContent(),
    );
  }

  Widget getScreeContent() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: [
              getTopBanner(),
              const SizedBox(
                height: 31,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(userType == UserType.student) studentNameAndIntroWidget(),
                    if(userType == UserType.teacher) teacherNameAndIntroWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    getMobileNumberWidget(),
                    getConfirmCta(),
                    getTAndC(),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverFillRemaining(
            hasScrollBody: false, child: changeUserTypeBottomWidget())
      ],
    );
  }

  Widget getTopBanner() {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
    );
  }

  Widget studentNameAndIntroWidget() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            AppStrings.hiStudent,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: AppColors.blackRussian),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            AppStrings.empoweringYou,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.blackRussian),
          ),
        ],
      ),
    );
  }

  Widget teacherNameAndIntroWidget() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            AppStrings.hiMentor,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: AppColors.blackRussian),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            AppStrings.breakBarrier,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.blackRussian),
          ),
        ],
      ),
    );
  }

  Widget getMobileNumberWidget() {
    return AppTextFormField(
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: PhoneNumberValidator(isOptional: false),
      onChange: (value) {
        _phoneNumber = value;
        if (_phoneNumber.length == 10) {
          setState(() {
            _phoneNumberValid = true;
          });
        }
      },
      fillColor: AppColors.grey35,
      hintText: AppStrings.mobileNumber,
      hintTextStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.blackRussian,
          fontWeight: FontWeight.normal),
      isDense: true,
      errorText: getErrorText(),
    );
  }

  Widget getConfirmCta() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: AppCta(
        onTap: onButtonTap,
        isLoading: _fetchingOtp,
      ),
    );
  }

  onButtonTap() {
    if (isPhoneNumberValid()) {
      fetchOtp();
    } else {
      setState(() {
        _phoneNumberValid = false;
      });
    }
  }

  fetchOtp() async {
    setState(() {
      _fetchingOtp = true;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + _phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          _fetchingOtp = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _fetchingOtp = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _fetchingOtp = false;
        });
        Navigator.of(context).pushNamed(AppRoutes.otpRoute,
            arguments: LoginArguments(
                verificationCode: verificationId, mobileNumber: _phoneNumber, resendToken: resendToken));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _fetchingOtp = false;
        });
      },
    );
  }

  Widget getTAndC() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          AppStrings.clickOnProceed,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.blackMerlin,
          ),
        ),
        Text(
          AppStrings.termsAndConditions,
          style: TextStyle(
            color: AppColors.blackRussian,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget changeUserTypeBottomWidget() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(userType == UserType.teacher) {
                        userType = UserType.student;
                      } else {
                        userType = UserType.teacher;
                      }
                    });
                  },
                  child: changeUserTypeWidget(),
                )),
          ),
        ),
      ],
    );
  }

  Widget changeUserTypeWidget() {
    if (userType == UserType.teacher) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            AppStrings.notMentor,
            style: TextStyle(
              color: AppColors.blackRussian,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            AppStrings.student,
            style: TextStyle(
              color: AppColors.strongCyan,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            AppStrings.notStudent,
            style: TextStyle(
              color: AppColors.blackRussian,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            AppStrings.mentor,
            style: TextStyle(
              color: AppColors.strongCyan,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
  }

  bool isPhoneNumberValid() {
    return _phoneNumber.length == 10;
  }

  String? getErrorText() {
    print("naman---2");
    if (_phoneNumberValid == null || _phoneNumberValid == true) {
      return null;
    }
    print("naman---");
    return "Invalid phone number";
  }
}
