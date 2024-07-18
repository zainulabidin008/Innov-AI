// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../constants/app_constant.dart';
import '../../../constants/subscription_list.dart';
import '../../../main.dart';
import '../../../widgets/app_snackbar.dart';

class SettingController extends GetxController {
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? subscription;
  RxBool loading = false.obs;
  RxBool historyLoad = false.obs;
  bool darkMode = storage.read(AppConst.isDarkMode);
  var uid = storage.read(AppConst.uid);
  List subList = [];
  var history = [].obs;
  var collection = FirebaseFirestore.instance.collection('users');

  //check user purchased or not
  checkPurchase({
    bool load = true,
  }) async {
    loading.value = load;

    await collection.doc(uid).get().then((value) async {
      if (value.exists) {
        subList.clear();
        var expDate = value.data()?['chat_exp_date'];
        var imgCredit = value.data()?['img_credit'];
        var videoMin = value.data()?['video_credit'];

        if (expDate != '') {
          var isExpire = DateTime.now().compareTo(DateTime.parse(expDate));

          if (isExpire != -1) {
            subList.add(subscriptionList[0]);
          }
        }

        if (imgCredit == 0) {
          subList.add(subscriptionList[1]);
        }

        if (videoMin == '00:00') {
          subList.add(subscriptionList[2]);
        }
      }
    });

    loading.value = false;
  }

  //get history of chat
  getHistory() async {
    historyLoad.value = true;

    history.value = storage.read(AppConst.chat_history) ?? [];

    historyLoad.value = false;
  }

  //add purchase listner
  purchaseUpdate() async {
    final purchaseStream = inAppPurchase.purchaseStream;
    subscription = purchaseStream.listen((purchaseDetailsList) async {
      await listenToPurchaseUpdate(purchaseDetailsList);
    });
  }

  //listner of purchase update
  listenToPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    purchaseDetailsList.forEach((purchaseDetails) async {
      print(purchaseDetails.purchaseID);
      if (purchaseDetails.status == PurchaseStatus.error) {
        print('Purchase Error: ${purchaseDetails.error?.message.toString()}');
        loading.value = false;
        AppSnackbar(
          error: true,
          content: 'Error while purchasing',
        );
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        print('Purchase Cancelled');
        loading.value = false;
        AppSnackbar(
          error: true,
          content: 'Purchase cancelled',
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        await inAppPurchase.completePurchase(purchaseDetails);
        print('Purchase Successful');

        loading.value = false;
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        loading.value = false;
        print('restored');
        AppSnackbar(content: 'Purchase restored');
      }
    });
  }
}
