import 'package:form_field_validator/form_field_validator.dart';

import '../themes/strings.dart';

class PhoneNumberValidator extends TextFieldValidator {

  bool isOptional = false;
  // pass the error text to the super constructor
  PhoneNumberValidator({String errorText = Strings.invalidMessagePhone, required this.isOptional}) : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => false;


  @override
  bool isValid(String? value) {
    print("naman");
    print(value);
    // return true if the value is valid according the your condition
    return (value != null && value.length == 10) || (isOptional && value?.isEmpty == true);
  }
}
