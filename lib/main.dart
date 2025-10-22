import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_router.dart';
import 'package:bluedock/core/config/theme/app_theme.dart';
import 'package:bluedock/features/notifications/presentation/pages/manage_notification.dart';
import 'package:bluedock/features/splash/bloc/splash_cubit.dart';
import 'package:bluedock/firebase_options.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  await _requestPermission();
  _setupFCMListener();
  _checkInitialMessage();
  runApp(const MyApp());
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> _requestPermission() async {
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission();

  String text;
  switch (settings.authorizationStatus) {
    case AuthorizationStatus.authorized:
      text = 'Notifikasi diizinkan ✅';
      break;
    case AuthorizationStatus.provisional:
      text = 'Notifikasi diizinkan sementara (provisional) ⚠️';
      break;
    case AuthorizationStatus.denied:
      text = 'Izin notifikasi ditolak ❌';
      break;
    default:
      text = 'Status izin tidak diketahui';
  }
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(content: Text(text)),
  );
}

void _checkInitialMessage() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance
      .getInitialMessage();
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
}

void _setupFCMListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      _showForegroundDialog(
        message.notification!.title,
        message.notification!.body,
      );
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleMessage(message);
  });
}

void _handleMessage(RemoteMessage message) {
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (context) {
        return ManageNotificationPage();
      },
    ),
  );
}

void _showForegroundDialog(String? title, String? body) {
  showDialog(
    context: navigatorKey.currentState!.overlay!.context,
    builder: (context) {
      return AlertDialog(
        title: TextWidget(text: title ?? 'No title'),
        content: TextWidget(text: body ?? 'No body'),
        actions: [
          TextButton(
            onPressed: () {
              return context.pop();
            },
            child: TextWidget(text: 'Ok'),
          ),
        ],
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
