// ignore_for_file: deprecated_member_use, use_build_context_synchronously, must_be_immutable

import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_gradient.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_video_player.dart';
import 'full_video_screen.dart';
import 'uograde_video_screen.dart';
import 'use_policy_screen.dart';
import 'video_controller.dart';

class AIVideoScreen extends StatefulWidget {
  bool purchase;

  AIVideoScreen({
    super.key,
    this.purchase = true,
  });

  @override
  State<AIVideoScreen> createState() => _AIVideoScreenState();
}

class _AIVideoScreenState extends State<AIVideoScreen> {
  VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 400)).then((value) {
      if (!widget.purchase) {
        Get.to(() => const UpgradeVideoScreen());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction < 1.0) {
          videoController.imageFile = null;
          videoController.promptController.clear();
          setState(() {});
        }
      },
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                elevation: 0.4,
                leadingWidth: 0,
                leading: Container(),
                centerTitle: false,
                title: AppText(
                  AppStrings.ai_video,
                  color: Get.theme.primaryColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
                actions: [
                  videoController.videoMin.value != '00:00'
                      ? Center(
                          child: AppText(
                            AppStrings.minutes +
                                videoController.videoMin.value.toString(),
                            color: Get.theme.primaryColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: appButton(
                            onTap: () {
                              Get.to(() => const UpgradeVideoScreen());
                            },
                            height: 46.h,
                            width: 160.w,
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
                        ),
                  SizedBox(width: 16.w),
                ],
              ),
              body: Column(
                children: [
                  SizedBox(height: 15.h),
                  Expanded(
                    child: AppVideoPlayer(locale: true),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            var prompt = videoController.promptController.text;

                            Get.to(() => const UsePolicyScreen())
                                ?.then((value) {
                              setState(() {});
                              videoController.promptController.text = prompt;
                            });
                          },
                          child: Container(
                            height: 100.h,
                            width: 110.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Get.isDarkMode
                                  ? Get.theme.primaryColor.withOpacity(0.1)
                                  : AppColors.lightGrey,
                            ),
                            child: videoController.imageFile == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppAssets.gallery_ic,
                                        height: 25.h,
                                        width: 25.w,
                                        color: Get.isDarkMode
                                            ? Get.theme.primaryColor
                                            : AppColors.grey,
                                      ),
                                      SizedBox(height: 10.h),
                                      AppText(
                                        AppStrings.image,
                                        color: Get.isDarkMode
                                            ? Get.theme.primaryColor
                                            : AppColors.grey,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.file(
                                      File(videoController.imageFile!.path),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Container(
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Get.isDarkMode
                                  ? Get.theme.primaryColor.withOpacity(0.1)
                                  : AppColors.lightGrey,
                            ),
                            child: TextFormField(
                              controller: videoController.promptController,
                              cursorColor: Get.isDarkMode
                                  ? Get.theme.primaryColor
                                  : AppColors.grey,
                              maxLines: null,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Get.isDarkMode
                                      ? Get.theme.primaryColor
                                      : AppColors.grey,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.h, horizontal: 10.w),
                                hintText: AppStrings.enter_script,
                                hintStyle: GoogleFonts.poppins(
                                  color: Get.isDarkMode
                                      ? Get.theme.primaryColor
                                      : AppColors.grey,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: appButton(
                      onTap: () async {
                        if (videoController.promptController.text
                            .trim()
                            .isEmpty) {
                          AppSnackbar(
                            error: true,
                            content: 'Please enter text!!',
                          );
                        } else if (videoController
                                .promptController.text.length >
                            250) {
                          AppSnackbar(
                            error: true,
                            content: 'Given prompt is too long!!',
                          );
                        } else if (videoController.imageFile == null) {
                          AppSnackbar(
                            error: true,
                            content: 'Please add image!!',
                          );
                        } else {
                          FocusManager.instance.primaryFocus?.unfocus();
                          await videoController.uploadImage();

                          videoController.videoUrl == null
                              ? Container()
                              : Get.to(() => FullVideoScreen(
                                    prompt:
                                        videoController.promptController.text,
                                    imageFile: videoController.imageFile,
                                  ))?.then((value) {
                                  setState(() {});
                                });
                        }
                      },
                      height: 45.h,
                      width: double.maxFinite,
                      borderRadius: BorderRadius.circular(5.r),
                      buttonColor: AppColors.greenn,
                      textColor: AppColors.white,
                      buttonText: AppStrings.generate,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
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
      ),
    );
  }
}
