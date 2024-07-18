import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/ai_assistant_list.dart';
import '../../../constants/app_colors.dart';
import '../../../models/assistant_model.dart';
import '../../../widgets/app_text.dart';
import '../home_controller.dart';
import 'assistant_controller.dart';

class AllAssistants extends StatefulWidget {
  const AllAssistants({super.key});

  @override
  State<AllAssistants> createState() => _AllAssistantsState();
}

class _AllAssistantsState extends State<AllAssistants> {
  AssistantController assistantController = Get.put(AssistantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: aiAssistantList.length,
        padding: EdgeInsets.symmetric(vertical: 25.h),
        separatorBuilder: (context, index) => SizedBox(height: 25.h),
        itemBuilder: (context, index) {
          String category = aiAssistantList[index]['category'];
          List<AssistantModel> types = aiAssistantList[index]['types'];

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      category,
                      color: Get.theme.primaryColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    InkWell(
                      onTap: () {
                        assistantController.tabController!.animateTo(index + 1);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.r),
                          border: Border.all(
                            width: 1.w,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_right_alt_rounded,
                          size: 25.sp,
                          color: Get.theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 195.h,
                child: ListView.separated(
                  itemCount: types.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  separatorBuilder: (context, index) => SizedBox(width: 15.w),
                  itemBuilder: (context, index) {
                    String icon = types[index].icon;
                    String title = types[index].title;
                    String subTitle = types[index].subTitle;

                    return Container(
                      width: 160.w,
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Get.theme.primaryColor.withOpacity(0.1)
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            icon,
                            height: 40.h,
                            width: 40.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              title,
                              color: Get.theme.primaryColor,
                              textAlign: TextAlign.left,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              subTitle,
                              color: Get.isDarkMode
                                  ? Get.theme.primaryColor.withOpacity(0.7)
                                  : AppColors.subTitleColor,
                              textAlign: TextAlign.left,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Get.find<HomeController>()
                                  .tabController
                                  ?.animateTo(0);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 25.sp,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
