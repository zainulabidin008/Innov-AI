import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_gradient.dart';
import 'app_text.dart';

Widget featuresRow({
  required String text,
}) {
  return Row(
    children: [
      Container(
        height: 10.h,
        width: 10.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradient.purpleGradient,
        ),
      ),
      SizedBox(width: 10.w),
      AppText(
        text,
        color: AppColors.white,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
    ],
  );
}
