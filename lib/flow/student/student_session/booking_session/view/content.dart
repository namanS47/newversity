import 'package:flutter/material.dart';

class SharedContentRoute extends StatelessWidget {
  const SharedContentRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
                child: Text(
              "Mentor has not shared any content",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
