import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_gradient.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_text.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    homeController.tabController = TabController(length: 4, vsync: this);
    homeController.tabController!.addListener(() {
      homeController.currentTab.value = homeController.tabController!.index;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: TabBarView(
          controller: homeController.tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: homeController.screens,
        ),
      ),
      bottomNavigationBar: Container(
        height: 67.h,
        decoration: BoxDecoration(
          gradient: AppGradient.purpleGradient,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: TabBar(
          controller: homeController.tabController,
          indicatorColor: AppColors.transparent,
          labelPadding: EdgeInsets.zero,
          tabs: [
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.chat_nav_ic,
                    height: 26.h,
                    width: 26.w,
                    color: homeController.currentTab.value == 0
                        ? AppColors.white
                        : AppColors.tabColor,
                  ),
                  SizedBox(height: 3.h),
                  FittedBox(
                    child: AppText(
                      AppStrings.chat,
                      color: homeController.currentTab.value == 0
                          ? AppColors.white
                          : AppColors.tabColor,
                      fontSize:
                          homeController.currentTab.value == 0 ? 15.sp : 12.sp,
                      fontWeight: homeController.currentTab.value == 0
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.bot_nav_ic,
                    height: 26.h,
                    width: 26.w,
                    color: homeController.currentTab.value == 1
                        ? AppColors.white
                        : AppColors.tabColor,
                  ),
                  SizedBox(height: 3.h),
                  FittedBox(
                    child: AppText(
                      AppStrings.ai_assistants,
                      color: homeController.currentTab.value == 1
                          ? AppColors.white
                          : AppColors.tabColor,
                      fontSize:
                          homeController.currentTab.value == 1 ? 15.sp : 12.sp,
                      fontWeight: homeController.currentTab.value == 1
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.gallery_nav_ic,
                    height: 24.h,
                    width: 24.w,
                    color: homeController.currentTab.value == 2
                        ? AppColors.white
                        : AppColors.tabColor,
                  ),
                  SizedBox(height: 3.h),
                  FittedBox(
                    child: AppText(
                      AppStrings.ai_images,
                      color: homeController.currentTab.value == 2
                          ? AppColors.white
                          : AppColors.tabColor,
                      fontSize:
                          homeController.currentTab.value == 2 ? 15.sp : 12.sp,
                      fontWeight: homeController.currentTab.value == 2
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.video_nav_ic,
                    height: 26.h,
                    width: 26.w,
                    color: homeController.currentTab.value == 3
                        ? AppColors.white
                        : AppColors.tabColor,
                  ),
                  SizedBox(height: 3.h),
                  FittedBox(
                    child: AppText(
                      AppStrings.ai_videos,
                      color: homeController.currentTab.value == 3
                          ? AppColors.white
                          : AppColors.tabColor,
                      fontSize:
                          homeController.currentTab.value == 3 ? 15.sp : 12.sp,
                      fontWeight: homeController.currentTab.value == 3
                          ? FontWeight.w600
                          : FontWeight.w400,
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
