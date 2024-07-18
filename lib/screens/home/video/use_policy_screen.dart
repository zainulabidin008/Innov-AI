import 'package:AiHub/widgets/app_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../services/image_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import 'video_controller.dart';

import 'package:badges/badges.dart' as badge;

class UsePolicyScreen extends StatefulWidget {
  const UsePolicyScreen({super.key});

  @override
  State<UsePolicyScreen> createState() => _UsePolicyScreenState();
}

class _UsePolicyScreenState extends State<UsePolicyScreen> {
  VideoController videoController = Get.put(VideoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        centerTitle: true,
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
        title: AppText(
          AppStrings.sel_your,
          color: Get.theme.primaryColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        videoController.exampleList.length,
                        (index) => badge.Badge(
                          position:
                              badge.BadgePosition.topEnd(top: -5.h, end: -3.w),
                          badgeStyle: badge.BadgeStyle(
                            padding: EdgeInsets.all(2.r),
                            elevation: 0,
                            badgeColor:
                                index.isEven ? AppColors.green : AppColors.red,
                          ),
                          badgeContent: Icon(
                            index.isEven ? Icons.check : Icons.close,
                            size: 12.sp,
                            color: AppColors.white,
                          ),
                          child: Container(
                            height: 80.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.w,
                                color: index.isEven
                                    ? AppColors.green
                                    : AppColors.red,
                              ),
                            ),
                            child: Image.asset(
                              videoController.exampleList[index],
                              height: 80.h,
                              width: 70.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          AppStrings.recommended,
                          color: Get.theme.primaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          size: 26.sp,
                          color: AppColors.green,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Get.theme.primaryColor.withOpacity(0.1)
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: AppText(
                        AppStrings.recommended_desc,
                        color: Get.isDarkMode
                            ? Get.theme.primaryColor
                            : AppColors.detailsColor,
                        textAlign: TextAlign.left,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          AppStrings.dont_use,
                          color: Get.theme.primaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        Icon(
                          CupertinoIcons.clear_circled_solid,
                          size: 26.sp,
                          color: AppColors.red,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Get.theme.primaryColor.withOpacity(0.1)
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: AppText(
                        AppStrings.dont_use_desc,
                        color: Get.isDarkMode
                            ? Get.theme.primaryColor
                            : AppColors.detailsColor,
                        textAlign: TextAlign.left,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          AppStrings.attention,
                          color: Get.theme.primaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        Icon(
                          CupertinoIcons.exclamationmark_circle_fill,
                          size: 24.sp,
                          color: AppColors.amber,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Get.theme.primaryColor.withOpacity(0.1)
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: AppText(
                        AppStrings.attention_desc,
                        color: Get.isDarkMode
                            ? Get.theme.primaryColor
                            : AppColors.detailsColor,
                        textAlign: TextAlign.left,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppAssets.sheild_ic,
                          height: 25.h,
                          width: 25.w,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: AppStrings.your_photo,
                              style: GoogleFonts.poppins(
                                color: AppColors.grey,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: AppStrings.immediately_deleted,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.greenn,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: AppStrings.from_servers,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.grey,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
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
                    padding: EdgeInsets.symmetric(horizontal: 71.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => InkWell(
                            onTap: () {
                              videoController.agree.toggle();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Container(
                                height: 15.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: videoController.agree.value
                                      ? AppColors.greenn
                                      : AppColors.transparent,
                                  border: videoController.agree.value
                                      ? const Border()
                                      : Border.all(
                                          width: 1.w, color: AppColors.grey),
                                ),
                                child: videoController.agree.value
                                    ? Icon(
                                        Icons.check,
                                        size: 10.sp,
                                        color: AppColors.white,
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: AppText(
                            AppStrings.agree_policy,
                            color: AppColors.grey,
                            textAlign: TextAlign.center,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
            child: appButton(
              onTap: () async {
                if (videoController.agree.value) {
                  var pickedImage = await ImageService.pickImage();
                  if (pickedImage != null) {
                    videoController.imageFile = pickedImage;
                    Get.back();
                  }
                } else {
                  AppSnackbar(
                    error: true,
                    content: 'Please agree terms of use',
                  );
                }
              },
              height: 45.h,
              width: double.maxFinite,
              borderRadius: BorderRadius.circular(5.r),
              buttonColor: AppColors.greenn,
              textColor: AppColors.white,
              buttonText: AppStrings.sel_photo,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
