// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../services/image_service.dart';
import 'app_text.dart';

/// SHOW DIALOG BOX - Gallery/Camera
showChoiceDialog(BuildContext context) async {
  var pickedFile;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:
            Get.isDarkMode ? Get.theme.primaryColor : AppColors.white,
        title: AppText(
          'Choose option',
          textAlign: TextAlign.left,
          color: AppColors.black,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(
                height: 1.h,
                color: AppColors.black,
              ),
              ListTile(
                onTap: () async {
                  pickedFile = await ImageService.openGallery();
                },
                title: AppText(
                  "Gallery",
                  textAlign: TextAlign.left,
                  color: AppColors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
                leading: const Icon(
                  Icons.account_box,
                  color: AppColors.black,
                ),
              ),
              Divider(
                height: 1.h,
                color: AppColors.black,
              ),
              ListTile(
                onTap: () async {
                  pickedFile = await ImageService.openCamera();
                },
                title: AppText(
                  "Camera",
                  textAlign: TextAlign.left,
                  color: AppColors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
                leading: const Icon(
                  Icons.camera,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return pickedFile;
}
