// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_constant.dart';
import '../../../main.dart';
import '../../../widgets/app_snackbar.dart';

class UpgradeController extends GetxController {
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? subscription;
  String? expDate;
  int? imgCredit;
  String? imgRes;
  String? videoMin;
  String type = '';
  RxBool loading = false.obs;
  RxInt sliderIndex = 0.obs;
  RxString selPackage = ''.obs;
  int days = 0;
  List subList = [];
  var uid = storage.read(AppConst.uid);
  var collection = FirebaseFirestore.instance.collection('users');

  //get details
  getDetails(int index) {
    selPackage.value = subList[sliderIndex.value][index]['id'];
    type = subList[sliderIndex.value][index]['type'];

    if (type == 'chat') {
      days = subList[sliderIndex.value][index]['days'];
    } else if (type == 'image') {
      imgRes = subList[sliderIndex.value][index]['res'];
    } else {
      videoMin = DateFormat('mm:ss').format(
          DateTime.parse('2023-10-08 00:00:00').add(
              Duration(minutes: subList[sliderIndex.value][index]['min'])));
    }
  }

  //get benefit details
  getBenefit(int index) {
    if (type == 'chat') {
      return subList[sliderIndex.value][index]['duration'];
    } else if (type == 'image') {
      return 'Image resolution: ${subList[sliderIndex.value][index]['res']}';
    } else {
      return 'Video length: ${subList[sliderIndex.value][index]['min']} minutes';
    }
  }

  //add purchase to firestore
  addPurchase() async {
    Map<Object, Object?> body = {};

    if (type == 'chat') {
      var date = DateTime.now().add(Duration(days: days));

      body = {
        'chat_exp_date': date.toString(),
      };
    } else if (type == 'image') {
      body = {
        'img_credit': 1000,
        'img_res': imgRes,
      };
    } else {
      body = {
        'video_credit': videoMin,
      };
    }

    await collection.doc(uid).update(body).then((value) {
      print('User Purchase Updated');
      AppSnackbar(content: 'Purchased Successfully');
    });
  }

  //purchase package
  purchasePackage() async {
    loading.value = true;

    bool available = await inAppPurchase.isAvailable();

    if (available) {
      if (Platform.isIOS) {
        var paymentWrapper = SKPaymentQueueWrapper();
        var transactions = await paymentWrapper.transactions();
        transactions.forEach((transaction) async {
          print(transaction.transactionState);
          await paymentWrapper
              .finishTransaction(transaction)
              .catchError((onError) {
            print('finishTransaction Error ${onError.toString()}');
          });
        });
      }

      final ProductDetailsResponse response =
          await inAppPurchase.queryProductDetails({selPackage.value});

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: response.productDetails.first);

      await inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
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
        if (loading.value) {
          Get.back();
          addPurchase();
        }
        loading.value = false;
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        print('restored');
        AppSnackbar(content: 'Purchase restored');
      }
    });
  }
}
