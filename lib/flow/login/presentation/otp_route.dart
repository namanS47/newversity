import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/storage/preferences.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../common/common_widgets.dart';
import '../login_arguments.dart';

class OtpRoute extends StatefulWidget {
  const OtpRoute({Key? key, required this.loginArguments}) : super(key: key);

  final LoginArguments loginArguments;

  @override
  State<OtpRoute> createState() => _OtpRouteState();
}

class _OtpRouteState extends State<OtpRoute> {
  TextEditingController textEditingController = TextEditingController();
  bool _isLoading = false;
  int pinCodeFieldLength = 6;
  bool showErrorText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppStrings.verifyOtp,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    color: AppColors.blackRussian),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    AppStrings.enterOtp,
                    style:
                        TextStyle(fontSize: 12, color: AppColors.blackMerlin),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " +91 ${widget.loginArguments.mobileNumber}",
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.blackMerlin),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        SvgPicture.asset(ImageAsset.editIcon)
                      ],
                    ),
                  )
                ],
              ),
            ),
            getPinCodeField(),
            SizedBox(
              height: 24,
            ),
            ResendOtpWidget(
              loginArguments: widget.loginArguments,
            ),
            getConfirmCta(),
            if (showErrorText) getErrorText()
          ],
        ),
      ),
    );
  }

  Widget getPinCodeField() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
          child: PinCodeTextField(
            controller: textEditingController,
            appContext: context,
            length: pinCodeFieldLength,
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
                borderWidth: 1,
                inactiveColor: AppColors.grey32,
                activeColor: AppColors.grey32,
                selectedColor: AppColors.grey32,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: AppColors.grey32,
                selectedFillColor: AppColors.grey32,
                inactiveFillColor: AppColors.grey32),
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            onCompleted: (v) {
              verifyOtp(context);
            },
            beforeTextPaste: (text) {
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
            onChanged: (String value) {},
          ),
        ),
      ],
    );
  }

  Widget getConfirmCta() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: AppCta(
        onTap: onButtonTap,
        text: AppStrings.verifyOtp,
        isLoading: _isLoading,
      ),
    );
  }

  onButtonTap() {
    if (_isLoading) {
      return;
    }
    if (textEditingController.value.text.length == pinCodeFieldLength) {
      showErrorText = false;
      verifyOtp(context);
    } else {
      setState(() {
        showErrorText = true;
      });
    }
  }

  verifyOtp(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.loginArguments.verificationCode,
        smsCode: textEditingController.value.text);
    try {
      final result = await auth.signInWithCredential(credential);
      final preferences = DI.inject<Preferences>();
      preferences.setMobileNumber(widget.loginArguments.mobileNumber);
      preferences.setUserType(widget.loginArguments.userType);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.initialRoute, (route) => false);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget getErrorText() {
    return const Text(
      AppStrings.correctOtp,
      style: TextStyle(
        color: AppColors.redColorShadow400,
      ),
    );
  }
}

class ResendOtpWidget extends StatefulWidget {
  const ResendOtpWidget({Key? key, required this.loginArguments})
      : super(key: key);

  final LoginArguments loginArguments;

  @override
  State<ResendOtpWidget> createState() => _ResendOtpWidgetState();
}

class _ResendOtpWidgetState extends State<ResendOtpWidget>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _resendOtpDuration = 30;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _resendOtpDuration == 0 ? resendOtpWidget() : resendOtpTimer(),
    );
  }

  Widget resendOtpTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Resend Otp in ",
          style: TextStyle(
            color: AppColors.strongCyan,
          ),
        ),
        Text(
          '00:${(_resendOtpDuration < 10) ? '0$_resendOtpDuration' : "$_resendOtpDuration"}',
          style: TextStyle(
              color: AppColors.blackMerlin, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget resendOtpWidget() {
    return GestureDetector(
      onTap: () {
        resendOtp();
      },
      child: const Text(
        "Resend Otp",
        style: TextStyle(
            color: AppColors.strongCyan,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationThickness: 4),
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_resendOtpDuration == 0) {
          timer.cancel();
        } else {
          setState(() {
            _resendOtpDuration--;
          });
        }
      },
    );
  }

  void resendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.loginArguments.mobileNumber}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        _resendOtpDuration = 30;
        startTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
