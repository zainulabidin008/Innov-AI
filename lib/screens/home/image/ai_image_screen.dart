// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_gradient.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/featured_list.dart';
import '../../../constants/style_list.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../widgets/app_text.dart';
import 'full_screen_image.dart';
import 'image_controller.dart';
import 'upgrade_image_screen.dart';

class AIImageScreen extends StatefulWidget {
  bool purchase;

  AIImageScreen({
    super.key,
    this.purchase = true,
  });

  @override
  State<AIImageScreen> createState() => _AIImageScreenState();
}

class _AIImageScreenState extends State<AIImageScreen> {
  ImageController imageController = Get.put(ImageController());

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 400)).then((value) {
      if (!widget.purchase) {
        Get.to(() => const UpgradeImageScreen());
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
          imageController.promptController.clear();
          imageController.sel_style.value = 0;
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
                  AppStrings.ai_image,
                  color: Get.theme.primaryColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
                actions: [
                  imageController.credit.value != 0
                      ? Center(
                          child: AppText(
                            AppStrings.credits +
                                imageController.credit.value.toString(),
                            color: Get.theme.primaryColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: appButton(
                            onTap: () async {
                              Get.to(() => const UpgradeImageScreen());
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Container(
                              height: 100.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: Get.isDarkMode
                                    ? Get.theme.primaryColor.withOpacity(0.1)
                                    : AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          AppStrings.enter_prompt,
                                          color: Get.theme.primaryColor,
                                          height: 0.5.h,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(
                                          height: 70.h,
                                          child: TextFormField(
                                            controller: imageController
                                                .promptController,
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
                                              contentPadding: EdgeInsets.zero,
                                              hintText: AppStrings.image_eg,
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
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    AppAssets.gallery_ic,
                                    height: 25.h,
                                    width: 25.w,
                                    fit: BoxFit.contain,
                                    color: Get.theme.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: AppText(
                              AppStrings.sel_style,
                              color: Get.theme.primaryColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          SizedBox(
                            height: 105.h,
                            child: ListView.separated(
                              itemCount: styleList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 15.w),
                              itemBuilder: (context, index) {
                                String image = styleList[index].image;
                                String name = styleList[index].name;

                                return Obx(
                                  () => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          imageController.sel_style.value =
                                              index;
                                        },
                                        child: Container(
                                          height: 78.h,
                                          width: 78.w,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 3.h),
                                          decoration: BoxDecoration(
                                            border: imageController
                                                        .sel_style.value ==
                                                    index
                                                ? Border.all(
                                                    width: 1.w,
                                                    color: AppColors.greenn,
                                                  )
                                                : const Border(),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  image,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Padding(
                                        padding:
                                            imageController.sel_style.value ==
                                                    index
                                                ? EdgeInsets.only(left: 5.w)
                                                : EdgeInsets.only(left: 4.w),
                                        child: AppText(
                                          name,
                                          color: Get.theme.primaryColor,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: AppText(
                              AppStrings.featured,
                              color: Get.theme.primaryColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          StaggeredGridView.countBuilder(
                            itemCount: featuredList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.h,
                            crossAxisSpacing: 10.w,
                            staggeredTileBuilder: (index) =>
                                const StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              return Image.asset(
                                featuredList[index],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: appButton(
                      onTap: () async {
                        if (imageController.promptController.text
                            .trim()
                            .isEmpty) {
                          AppSnackbar(
                            error: true,
                            content: 'Please enter text!!',
                          );
                        } else {
                          FocusManager.instance.primaryFocus?.unfocus();
                          await imageController.searchImage();

                          imageController.images.isNotEmpty
                              ? Get.to(() => FullScreenImage(
                                    prompt:
                                        imageController.promptController.text,
                                    style: styleList[
                                            imageController.sel_style.value]
                                        .name,
                                  ))?.then((value) {
                                  setState(() {});
                                })
                              : Container();
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
      ),
    );
  }
}
