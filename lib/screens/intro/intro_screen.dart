import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_video_player.dart';
import '../../widgets/dot_indicator.dart';
import '../login/login_screen.dart';
import 'intro_controller.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  IntroController introController = Get.put(IntroController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 35.h),
        child: Column(
          children: [
            CarouselSlider.builder(
              carouselController: introController.carouselController,
              itemCount: introController.sliderItems.length,
              options: CarouselOptions(
                viewportFraction: 1,
                height: 370.h,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  introController.carouselIndex.value = index;
                },
              ),
              itemBuilder: (context, index, realIndex) => index == 2
                  ? AppVideoPlayer(
                      locale: true,
                    )
                  : Image.asset(
                      introController.sliderItems[index],
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 25.h),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => DotIndicator(
                    gap: 5.w,
                    activeColor: AppColors.greenn,
                    inActivecolor: AppColors.indicator,
                    isActive: index == introController.carouselIndex.value,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            AppText(
              AppStrings.ai_hub,
              color: AppColors.black,
              fontSize: 40.sp,
              fontWeight: FontWeight.w600,
            ),
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(horizontal: 37.w),
                child: AppText(
                  introController.carouselIndex.value == 0
                      ? AppStrings.chat_intro
                      : introController.carouselIndex.value == 1
                          ? AppStrings.image_intro
                          : AppStrings.video_intro,
                  color: AppColors.black,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => const LoginScreen());
                    },
                    child: AppText(
                      AppStrings.skip,
                      color: AppColors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  appButton(
                    onTap: () {
                      introController.carouselIndex.value == 2
                          ? Get.to(() => const LoginScreen())
                          : introController.carouselController.nextPage();
                    },
                    height: 37.h,
                    width: 110.w,
                    buttonColor: AppColors.greenn,
                    borderRadius: BorderRadius.circular(25.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          AppStrings.next,
                          color: AppColors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(width: 5.w),
                        Icon(
                          Icons.arrow_right_alt,
                          size: 25.sp,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
