import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slide_action/slide_action.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_gradient.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_text.dart';
import '../../widgets/gradient_widget.dart';
import '../home/home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  RxBool start = false.obs;
  RxBool done = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.4,
        leadingWidth: 0,
        leading: Container(),
        centerTitle: false,
        title: Container(
          alignment: Alignment.centerLeft,
          child: AppText(
            AppStrings.ai_hub,
            color: AppColors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              AppStrings.welcome_to,
              color: AppColors.black,
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
            ),
            gradientWidget(
              gradient: AppGradient.reversePurpleGradient,
              child: AppText(
                AppStrings.ai_hub,
                color: AppColors.black,
                fontSize: 52.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  AppStrings.strt_chat,
                  color: AppColors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
                AppText(
                  AppStrings.ai_hub,
                  color: AppColors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
                AppText(
                  ' Now.',
                  color: AppColors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            AppText(
              AppStrings.you_can,
              color: AppColors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: 280.w,
              child: SlideAction(
                action: () {
                  Get.off(() => const HomeScreen());
                },
                actionSnapThreshold: 0.6,
                thumbWidth: 100.w,
                trackHeight: 60.h,
                thumbBuilder: (context, currentState) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      gradient: AppGradient.horizontalPurpleGradient,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Image.asset(
                      AppAssets.right_arrow_ic,
                    ),
                  );
                },
                trackBuilder: (context, currentState) {
                  start.value = currentState.thumbState == ThumbState.dragging;
                  done.value = currentState.thumbFractionalPosition >= 0.6;

                  return Obx(
                    () => Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 25.w),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: start.value
                            ? Container()
                            : done.value
                                ? Container()
                                : AppText(
                                    AppStrings.slide_chat,
                                    color: AppColors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400,
                                  )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
