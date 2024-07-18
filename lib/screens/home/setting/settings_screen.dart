// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:AiHub/widgets/app_dialog_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_gradient.dart';
import '../../../constants/app_strings.dart';
import '../../../services/theme_service.dart';
import '../../../widgets/app_text.dart';
import '../upgrade/upgrade_screen.dart';
import 'about_us_screen.dart';
import 'history_screen.dart';
import 'privacy_policy_screen.dart';
import 'setting_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingController seetingController = Get.put(SettingController());

  @override
  void initState() {
    seetingController.purchaseUpdate();
    seetingController.checkPurchase();

    super.initState();
  }

  @override
  void dispose() {
    seetingController.subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0.4,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.keyboard_arrow_left_rounded,
                  size: 32.sp,
                  color: Get.theme.primaryColor.withOpacity(0.8),
                ),
              ),
              title: AppText(
                AppStrings.settings,
                color: Get.theme.primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      seetingController.subList.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                Get.to(() => UpgradeScreen(
                                      subscriptionList:
                                          seetingController.subList,
                                    ))?.then((value) {});
                              },
                              child: Container(
                                width: double.maxFinite,
                                padding: REdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  gradient: AppGradient
                                      .reverseHorizontalPurpleGradient,
                                  image: DecorationImage(
                                    alignment: Alignment.centerRight,
                                    image: AssetImage(
                                      AppAssets.upgrade_img,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      AppStrings.upgrade_to_premium,
                                      color: AppColors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    SizedBox(height: 5.h),
                                    Container(
                                      width: 200.w,
                                      alignment: Alignment.centerLeft,
                                      child: AppText(
                                        AppStrings.enjoy_all,
                                        color: AppColors.white,
                                        textAlign: TextAlign.left,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Container(
                                      height: 30.h,
                                      width: 30.w,
                                      decoration: const BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        size: 30.sp,
                                        color: AppColors.greenn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.to(() => const HistoryScreen());
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              AppAssets.history_ic,
                              height: 15.h,
                              width: 15.w,
                              color: Get.theme.primaryColor,
                            ),
                            SizedBox(width: 20.w),
                            AppText(
                              AppStrings.history,
                              color: Get.theme.primaryColor,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  size: 30.sp,
                                  color:
                                      Get.theme.primaryColor.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () async {
                          appDialogBox(
                            title: 'Restore Purchase',
                            content:
                                'Are you sure you want to restore your purchase?',
                            confirmText: 'Confirm',
                            confirm: () async {
                              Get.back();
                              seetingController.loading.value = true;
                              await seetingController.inAppPurchase
                                  .restorePurchases(applicationUserName: null);
                              seetingController.loading.value = false;
                            },
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.cart_ic,
                              height: 15.h,
                              width: 15.w,
                              color: Get.theme.primaryColor,
                            ),
                            SizedBox(width: 20.w),
                            AppText(
                              AppStrings.restore_purchase,
                              color: Get.theme.primaryColor,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  size: 30.sp,
                                  color:
                                      Get.theme.primaryColor.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.to(() => const PrivacyPolicyScreen());
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.privacy_ic,
                              height: 15.h,
                              width: 15.w,
                              color: Get.theme.primaryColor,
                            ),
                            SizedBox(width: 20.w),
                            AppText(
                              AppStrings.privacy_policy,
                              color: Get.theme.primaryColor,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  size: 30.sp,
                                  color:
                                      Get.theme.primaryColor.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.to(() => const AboutUsScreen());
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.about_ic,
                              height: 15.h,
                              width: 15.w,
                              color: Get.theme.primaryColor,
                            ),
                            SizedBox(width: 20.w),
                            AppText(
                              AppStrings.about_us,
                              color: Get.theme.primaryColor,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  size: 30.sp,
                                  color:
                                      Get.theme.primaryColor.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.eye_ic,
                        height: 15.h,
                        width: 15.w,
                        color: Get.theme.primaryColor,
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: AppText(
                          AppStrings.dark_mode,
                          color: Get.theme.primaryColor,
                          textAlign: TextAlign.left,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      FlutterSwitch(
                        value: seetingController.darkMode,
                        height: 30.h,
                        width: 70.w,
                        borderRadius: 50.r,
                        activeColor: AppColors.greenn,
                        inactiveColor: AppColors.indicator,
                        toggleColor: AppColors.white,
                        onToggle: (value) async {
                          await ThemeService.changeThemeMode();
                          await Future.delayed(
                              const Duration(milliseconds: 200));
                          seetingController.darkMode =
                              !seetingController.darkMode;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: 87.h,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 0.2.w,
                    color: AppColors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          seetingController.loading.value
              ? Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      color: Get.theme.primaryColor.withOpacity(0.2),
                      child: CupertinoActivityIndicator(
                        color: Get.theme.scaffoldBackgroundColor,
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
