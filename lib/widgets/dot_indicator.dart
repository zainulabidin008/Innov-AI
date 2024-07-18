// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget DotIndicator({
  required Color activeColor,
  required Color inActivecolor,
  bool isActive = false,
  double? gap,
}) {
  return Padding(
    padding: EdgeInsets.only(right: gap ?? 5.w),
    child: Container(
      height: 8.h,
      width: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? activeColor : inActivecolor,
      ),
    ),
  );
}
