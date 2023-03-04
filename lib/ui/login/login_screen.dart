import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/ui/login/login_arguments.dart';
import 'package:newversity/utils/validaters.dart';

import '../../di/di_initializer.dart';
import '../../firestore/data/firestore_repository.dart';
import '../../firestore/model/user.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "NewVersity",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "A Platform build for new way of learning",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Your mobile number",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: PhoneNumberValidator(isOptional: false),
              onChanged: (value) {
                _phoneNumber = value;
                if(_phoneNumber.length == 10){
                  setState(() {
                    _phoneNumberValid = true;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: "Please enter your mobile number",
                hintStyle: TextStyle(fontSize: 12),
                isDense: true,
                errorText: getErrorText(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                // disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
                // focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.redAccent)),
                // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.redAccent)),
                // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: GestureDetector(
                onTap: () async {
                  onButtonTap();
                },
                child: Container(
                  height: 42,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  onButtonTap() {
    if(isPhoneNumberValid()) {
      fetchOtp();
    }
  }

  addCollection() async {
    await DI.inject<FireStoreRepository>().addUserToFireStore(UserData(userId: "IGiEzbtcMiWlbJ4s2yj7UaqsSTi2", name: "naman", phoneNumber: "", profileUrl: ""));
  }

  fetchOtp() async {
    _fetchingOtp = true;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + _phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {

      },
      verificationFailed: (FirebaseAuthException e) {

      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.of(context).pushNamed(AppRoutes.otpRoute, arguments: LoginArguments(verificationCode: verificationId, mobileNumber: _phoneNumber));
      },
      codeAutoRetrievalTimeout: (String verificationId) {

      },
    );
  }

  bool isPhoneNumberValid() {
    return _phoneNumber.length == 10;
  }

  String? getErrorText() {
    if(_phoneNumberValid == null || _phoneNumberValid == true) {
      return null;
    }

    return "Invalid phone number";
  }
}
