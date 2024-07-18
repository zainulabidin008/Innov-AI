import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import 'ai_image_screen.dart';
import 'image_controller.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  ImageController imageController = Get.put(ImageController());

  @override
  void initState() {
    imageController.checkPurchase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => imageController.purchaseCheck.value
          ? const Center(
              child: CupertinoActivityIndicator(
                color: AppColors.grey,
              ),
            )
          : AIImageScreen(purchase: imageController.isPurchase.value)),
    );
  }
}
