class LoginArguments{
  LoginArguments({required this.verificationCode, required this.mobileNumber, this.resendToken});
  String verificationCode;
  String mobileNumber;
  int? resendToken;
}