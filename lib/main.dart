import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:newversity/navigation/app_router.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/routes/route_helper.dart';
import 'package:newversity/ui/login/login_screen.dart';
import 'package:newversity/utils/new_versity_color_constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';

import 'controllers/theme_controller.dart';
import 'di/di_initializer.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DI.initializeDependencies();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(// navigation bar color
    statusBarColor: FlutterDemoColorConstant.appStatusColor, // status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale? locale;
    return ResponsiveSizer(
      builder: (BuildContext context, Orientation orientation, screenType) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: GetMaterialApp(
            title: 'New Versity',
            navigatorKey: Get.key,
            debugShowCheckedModeBanner: false,
            initialRoute: RouteHelper.getLoginPage(),
            // RouteHelper.getSplashRoute(),
            getPages: RouteHelper.pages,
            defaultTransition: Transition.rightToLeft,
            scrollBehavior: MyBehavior(),
            // scrollBehavior: const MaterialScrollBehavior().copyWith(
            //   dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
            // ),
            theme: ThemeController.lightTheme,
            // transitionDuration: const Duration(milliseconds: 500),
            localizationsDelegates: const [
              S.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: locale,
          ),
        );
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

