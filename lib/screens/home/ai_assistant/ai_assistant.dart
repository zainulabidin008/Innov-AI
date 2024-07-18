// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/ai_assistant_list.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/app_text.dart';
import 'assistant_controller.dart';

class AIAssistants extends StatefulWidget {
  const AIAssistants({super.key});

  @override
  State<AIAssistants> createState() => _AIAssistantsState();
}

class _AIAssistantsState extends State<AIAssistants>
    with TickerProviderStateMixin {
  AssistantController assistantController = Get.put(AssistantController());

  @override
  void initState() {
    assistantController.tabController = TabController(
        length: aiAssistantList.length + 1, vsync: this, initialIndex: 0);
    assistantController.tabController!.addListener(() {
      assistantController.currentTab.value =
          assistantController.tabController!.index;
    });

    super.initState();
  }

  @override
  void dispose() {
    assistantController.currentTab.value = 0;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        leadingWidth: 0,
        leading: Container(),
        centerTitle: true,
        title: AppText(
          AppStrings.ai_assistants,
          color: Get.theme.primaryColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 25.h),
          TabBar(
            controller: assistantController.tabController,
            labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
            indicatorColor: AppColors.transparent,
            isScrollable: true,
            splashBorderRadius: BorderRadius.circular(10.r),
            tabs: List.generate(aiAssistantList.length + 1, (index) {
              int realIndex = index - 1;
              var list;

              if (index != 0) {
                list = aiAssistantList[realIndex];
              }

              return Obx(
                () => Container(
                  constraints: BoxConstraints(
                    minWidth: 67.w,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: assistantController.currentTab.value == index
                        ? AppColors.greenn
                        : AppColors.lightGrey,
                  ),
                  child: AppText(
                    index == 0 ? 'All' : list['category'],
                    color: assistantController.currentTab.value == index
                        ? AppColors.white
                        : AppColors.lableColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }),
          ),
          DefaultTabController(
            length: 4,
            child: Expanded(
              child: TabBarView(
                controller: assistantController.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: assistantController.screens,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
