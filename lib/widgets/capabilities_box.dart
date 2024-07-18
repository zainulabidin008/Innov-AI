import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import 'app_text.dart';

import 'package:badges/badges.dart' as badge;

Widget capabilitiesBox({
  required String icon,
  int size = 35,
  required String text,
  required String subText,
}) {
  return badge.Badge(
    position: badge.BadgePosition.topStart(top: -20.h),
    badgeStyle: badge.BadgeStyle(
      padding: EdgeInsets.all(2.r),
      elevation: 0,
      badgeColor: Get.theme.scaffoldBackgroundColor,
    ),
    badgeContent: Image.asset(
      icon,
      height: size.h,
      width: size.w,
    ),
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? Get.theme.primaryColor.withOpacity(0.2)
            : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          AppText(
            text,
            color: Get.theme.primaryColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 5.h),
          AppText(
            subText,
            color: Get.theme.primaryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    ),
  );
}
