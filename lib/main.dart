import 'package:flutter/material.dart';
import 'package:newversity/navigation/app_router.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';

import 'di/di_initializer.dart';
import 'flow/login/login_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DI.initializeDependencies();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      onGenerateRoute: AppRouter().route,
      initialRoute: AppRoutes.loginRoute,
    );
  }
}