import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_urls.dart';
import '../../../widgets/app_text.dart';
import 'setting_controller.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  SettingController settingController = Get.put(SettingController());
  WebViewController controller = WebViewController();

  loadPolicy() {
    final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(params)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          if (progress != 100) {
            settingController.loading.value = true;
          } else {
            settingController.loading.value = false;
          }
        },
      ))
      ..loadRequest(Uri.parse(AppURLs.PRIVACY_POLICY));
  }

  @override
  void initState() {
    loadPolicy();

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
                AppStrings.privacy_policy,
                color: Get.theme.primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            body: WebViewWidget(
              controller: controller,
            ),
          ),
          settingController.loading.value
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
