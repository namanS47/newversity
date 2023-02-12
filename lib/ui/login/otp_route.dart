import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:newversity/controllers/login_controller.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../generated/l10n.dart';
import '../../utils/new_versity_assets.dart';
import '../../utils/new_versity_color_constant.dart';
import '../../utils/new_versity_elevated_button.dart';
import '../../utils/new_versity_error_text.dart';
import '../../utils/new_versity_text.dart';
import 'login_arguments.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({Key? key, required this.loginArguments})
      : super(key: key);

  final LoginArguments loginArguments;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      initState: (state){
        final loginController = Get.find<LoginController>();
        loginController.startTimer();
      },
      builder: (LoginController signUpPageController) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterDemoText(
                  S.of(context).verificationDescription,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'EB Garamond',
                  fontSize: 30.px,
                ),
                SizedBox(height: 16.px),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: FlutterDemoAssets.defaultFont,
                      color: FlutterDemoColorConstant.lightGreyColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.px,
                    ),
                    children: [
                      TextSpan(
                          text: S.of(context).justSendCode,
                          style: const TextStyle(
                              color: FlutterDemoColorConstant.appLightBlack)),
                      TextSpan(
                          text: signUpPageController.phoneController.text,
                          style: const TextStyle(
                              color: FlutterDemoColorConstant.appLightBlack)),
                    ],
                  ),
                ),
                SizedBox(height: 30.px),
                Padding(
                  padding: EdgeInsets.all(16.0.px),
                  child: Pinput(
                    controller: signUpPageController.otpController,
                    length: 6,
                    onCompleted: (v){
                      signUpPageController.validateOtp(context,loginArguments.verificationCode);
                    },
                    focusedPinTheme: PinTheme(
                      height: 56.px,
                      width: 276.px / 6,
                      decoration: BoxDecoration(
                        color: FlutterDemoColorConstant.appWhite,
                        border: Border.all(
                            color:
                                FlutterDemoColorConstant.appCreateACHintColor,
                            width: 1.75.px),
                        borderRadius: BorderRadius.circular(10.5.px),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                SizedBox(height: 30.px),
                if (signUpPageController.otpError.value.isNotEmpty)
                  Align(
                    alignment: Alignment.center,
                    child: ErrorText(errorText: signUpPageController.otpError.value),
                  ),
                SizedBox(height: 30.px),
                if (signUpPageController.otpResnd.value.isNotEmpty)
                  Align(
                    alignment: Alignment.center,
                    child: FlutterDemoText(signUpPageController.otpResnd.value,
                    color: FlutterDemoColorConstant.appGreen,),
                  ),
                SizedBox(height: 30.px),
                Align(
                  alignment: Alignment.center,
                  child: FlutterDemoElevatedButton(
                    buttonHeight: 48.px,
                    buttonRadius: 8.px,
                    buttonWidth: 230.px,
                    fontSize: 14.px,
                    buttonColor: FlutterDemoColorConstant.appPrimaryColor,
                    buttonName: S.of(context).proceed,
                    padding: EdgeInsets.symmetric(horizontal: 24.px),
                    onPressed: () => signUpPageController.validateOtp(context,loginArguments.verificationCode),
                  ),
                ),
                SizedBox(height: 26.px),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                          fontFamily: FlutterDemoAssets.defaultFont,
                          color: FlutterDemoColorConstant.appBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.px,
                        ),
                        children: [
                          TextSpan(text: S.of(context).resendCode),
                           signUpPageController.isToResendCode.value?
                           TextSpan(
                             text: '   resend-code',
                               style: TextStyle(
                                   color: FlutterDemoColorConstant
                                       .appPrimaryColor),
                               recognizer: TapGestureRecognizer()..onTap = () {
                                 signUpPageController.resendCode();
                               }
                           ):
                           TextSpan(
                              text:signUpPageController.counter.value > 9 ? ' 00:${signUpPageController.counter.value}':' 00:0${signUpPageController.counter.value}',
                              style: const TextStyle(
                                  color: FlutterDemoColorConstant
                                      .appPrimaryColor)),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class OtpRoute extends StatefulWidget {
//    OtpRoute({Key? key, required this.loginArguments}) : super(key: key);
//
//   final LoginArguments loginArguments;
//
//   @override
//   State<OtpRoute> createState() => _OtpRouteState();
// }
//
// class _OtpRouteState extends State<OtpRoute> {
//   TextEditingController textEditingController = TextEditingController();
//   String currentText = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 8.0),
//               child: Text(
//                 'Phone Number Verification',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Padding(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
//               child: RichText(
//                 text: const TextSpan(
//                     text: "Enter the code sent to ",
//                     children: [
//                       TextSpan(
//                           // text: "${widget.phoneNumber}",
//                         text: "8949704799",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15)),
//                     ],
//                     style:
//                     TextStyle(color: Colors.black54, fontSize: 15)),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             getPinCodeField()
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget getPinCodeField() {
//     return Column(
//       children: [
//         const SizedBox(
//           height: 20,
//         ),
//         Padding(
//             padding: const EdgeInsets.symmetric(
//                 vertical: 8.0, horizontal: 30),
//             child: PinCodeTextField(
//               appContext: context,
//               pastedTextStyle: TextStyle(
//                 color: Colors.green.shade600,
//                 fontWeight: FontWeight.bold,
//               ),
//               length: 6,
//               blinkWhenObscuring: true,
//               animationType: AnimationType.fade,
//               validator: (v) {
//                 if (v!.length < 6) {
//                   return "Please fill otp";
//                 } else {
//                   return null;
//                 }
//               },
//               pinTheme: PinTheme(
//                 activeColor: Colors.black,
//                 selectedColor: Colors.black,
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(5),
//                 fieldHeight: 50,
//                 fieldWidth: 40,
//                 activeFillColor: Colors.green,
//                 selectedFillColor: Colors.blue,
//                 inactiveFillColor: Colors.green
//               ),
//               cursorColor: Colors.black,
//               controller: textEditingController,
//               keyboardType: TextInputType.number,
//               boxShadows: const [
//                 BoxShadow(
//                   offset: Offset(0, 1),
//                   color: Colors.white,
//                   blurRadius: 10,
//                 )
//               ],
//               onCompleted: (v) {
//                 // Navigator.of(context).pushNamed(AppRoutes.homeScreen);
//                 verifyOtp(context);
//               },
//               // onTap: () {
//               //   print("Pressed");
//               // },
//               onChanged: (value) {
//                 debugPrint(value);
//                 setState(() {
//                   currentText = value;
//                 });
//               },
//               beforeTextPaste: (text) {
//                 debugPrint("Allowing to paste $text");
//                 //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//                 //but you can show anything you want here, like your pop up saying wrong paste format or etc
//                 return true;
//               },
//             )),
//       ],
//     );
//   }
//
//   verifyOtp(BuildContext context) async {
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
