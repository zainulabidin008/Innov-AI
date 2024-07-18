// ignore_for_file: must_be_immutable, avoid_print

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
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
import '../upgrade/upgrade_screen.dart';
import 'image_controller.dart';

class FullScreenImage extends StatefulWidget {
  String prompt;
  String style;

  FullScreenImage({
    super.key,
    required this.prompt,
    required this.style,
  });

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  ImageController imageController = Get.put(ImageController());

  @override
  void dispose() {
    imageController.promptController.clear();
    imageController.images.clear();

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
                imageController.subList.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: appButton(
                          onTap: () {
                            Get.to(() => UpgradeScreen(
                                  subscriptionList: imageController.subList,
                                ))?.then((value) {
                              imageController.checkPurchase(load: false);
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
            body: Column(
              children: [
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Get.theme.primaryColor.withOpacity(0.1)
                          : AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Column(
                      children: [
                        AppText(
                          AppStrings.generate_hypothetical,
                          color: Get.isDarkMode
                              ? Get.theme.primaryColor
                              : AppColors.detailsColor,
                          textAlign: TextAlign.left,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            AppText(
                              AppStrings.style,
                              color: Get.isDarkMode
                                  ? Get.theme.primaryColor
                                  : AppColors.styleColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(width: 10.w),
                            AppText(
                              widget.style,
                              color: AppColors.greenn,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: imageController
                        .images[imageController.sel_image.value]['url'],
                    progressIndicatorBuilder: (context, url, progress) =>
                        const CupertinoActivityIndicator(
                      color: AppColors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 55.h,
                  alignment: Alignment.center,
                  child: ListView.separated(
                    itemCount: imageController.images.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 5.w),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          imageController.sel_image.value = index;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: imageController.sel_image.value == index
                                ? Border.all(
                                    width: 1.w,
                                    color: AppColors.greenn,
                                  )
                                : const Border(),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: CachedNetworkImage(
                              imageUrl: imageController.images[index]['url'],
                              height: 50.h,
                              width: 55.w,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, progress) =>
                                      const CupertinoActivityIndicator(
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: appButton(
                          onTap: () async {
                            await imageController.downloadImage();
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
                            await Share.share(
                              imageController
                                      .images[imageController.sel_image.value]
                                  ['url'],
                            );
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
                      imageController.promptController.text = widget.prompt;
                      await imageController.searchImage();
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
                SizedBox(height: 20.h),
              ],
            ),
          ),
          imageController.loading.value
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
