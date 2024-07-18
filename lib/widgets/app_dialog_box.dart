import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import 'app_button.dart';
import 'app_text.dart';

appDialogBox({
  required String title,
  required String content,
  required String confirmText,
  required Function()? confirm,
  double? width,
  EdgeInsets? contentPadding,
}) {
  Get.defaultDialog(
    radius: 10.r,
    backgroundColor: Get.isDarkMode ? Get.theme.primaryColor : AppColors.white,
    contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 20.w),
    titlePadding: EdgeInsets.symmetric(vertical: 10.h),
    title: title,
    titleStyle: GoogleFonts.poppins(
      color: AppColors.black,
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
    ),
    content: Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: AppText(
        content,
        color: AppColors.black,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appButton(
              onTap: () {
                Get.back();
              },
              height: 33.h,
              width: width ?? 115.w,
              borderRadius: BorderRadius.circular(10.r),
              borderWidth: 1.w,
              borderColor: AppColors.black,
              buttonColor: AppColors.white,
              textColor: AppColors.black,
              buttonText: 'Cancel',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
            InkWell(
              onTap: confirm,
              child: Container(
                height: 33.h,
                width: width ?? 115.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.r,
                      color: AppColors.black.withOpacity(0.25),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: AppText(
                  confirmText,
                  color: AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
