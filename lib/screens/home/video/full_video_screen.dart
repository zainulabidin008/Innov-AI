// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_gradient.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_video_player.dart';
import '../upgrade/upgrade_screen.dart';
import 'video_controller.dart';

class FullVideoScreen extends StatefulWidget {
  String prompt;
  XFile? imageFile;

  FullVideoScreen({
    super.key,
    required this.prompt,
    required this.imageFile,
  });

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  VideoController videoController = Get.put(VideoController());

  @override
  void dispose() {
    videoController.promptController.clear();
    videoController.imageFile = null;

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
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.close,
                  size: 27.sp,
                  color: AppColors.greenn,
                ),
              ),
              actions: [
                videoController.subList.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: appButton(
                          onTap: () {
                            Get.to(() => UpgradeScreen(
                                  subscriptionList: videoController.subList,
                                ))?.then((value) {
                              videoController.checkPurchase(load: false);
                            });
                          },
                          height: 46.h,
                          width: 169.w,
                          gradient: AppGradient.purpleGradient,
                          borderRadius: BorderRadius.circular(10.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.diamond_ic,
                                height: 25.h,
                                width: 25.w,
                              ),
                              SizedBox(width: 10.w),
                              AppText(
                                AppStrings.upgrade,
                                color: AppColors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(width: 16.w),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                children: [
                  SizedBox(
                    height: 390.h,
                    child: AppVideoPlayer(
                      videoUrl: videoController.videoUrl,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: appButton(
                            onTap: () async {
                              videoController.videoDownload();
                            },
                            height: 45.h,
                            width: double.maxFinite,
                            borderRadius: BorderRadius.circular(5.r),
                            buttonColor: AppColors.greenn,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.download_ic,
                                  height: 27.h,
                                  width: 27.w,
                                ),
                                SizedBox(width: 10.w),
                                AppText(
                                  AppStrings.download,
                                  color: AppColors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: appButton(
                            onTap: () async {
                              await Share.share(videoController.videoUrl);
                            },
                            height: 45.h,
                            width: double.maxFinite,
                            borderRadius: BorderRadius.circular(5.r),
                            buttonColor: AppColors.greenn,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.share_ic,
                                  height: 27.h,
                                  width: 27.w,
                                ),
                                SizedBox(width: 10.w),
                                AppText(
                                  AppStrings.share,
                                  color: AppColors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: appButton(
                      onTap: () async {
                        videoController.promptController.text = widget.prompt;
                        videoController.imageFile = widget.imageFile;
                        await videoController.uploadImage();
                      },
                      height: 45.h,
                      width: double.maxFinite,
                      borderRadius: BorderRadius.circular(5.r),
                      buttonColor: AppColors.greenn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.video_ic,
                            height: 30.h,
                            width: 30.w,
                          ),
                          SizedBox(width: 10.w),
                          AppText(
                            AppStrings.generate_again,
                            color: AppColors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          videoController.loading.value
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
