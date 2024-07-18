import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/app_strings.dart';
import '../../../main.dart';
import '../../../widgets/app_text.dart';
import 'setting_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  SettingController settingController = Get.put(SettingController());

  @override
  void initState() {
    settingController.getHistory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0.4,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.keyboard_arrow_left_rounded,
                  size: 32.sp,
                  color: Get.theme.primaryColor.withOpacity(0.8),
                ),
              ),
              title: AppText(
                AppStrings.history,
                color: Get.theme.primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: settingController.history.isEmpty
                  ? Center(
                      child: AppText(
                        AppStrings.no_history,
                        color: Get.theme.primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : ListView.separated(
                      itemCount: settingController.history.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15.h),
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(
                              '${index.toString()} ${settingController.history[index]['text']}'),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: SvgPicture.asset(
                              AppAssets.delete_ic,
                              height: 25.h,
                              width: 25.w,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            settingController.history.removeAt(index);
                            storage.write(AppConst.chat_history,
                                settingController.history);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? AppColors.white.withOpacity(0.1)
                                  : AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: AppText(
                                    settingController.history[index]['date'],
                                    color: Get.isDarkMode
                                        ? AppColors.white.withOpacity(0.8)
                                        : AppColors.dateColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: AppText(
                                    settingController.history[index]['text'],
                                    color: Get.theme.primaryColor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          settingController.historyLoad.value
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
