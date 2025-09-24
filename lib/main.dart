import 'package:bluedock/core/config/navigation/app_router.dart';
import 'package:bluedock/core/config/theme/app_theme.dart';
import 'package:bluedock/features/splash/bloc/splash_cubit.dart';
import 'package:bluedock/firebase_options.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
