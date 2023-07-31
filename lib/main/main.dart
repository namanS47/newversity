import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/firebase_options.dart';
import 'package:newversity/navigation/app_router.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/services/service_locator.dart';
import 'package:newversity/themes/app_theme.dart';

import '../bloc_observer/app_bloc_observer.dart';
import '../di/di_initializer.dart';
import '../firebase/firebase_messaging.dart';
import '../flow/login/presentation/login_screen.dart';

defaultMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  DI.initializeDependencies();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firebaseMessagingService = FirebaseMessagingService();
  await firebaseMessagingService.initialize();
  setupLocator();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      onGenerateRoute: AppRouter().route,
      initialRoute: AppRoutes.initialRoute,
    );
  }
}
