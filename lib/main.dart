import 'package:flutter/material.dart';
import 'package:newversity/navigation/app_router.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/ui/login/login_screen.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';

import 'di/di_initializer.dart';

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
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const LoginScreen(),
      onGenerateRoute: AppRouter().route,
      initialRoute: AppRoutes.loginRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Uri _url = Uri.parse('whatsapp://chat?code=KjmBB9x8ayzDSfPqYRe2NY');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _launchUrl();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
