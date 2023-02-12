import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:newversity/utils/new_versity_color_constant.dart';

import '../di/di_initializer.dart';
import '../firestore/data/firestore_repository.dart';
import '../firestore/model/user.dart';
import '../generated/l10n.dart';
import '../utils/new_versity_validation_utils.dart';

class SignUpController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  RxList<String> fieldOfInterest = <String>['IIT-JEE', 'NEET'].obs;

  RxInt selectedField = 0.obs;
  RxString selectedFieldName = ''.obs;
  RxString nameError = ''.obs;
  RxString emailError = ''.obs;
  RxString classError = ''.obs;
  RxString filedOfInterestError = ''.obs;

  void updateSelectedFieldOfInterest(int index) {
    selectedField = index.obs;
    update();
  }

  void validateSignUpForm(BuildContext context, User? user) {
    if (ValidationUtils.validateEmptyController(nameController)) {
      nameError = S
          .of(context)
          .enterName
          .obs;
    } else if (!ValidationUtils.regexValidator(
        nameController, ValidationUtils.nameRegExp)) {
      nameError = S
          .of(context)
          .invalidName
          .obs;
    } else {
      nameError = ''.obs;
    }

    if (ValidationUtils.validateEmptyController(emailController)) {
      emailError = S
          .of(context)
          .enterEmail
          .obs;
    } else if (!ValidationUtils.regexValidator(
        emailController, ValidationUtils.emailRegExp)) {
      emailError = S
          .of(context)
          .invalidEmail
          .obs;
    } else {
      emailError = ''.obs;
    }

    if (ValidationUtils.validateEmptyController(classController)) {
      classError = S
          .of(context)
          .enterClass
          .obs;
    } else if (!ValidationUtils.regexValidator(
        classController, ValidationUtils.classRegExpression)) {
      classError = S
          .of(context)
          .invalidClass
          .obs;
    } else {
      classError = ''.obs;
    }
    update();
    if (nameError.value.isEmpty && emailError.value.isEmpty &&
        classError.value.isEmpty && filedOfInterestError.value.isEmpty) {
      registerUser(user);
    }
  }

  Future<void> registerUser(User? user) async {
    User? user;
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      user = auth.currentUser;
      await DI.inject<FireStoreRepository>().addUserToFireStore(UserData(userId: user!.uid, name: nameController.text.trim(), phoneNumber: user.phoneNumber.toString() ));
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Registration Error", e.message.toString(),
          colorText: FlutterDemoColorConstant.appRed);
    }
  }
}