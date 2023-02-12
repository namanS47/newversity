import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:newversity/routes/route_helper.dart';
import 'package:newversity/ui/login/login_arguments.dart';
import 'package:newversity/utils/new_versity_color_constant.dart';

import '../utils/new_versity_validation_utils.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final RxString currentOtpController = "".obs;
  RxInt counter = 30.obs;
  RxString otpError = "".obs;
  RxString otpResnd = "".obs;
  RxBool isToResendCode = false.obs;
  final RxString verificationId = "".obs;
  RxString errorPhoneText = ''.obs;

  Future<void> validateLoginForm(BuildContext context) async {
    if (ValidationUtils.validateEmptyController(phoneController)) {
      errorPhoneText = "Please enter phone number".obs;
    } else if (ValidationUtils.lengthValidator(phoneController, 10)) {
      errorPhoneText = 'Phone number should not be less than 10 digit'.obs;
    } else {
      errorPhoneText = ''.obs;
    }
    refresh();
    if (errorPhoneText.value.isEmpty) await signInUser();
  }

  Future<void> startTimer() async {
    counter = 30.obs;
    final timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (counter > 0) {
        counter = counter - 1;
        update();
      } else {
        timer.cancel();
        isToResendCode = true.obs;
        refresh();
      }
    });
  }

  Future<void> validateOtp(
      BuildContext context, String verificationCode) async {
    if (ValidationUtils.validateEmptyController(otpController)) {
      otpError = "Please enter otp".obs;
    } else if (ValidationUtils.lengthValidator(otpController, 6)) {
      otpError = 'Otp should not be less than 6 digit'.obs;
    } else {
      otpError = ''.obs;
    }
    refresh();
    if (otpError.value.isEmpty) await verifyOtp(verificationCode);
  }

  Future<void> resendCode() async {
    otpResnd = "Otp sent again".obs;
    isToResendCode = false.obs;
    update();
    startTimer();
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: '+91${phoneController.text.trim()}',
          verificationCompleted: (verficationCompleted) {
            Get.snackbar("Otp Error", verficationCompleted.smsCode.toString(),
                colorText: FlutterDemoColorConstant.appRed);
          },
          verificationFailed: (verFailed) {
            Get.snackbar("Otp Error", verFailed.message.toString(),
                colorText: FlutterDemoColorConstant.appRed);
          },
          codeSent: (codeSent, tokenSend) {

          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Otp Error", e.message.toString(),
          colorText: FlutterDemoColorConstant.appRed);
    }
  }

  Future<void> verifyOtp(String verificationCode) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: otpController.text.trim());
      final result = await auth.signInWithCredential(credential);
      if (result.additionalUserInfo?.isNewUser==true) {
        Get.toNamed(RouteHelper.getSignUpPage(), arguments: result.user);
      } else {
        Get.offAllNamed(RouteHelper.getHomePage());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Invalid Otp", e.message.toString(),
          colorText: FlutterDemoColorConstant.appRed);
    }
  }

//     FirebaseAuth auth = FirebaseAuth.instance;
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.loginArguments.verificationCode, smsCode: currentText);
//     // await DI.inject<FireStoreRepository>().addUserToFireStore(UserData(userId: "IGiEzbtcMiWlbJ4s2yj7UaqsSTi2", name: "naman", phoneNumber: "", profileUrl: ""));
//     try{
//       final result = await auth.signInWithCredential(credential);
//       await DI.inject<FireStoreRepository>().addUserToFireStore(UserData(userId: "IGiEzbtcMiWlbJ4s2yj7UaqsSTi2", name: "naman", phoneNumber: widget.loginArguments.mobileNumber ));
//       // await DI.inject<FireStoreRepository>().addUserToFireStore(UserData(userId: result.user?.uid ?? "", name: "naman", phoneNumber: widget.loginArguments.mobileNumber));
//       Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.homeScreen, (route) => false);
//     } catch(e) {
//       print("Please enter corrent otp");
//     }
//   }
// }

  Future<void> signInUser() async {
    User? user;
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      await auth.verifyPhoneNumber(
        phoneNumber: '+91${phoneController.text.trim()}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Invalid User", e.message!,
              colorText: FlutterDemoColorConstant.appRed);
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationId = verificationId..obs;
          Get.toNamed(RouteHelper.getOtpPage(),
              arguments: LoginArguments(
                  verificationCode: verificationId,
                  mobileNumber: phoneController.text.trim()));
          // Navigator.of(context).pushNamed(AppRoutes.otpRoute, arguments: LoginArguments(verificationCode: verificationId, mobileNumber: _phoneNumber));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      // final signInResult = await auth.signInWithEmailAndPassword(
      //     email: emailController.text.trim(),
      //     password: passwordController.text.trim());
      // user = signInResult.user;
      // if (user != null) {
      //   await FlutterSharedPreference.saveUserLoggedInStatus(true);
      //   await FlutterSharedPreference.saveUserName(user.displayName!);
      //   await FlutterSharedPreference.saveUserEmail(user.email!);
      //   Get.offAndToNamed(RouteHelper.getHomePage());
      // }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message!);
    }
  }
}
