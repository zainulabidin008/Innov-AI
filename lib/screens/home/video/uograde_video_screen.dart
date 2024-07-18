import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/subscription_list.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_radio_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/features_row.dart';
import 'video_controller.dart';

class UpgradeVideoScreen extends StatefulWidget {
  const UpgradeVideoScreen({super.key});

  @override
  State<UpgradeVideoScreen> createState() => _UpgradeVideoScreenState();
}

class _UpgradeVideoScreenState extends State<UpgradeVideoScreen> {
  VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    videoController.purchaseUpdate();

    super.initState();
  }

  @override
  void dispose() {
    videoController.selPackage.value = subscriptionList[2][1]['id'].toString();
    videoController.checkPurchase(load: false);
    videoController.subscription?.cancel();

    super.dispose();
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppText(
                    AppStrings.upgrade_to,
                    color: AppColors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  Row(
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
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: SvgPicture.asset(
                      AppAssets.line_img,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  AppText(
                    AppStrings.enjoy_video_access,
                    color: AppColors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      featuresRow(text: AppStrings.powered_by),
                      featuresRow(text: AppStrings.cancel_any),
                    ],
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: subscriptionList[2].length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 15.h),
                    itemBuilder: (context, index) {
                      return Obx(
                        () => appRadioButton(
                          onTap: () {
                            videoController.credit
                                .value = DateFormat('mm:ss').format(DateTime.parse(
                                    '2023-10-08 00:${videoController.videoMin.value}')
                                .add(Duration(
                                    minutes: subscriptionList[2][index]
                                        ['min'])));

                            videoController.selPackage.value =
                                subscriptionList[2][index]['id'];
                          },
                          isSelected: videoController.selPackage.value ==
                              subscriptionList[2][index]['id'],
                          benefit:
                              'Video length: ${subscriptionList[2][index]['min']} minutes',
                          price: subscriptionList[2][index]['price'],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: appButton(
                      onTap: () async {
                        videoController.purchasePackage();
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
            ),
            videoController.loading.value
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
