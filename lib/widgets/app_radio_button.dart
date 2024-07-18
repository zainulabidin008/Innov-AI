import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_gradient.dart';
import 'app_text.dart';

Widget appRadioButton({
  required Function() onTap,
  required String benefit,
  required String price,
  bool isSelected = false,
  String? credit,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 47.h,
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 30.w),
      decoration: BoxDecoration(
        gradient: AppGradient.bgGradient,
        borderRadius: BorderRadius.circular(96.r),
        border: Border.all(
          width: 1.w,
          color:
              isSelected ? AppColors.white : AppColors.white.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                benefit,
                color: AppColors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
              ),
              Row(
                children: [
                  AppText(
                    price,
                    color: AppColors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  credit == null
                      ? Container()
                      : AppText(
                          credit,
                          color: AppColors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                ],
              ),
            ],
          ),
          Container(
            height: 20.h,
            width: 20.w,
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1.w,
                color: AppColors.white,
              ),
            ),
            child: isSelected
                ? Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    ),
  );
}
