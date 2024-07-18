import 'dart:io';

import 'package:AiHub/screens/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'constants/app_themes.dart';
import 'screens/splash/splash_screen.dart';
import 'services/theme_service.dart';

late GetStorage storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isIOS
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyCg1hx_oIO9VL5Oa9ys',
          appId: '1:660201050058:ios:9884b11262a8a5c75b4933',
          messagingSenderId: '660201050058',
          projectId: 'aihub-3f66a',
        ))
      : await Firebase.initializeApp();
  await GetStorage.init();
  await MobileAds.instance.initialize();

  storage = GetStorage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Innov AI',
              themeMode: ThemeService.getThemeMode(),
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              home: const SplashScreen(),
              // home: const HomeScreen(),
            ),
          );
        });
  }
}
