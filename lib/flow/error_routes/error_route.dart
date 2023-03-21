import 'package:flutter/material.dart';

class SomethingWentWrongRoute extends StatelessWidget {
  const SomethingWentWrongRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Something went wrong"),
      ),
    );
  }
}
