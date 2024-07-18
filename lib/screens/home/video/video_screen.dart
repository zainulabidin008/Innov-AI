import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import 'ai_video_screen.dart';
import 'video_controller.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    videoController.checkPurchase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => videoController.purchaseCheck.value
          ? const Center(
              child: CupertinoActivityIndicator(
                color: AppColors.grey,
              ),
            )
          : AIVideoScreen(purchase: videoController.isPurchase.value)),
    );
  }
}
