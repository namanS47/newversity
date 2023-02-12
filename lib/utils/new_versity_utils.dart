import 'package:flutter/cupertino.dart';

closeKeyBoard({BuildContext? context}) {
  FocusScope.of(context!).requestFocus(FocusNode());
}