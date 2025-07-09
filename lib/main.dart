import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intrezo/views/splash_view.dart';
import 'package:provider/provider.dart';

import 'controllers/contact_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/saved_jobs_controller.dart';
import 'controllers/splash_controller.dart';
import 'controllers/invite_controller.dart';
import 'controllers/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SplashController>(
            create: (_) => SplashController(),
          ),
          ChangeNotifierProvider<HomeController>(
            create: (_) => HomeController(),
          ),
          ChangeNotifierProvider<SavedJobsController>(
            create: (_) => SavedJobsController(),
          ),
          ChangeNotifierProvider<ContactController>(
            create: (_) => ContactController(),
          ),
          ChangeNotifierProvider(create: (_) => InviteController()),
          ChangeNotifierProvider(create: (_) => SettingsController()),
        ],
        child: const MyApp(),
      )

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intrezo',
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
    );
  }
}
