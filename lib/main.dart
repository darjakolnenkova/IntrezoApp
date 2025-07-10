import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

// import 'services/notification_service.dart';
import 'views/splash_view.dart';
import 'controllers/splash_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/saved_jobs_controller.dart';
import 'controllers/contact_controller.dart';
import 'controllers/invite_controller.dart';
import 'controllers/settings_controller.dart';

/// Обработчик фоновых сообщений FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // здесь при необходимости обрабатываем фоновое сообщение
}

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // // Инициализируем локальные уведомления
  // await NotificationService.init();

  // Настраиваем FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final messaging = FirebaseMessaging.instance;
  // Подписываемся на топик 'jobs'
  await messaging.subscribeToTopic('jobs');

  // // Приём уведомлений в foreground
  // FirebaseMessaging.onMessage.listen((msg) {
  //   final notification = msg.notification;
  //   if (notification != null) {
  //     NotificationService.showNotification(
  //       id: notification.hashCode,
  //       title: notification.title!,
  //       body: notification.body!,
  //     );
  //   }
  // });

  // Запускаем приложение с провайдерами
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
        ChangeNotifierProvider<InviteController>(
          create: (_) => InviteController(),
        ),
        ChangeNotifierProvider<SettingsController>(
          create: (_) => SettingsController(),
        ),
      ],
      child: const MyApp(),
    ),
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
