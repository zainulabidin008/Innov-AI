import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_gradient.dart';
import '../../constants/app_strings.dart';
import '../../services/login_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../welcome/welcome_screen.dart';
import 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Image.asset(
            AppAssets.login_img,
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
          Scaffold(
            backgroundColor: AppColors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70.h),
                  Image.asset(
                    AppAssets.app_logo,
                    height: 75.h,
                    width: 75.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 5.h),
                  AppText(
                    AppStrings.ai_hub,
                    color: AppColors.white,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 100.h),
                  appButton(
                    onTap: () async {
                      loginController.loading.value = true;

                      bool loggedIn = await LoginServie.facebooklogin();
                      loggedIn
                          ? Get.offAll(() => const WelcomeScreen())
                          : Container();

                      loginController.loading.value = false;
                    },
                    height: 45.h,
                    width: double.maxFinite,
                    borderWidth: 1.w,
                    borderColor: AppColors.white,
                    borderRadius: BorderRadius.circular(5.r),
                    gradient: AppGradient.bgGradient,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: [
                          Image.asset(
                            AppAssets.facebook_ic,
                            height: 25.h,
                            width: 25.w,
                          ),
                          SizedBox(width: 10.w),
                          AppText(
                            AppStrings.sign_up_fb,
                            color: AppColors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 22.sp,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  appButton(
                    onTap: () async {
                      loginController.loading.value = true;

                      bool loggedIn = await LoginServie.googleLogin();
                      loggedIn
                          ? Get.offAll(() => const WelcomeScreen())
                          : Container();

                      loginController.loading.value = false;
                    },
                    height: 45.h,
                    width: double.maxFinite,
                    borderWidth: 1.w,
                    borderColor: AppColors.white,
                    borderRadius: BorderRadius.circular(5.r),
                    gradient: AppGradient.bgGradient,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        children: [
                          Image.asset(
                            AppAssets.google_ic,
                            height: 25.h,
                            width: 25.w,
                          ),
                          SizedBox(width: 10.w),
                          AppText(
                            AppStrings.sign_up_google,
                            color: AppColors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 22.sp,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          loginController.loading.value
              ? Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      color: AppColors.black.withOpacity(0.2),
                      child: const CupertinoActivityIndicator(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
