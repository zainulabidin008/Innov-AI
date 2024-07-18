import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_info_list.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/offering_list.dart';
import '../../../widgets/app_text.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          AppStrings.about_us,
          color: Get.theme.primaryColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.h),
              AppText(
                AppStrings.about_us_aihub,
                color: Get.theme.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 5.h),
              AppText(
                AppStrings.welcome_aihub,
                color: Get.theme.primaryColor,
                textAlign: TextAlign.left,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 10.h),
              AppText(
                AppStrings.our_offerings,
                color: Get.theme.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 10.h),
              ListView.separated(
                itemCount: offeringList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 7.h),
                itemBuilder: (context, index) => RichText(
                  text: TextSpan(
                    text: offeringList[index]['title'],
                    style: GoogleFonts.poppins(
                      color: Get.theme.primaryColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      WidgetSpan(
                        child: SizedBox(width: 2.w),
                      ),
                      TextSpan(
                        text: offeringList[index]['desc'],
                        style: GoogleFonts.poppins(
                          color: Get.theme.primaryColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              AppText(
                AppStrings.we_committed,
                color: Get.theme.primaryColor,
                textAlign: TextAlign.left,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 10.h),
              AppText(
                AppStrings.about_us_aihub,
                color: Get.theme.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 5.h),
              ListView.separated(
                itemCount: appInfoList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemBuilder: (context, index) => RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Container(
                            height: 5.h,
                            width: 5.w,
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: 5.w),
                      ),
                      TextSpan(
                        text: appInfoList[index]['title'],
                        style: GoogleFonts.poppins(
                          color: Get.theme.primaryColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: 2.w),
                      ),
                      TextSpan(
                        text: appInfoList[index]['desc'],
                        style: GoogleFonts.poppins(
                          color: Get.theme.primaryColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              AppText(
                AppStrings.join_us,
                color: Get.theme.primaryColor,
                textAlign: TextAlign.left,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 10.h),
              AppText(
                AppStrings.thank_you,
                color: Get.theme.primaryColor,
                textAlign: TextAlign.left,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
