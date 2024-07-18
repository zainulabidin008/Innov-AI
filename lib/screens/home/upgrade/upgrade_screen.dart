// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_gradient.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_radio_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/features_row.dart';
import 'upgrade_controller.dart';

class UpgradeScreen extends StatefulWidget {
  List subscriptionList;

  UpgradeScreen({
    super.key,
    required this.subscriptionList,
  });

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  UpgradeController upgradeController = Get.put(UpgradeController());

  @override
  void initState() {
    upgradeController.subList = widget.subscriptionList;
    upgradeController.getDetails(1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            Image.asset(
              AppAssets.purchase_bg,
              height: double.maxFinite,
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
            Image.asset(
              AppAssets.cover_bg,
              height: double.maxFinite,
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 30.h,
              right: 20.w,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: AppText(
                  AppStrings.close,
                  color: AppColors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                SizedBox(height: 30.h),
                CarouselSlider.builder(
                  itemCount: widget.subscriptionList.length,
                  options: CarouselOptions(
                    height: 60.h,
                    viewportFraction: 0.85,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      upgradeController.sliderIndex.value = index;
                      upgradeController.getDetails(1);
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        gradient: AppGradient.darkWhiteGradient,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          width: 1.w,
                          color: AppColors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.app_logo,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 25.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(7.r),
                            ),
                            child: Row(
                              children: [
                                AppText(
                                  widget.subscriptionList[index][1]['type'] ==
                                          'chat'
                                      ? AppStrings.pro
                                      : widget.subscriptionList[index][1]
                                                  ['type'] ==
                                              'image'
                                          ? AppStrings.plus
                                          : AppStrings.advance,
                                  color: AppColors.greenn,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(width: 5.w),
                                Image.asset(
                                  widget.subscriptionList[index][1]['type'] ==
                                          'chat'
                                      ? AppAssets.crown_ic
                                      : widget.subscriptionList[index][1]
                                                  ['type'] ==
                                              'image'
                                          ? AppAssets.plus_ic
                                          : AppAssets.star_ic,
                                  height: 16.h,
                                  width: 16.w,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: AppText(
                    AppStrings.upgrade_to,
                    color: AppColors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        '${AppStrings.premium} ',
                        color: AppColors.white,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      AppText(
                        AppStrings.plan,
                        color: AppColors.white,
                        height: 2.h,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 56.w),
                  child: SvgPicture.asset(
                    AppAssets.line_img,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: AppText(
                    upgradeController.type == 'chat'
                        ? AppStrings.enjoy_chat_access
                        : upgradeController.type == 'image'
                            ? AppStrings.enjoy_image_access
                            : AppStrings.enjoy_video_access,
                    color: AppColors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuresRow(text: AppStrings.powered_by),
                          upgradeController.type == 'chat'
                              ? SizedBox(height: 3.h)
                              : Container(),
                          upgradeController.type == 'chat'
                              ? featuresRow(text: AppStrings.remove_ads)
                              : Container(),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          upgradeController.type == 'chat'
                              ? featuresRow(text: AppStrings.unlimited_msgs)
                              : Container(),
                          upgradeController.type == 'chat'
                              ? SizedBox(height: 3.h)
                              : Container(),
                          featuresRow(text: AppStrings.cancel_any),
                        ],
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget
                      .subscriptionList[upgradeController.sliderIndex.value]
                      .length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
                  separatorBuilder: (context, index) => SizedBox(height: 15.h),
                  itemBuilder: (context, index) {
                    return Obx(
                      () => appRadioButton(
                        onTap: () {
                          upgradeController.getDetails(index);
                        },
                        isSelected: upgradeController.selPackage.value ==
                            widget.subscriptionList[upgradeController
                                .sliderIndex.value][index]['id'],
                        benefit: upgradeController.getBenefit(index),
                        price: widget.subscriptionList[upgradeController
                            .sliderIndex.value][index]['price'],
                        credit: upgradeController.type == 'image'
                            ? '/1000 Images'
                            : '',
                      ),
                    );
                  },
                ),
                const Spacer(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
                  child: appButton(
                    onTap: () async {
                      upgradeController.purchasePackage();
                    },
                    height: 50.h,
                    width: double.maxFinite,
                    borderRadius: BorderRadius.circular(124.r),
                    buttonColor: AppColors.greenn,
                    textColor: AppColors.white,
                    buttonText: AppStrings.subscribe_now,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            upgradeController.loading.value
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
