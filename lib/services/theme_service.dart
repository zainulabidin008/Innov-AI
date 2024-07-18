// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_constant.dart';
import '../main.dart';

class ThemeService {
  static ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  static bool isSavedDarkMode() {
    if (storage.read(AppConst.isDarkMode) == null) {
      saveThemeMode(false);
    }
    return storage.read(AppConst.isDarkMode);
  }

  static saveThemeMode(bool isDarkMode) {
    storage.write(AppConst.isDarkMode, isDarkMode);
  }

  static changeThemeMode() async {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    await saveThemeMode(!isSavedDarkMode());
  }
}
