import 'package:AiHub/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_constant.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_text.dart';
import '../home/home_screen.dart';
import '../intro/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();

    super.initState();
  }

  init() {
    var uid = storage.read(AppConst.uid);

    Future.delayed(const Duration(seconds: 2), () {
      if (uid != null) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => const IntroScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Image.asset(
            AppAssets.splash_img,
            height: double.maxFinite,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
          Image.asset(
            AppAssets.cover_bg,
            height: double.maxFinite,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 75.h,
                width: 75.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AppAssets.app_logo,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              AppText(
                AppStrings.ai_hub,
                color: AppColors.white,
                fontSize: 70.sp,
                fontWeight: FontWeight.w600,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AppText(
                  AppStrings.unleash,
                  color: AppColors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 150.h),
            ],
          ),
        ],
      ),
    );
  }
}
