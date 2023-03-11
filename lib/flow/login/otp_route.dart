import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/firestore/data/firestore_repository.dart';
import 'package:newversity/firestore/model/user.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/resources/images.dart';
import 'package:newversity/themes/colors.dart';
import 'package:newversity/themes/strings.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'login_arguments.dart';

class OtpRoute extends StatefulWidget {
  const OtpRoute({Key? key, required this.loginArguments}) : super(key: key);

  final LoginArguments loginArguments;

  @override
  State<OtpRoute> createState() => _OtpRouteState();
}

class _OtpRouteState extends State<OtpRoute> {
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppStrings.verifyOtp,
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 27,
                    color: AppColors.blackRussian),
                textAlign: TextAlign.center,
              ),
            ),
            // Padding(
            //   padding:
            //   const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            //   child: RichText(
            //     text: TextSpan(
            //         text: AppStrings.enterOtp,
            //         children: [
            //           TextSpan(
            //               text: " +91 ${widget.loginArguments.mobileNumber}",
            //               style: const TextStyle(
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 15)),
            //         ],
            //         style:
            //         const TextStyle(color: Colors.black54, fontSize: 15)),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child:Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    AppStrings.enterOtp,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.blackMerlin
                    ),
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
                              fontSize: 12,
                              color: AppColors.blackMerlin
                          ),
                        ),
                        const SizedBox(width: 4,),
                        SvgPicture.asset(ImageAsset.editIcon)
                      ],
                    ),
                  )
                ],
              ),
            ),
            getPinCodeField()
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
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 30),
            child: PinCodeTextField(
              appContext: context,
              pastedTextStyle: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
              ),
              length: 6,
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              validator: (v) {
                if (v!.length < 6) {
                  return "Please fill otp";
                } else {
                  return null;
                }
              },
              pinTheme: PinTheme(
                  activeColor: Colors.black,
                  selectedColor: Colors.black,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.green,
                  selectedFillColor: Colors.blue,
                  inactiveFillColor: Colors.green
              ),
              cursorColor: Colors.black,
              controller: textEditingController,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.white,
                  blurRadius: 10,
                )
              ],
              onCompleted: (v) {
                // Navigator.of(context).pushNamed(AppRoutes.homeScreen);
                verifyOtp(context);
              },
              // onTap: () {
              //   print("Pressed");
              // },
              onChanged: (value) {
                debugPrint(value);
                setState(() {
                  currentText = value;
                });
              },
              beforeTextPaste: (text) {
                debugPrint("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            )),
      ],
    );
  }

  verifyOtp(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.loginArguments.verificationCode,
        smsCode: currentText);
    try {
      final result = await auth.signInWithCredential(credential);
      await DI.inject<FireStoreRepository>().addUserToFireStore(UserData(
          userId: result.user?.uid ?? "",
          name: "naman",
          phoneNumber: widget.loginArguments.mobileNumber));
      Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.homeScreen, (route) => false);
    } catch (e) {
      print("Please enter corrent otp");
    }
  }
}
