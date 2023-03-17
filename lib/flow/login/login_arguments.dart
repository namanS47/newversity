import 'package:newversity/utils/enums.dart';

class LoginArguments{
  LoginArguments({required this.verificationCode, required this.mobileNumber, required this.userType, this.resendToken});
  String verificationCode;
  String mobileNumber;
  int? resendToken;
  UserType userType;
}