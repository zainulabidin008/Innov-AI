// ignore_for_file: deprecated_member_use

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import '../widgets/app_snackbar.dart';
import '../widgets/choice_dialog.dart';

class ImageService {
  /// Pick Imge
  static pickImage() async {
    bool isAuth = await imagePermission();
    if (isAuth) {
      var pickedImage = await showChoiceDialog(Get.context!);
      return pickedImage;
    }
  }

  /// PERMISSION FOR CAMERA & GALLERY
  static imagePermission() async {
    var permission = await PhotoManager.requestPermissionExtend();

    if (permission.isAuth) {
      return true;
    } else {
      AppSnackbar(error: true, content: 'Please allow permission');
      await PhotoManager.openSetting();
      return false;
    }
  }

  /// OPEN GALLERY
  static openGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    Get.back();
    return pickedFile;
  }

  /// OPEN CAMERA
  static openCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    Get.back();
    return pickedFile;
  }
}
