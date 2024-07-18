// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_gradient.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/capabilities_box.dart';
import '../setting/settings_screen.dart';
import 'chat_controller.dart';
import 'upgrade_chat_screen.dart';

class AIChatScreen extends StatefulWidget {
  bool purchase;

  AIChatScreen({
    super.key,
    this.purchase = true,
  });

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    chatController.getHistory();
    chatController.loadRewardedAD();
    Future.delayed(const Duration(milliseconds: 400)).then((value) {
      if (!widget.purchase) {
        Get.to(() => const UpgradeChatScreen());
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
          chatController.messageController.clear();
        }
      },
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            elevation: 0.4,
            leadingWidth: 0,
            leading: Container(),
            centerTitle: false,
            title: Row(
              children: [
                chatController.credit.value == -1
                    ? AppText(
                        AppStrings.unlimited,
                        color: Get.theme.primaryColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      )
                    : Image.asset(
                        AppAssets.time_ic,
                        height: 20.h,
                        width: 20.w,
                        color: Get.theme.primaryColor,
                      ),
                chatController.credit.value == -1
                    ? Container()
                    : SizedBox(width: 10.w),
                chatController.credit.value == -1
                    ? Container()
                    : AppText(
                        chatController.credit.value.toString(),
                        color: Get.theme.primaryColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
              ],
            ),
            actions: [
              chatController.credit.value == -1
                  ? Center(
                      child: AppText(
                        AppStrings.valid_till + chatController.validity.value,
                        color: Get.theme.primaryColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: appButton(
                        onTap: () {
                          Get.to(() => const UpgradeChatScreen());
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
              SizedBox(width: 15.w),
              InkWell(
                onTap: () {
                  Get.to(() => const SettingsScreen())?.then((value) {
                    setState(() {});
                  });
                },
                child: SvgPicture.asset(
                  AppAssets.setting_ic,
                  color: Get.theme.primaryColor,
                  height: 20.h,
                  width: 20.w,
                ),
              ),
              SizedBox(width: 16.w),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: chatController.chats.isEmpty
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 35.h),
                              AppText(
                                AppStrings.capabilities,
                                color: Get.theme.primaryColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 25.h),
                              capabilitiesBox(
                                icon: AppAssets.bot1_ic,
                                text: AppStrings.answer_all,
                                subText: AppStrings.just_ask,
                              ),
                              SizedBox(height: 25.h),
                              capabilitiesBox(
                                size: 27,
                                icon: AppAssets.bot2_ic,
                                text: AppStrings.generate_all,
                                subText: AppStrings.essays_more,
                              ),
                              SizedBox(height: 25.h),
                              capabilitiesBox(
                                size: 30,
                                icon: AppAssets.bot3_ic,
                                text: AppStrings.conversations,
                                subText: AppStrings.i_can,
                              ),
                              SizedBox(height: 10.h),
                              AppText(
                                AppStrings.these_are,
                                color: Get.theme.primaryColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(height: 25.h),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: chatController.scrollController,
                        itemCount: chatController.chats.length + 1,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 3.h),
                        itemBuilder: (context, index) {
                          return index < chatController.chats.length
                              ? chatController.chats[index]['role'] == 'user'
                                  ? Container(
                                      padding: EdgeInsets.only(
                                        left: 15.w,
                                        right: 15.w,
                                        bottom: 5.h,
                                      ),
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          top: 15.h,
                                          bottom: 15.h,
                                          left: 10.w,
                                          right: 15.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.greenn,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.r),
                                            bottomLeft: Radius.circular(10.r),
                                            bottomRight: Radius.circular(10.r),
                                          ),
                                        ),
                                        child: AppText(
                                          chatController.chats[index]
                                              ['content'],
                                          textAlign: TextAlign.left,
                                          color: AppColors.white,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(
                                        left: 15.w,
                                        right: 15.w,
                                        bottom: 5.h,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          top: 15.h,
                                          bottom: 15.h,
                                          left: 10.w,
                                          right: 15.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Get.isDarkMode
                                              ? Get.theme.primaryColor
                                                  .withOpacity(0.2)
                                              : AppColors.lightGrey,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.r),
                                            bottomLeft: Radius.circular(10.r),
                                            bottomRight: Radius.circular(10.r),
                                          ),
                                        ),
                                        child: AppText(
                                          chatController.chats[index]
                                              ['content'],
                                          textAlign: TextAlign.left,
                                          color: Get.theme.primaryColor,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                              : Obx(
                                  () => chatController.sending.value
                                      ? Container(
                                          padding: EdgeInsets.only(
                                            left: 15.w,
                                            right: 15.w,
                                            bottom: 5.h,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 15.h,
                                              bottom: 15.h,
                                              left: 10.w,
                                              right: 15.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode
                                                  ? Get.theme.primaryColor
                                                      .withOpacity(0.2)
                                                  : AppColors.lightGrey,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.r),
                                                bottomLeft:
                                                    Radius.circular(10.r),
                                                bottomRight:
                                                    Radius.circular(10.r),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                AppText(
                                                  AppStrings.gen_response,
                                                  textAlign: TextAlign.left,
                                                  color: Get.theme.primaryColor,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                SizedBox(width: 5.w),
                                                SpinKitThreeBounce(
                                                  color: AppColors.greenn,
                                                  size: 23.sp,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                );
                        },
                      ),
              ),
              Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 60.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Get.theme.primaryColor.withOpacity(0.3)
                              : AppColors.boxColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: chatController.messageController,
                                cursorColor: AppColors.hintColor,
                                style: TextStyle(
                                  color: Get.theme.primaryColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppStrings.ask_me,
                                  hintStyle: TextStyle(
                                    color: AppColors.hintColor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            InkWell(
                              onTap: chatController.sendQuery,
                              child: Icon(
                                Icons.send_rounded,
                                size: 28.sp,
                                color: AppColors.greenn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    chatController.credit.value != 0
                        ? Container()
                        : SizedBox(width: 10.w),
                    chatController.credit.value != 0
                        ? Container()
                        : appButton(
                            onTap: () {
                              chatController.showRewardedAD();
                            },
                            height: 60.h,
                            width: 80.w,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            borderRadius: BorderRadius.circular(10.r),
                            gradient: AppGradient.purpleGradient,
                            buttonText: AppStrings.watch_ad,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
