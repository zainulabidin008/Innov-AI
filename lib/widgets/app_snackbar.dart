// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

import '../constants/app_colors.dart';

AppSnackbar({
  required String content,
  bool error = false,
}) {
  Get.snackbar(
    'Message',
    content,
    backgroundColor: error ? AppColors.red : AppColors.green,
    colorText: AppColors.white,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(seconds: 2),
  );
}
