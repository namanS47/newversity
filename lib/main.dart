import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newversity/firebase_options.dart';
import 'package:newversity/navigation/app_router.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/themes/app_theme.dart';

import 'di/di_initializer.dart';
import 'flow/login/presentation/login_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DI.initializeDependencies();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      initialRoute: AppRoutes.profileScreen,
    );
  }
}
