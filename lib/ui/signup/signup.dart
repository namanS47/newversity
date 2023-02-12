import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newversity/controllers/signup_controller.dart';
import 'package:newversity/ui/signup/signup_view.dart';

class SignupPage extends StatelessWidget {
  User? user;
   SignupPage({Key? key,this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
        builder: (SignUpController signUpController) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: RegistrationFormView(),
      );
    });
  }
}
