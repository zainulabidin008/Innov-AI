// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, depend_on_referenced_packages, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../../../constants/app_constant.dart';
import '../../../constants/app_keys.dart';
import '../../../constants/app_urls.dart';
import '../../../constants/subscription_list.dart';
import '../../../main.dart';
import '../../../services/api_service.dart';
import '../../../services/image_service.dart';
import '../../../widgets/app_snackbar.dart';

class ImageController extends GetxController {
  TextEditingController promptController = TextEditingController();
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? subscription;
  RxBool isPurchase = false.obs;
  RxBool purchaseCheck = false.obs;
  RxBool loading = false.obs;
  RxString selPackage = subscriptionList[1][1]['id'].toString().obs;
  RxInt credit = 0.obs;
  RxString imgRes = ''.obs;
  RxInt sel_style = 0.obs;
  RxInt sel_image = 0.obs;
  List images = [];
  List subList = [];
  var uid = storage.read(AppConst.uid);
  var collection = FirebaseFirestore.instance.collection('users');

  //check user purchased or not
  checkPurchase({
    bool load = true,
  }) async {
    purchaseCheck.value = load;

    await collection.doc(uid).get().then((value) async {
      if (value.exists) {
        subList.clear();
        var expDate = value.data()?['chat_exp_date'];
        var remainTime = value.data()?['video_credit'];
        credit.value = value.data()?['img_credit'];
        imgRes.value = value.data()?['img_res'];

        if (expDate != '') {
          var isExpire = DateTime.now().compareTo(DateTime.parse(expDate));

          if (isExpire != -1) {
            subList.add(subscriptionList[0]);
          }
        }

        if (credit.value == 0) {
          subList.add(subscriptionList[1]);
          isPurchase.value = false;
        } else {
          isPurchase.value = true;
        }

        if (remainTime == '00:00') {
          subList.add(subscriptionList[2]);
        }
      }
    });

    purchaseCheck.value = false;
  }

  //send prompt for image AI
  searchImage() async {
    loading.value = true;

    var search = promptController.text.trim();

    if (search.isNotEmpty && credit.value != 0) {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${AppKeys.chatgpt_key}",
      };
      Map<String, dynamic> body = {
        "prompt": search,
        "n": 3,
        "size": imgRes.value,
      };

      await APIService.postRequest(
        url: AppURLs.IMG_GEN_API,
        headers: headers,
        body: body,
      ).then((response) async {
        var responseData = json.decode(response.body);

        if (response.statusCode == 200) {
          images.clear();
          images.addAll(responseData['data']);
          credit.value--;

          await collection.doc(uid).update({
            'img_credit': credit.value,
          });
        } else {
          AppSnackbar(
            error: true,
            content:
                'Error on generating image: ${responseData['error']['message'].toString()}',
          );
        }
      });
    } else {
      AppSnackbar(
        error: true,
        content: 'Please upgrade to premium',
      );
    }

    loading.value = false;
  }

  //download image
  downloadImage() async {
    loading.value = true;

    bool isAuth = await ImageService.imagePermission();

    if (isAuth) {
      var response = await Dio().get(
        images[sel_image.value]['url'],
        options: Options(responseType: ResponseType.bytes),
      );
      var result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
      );
      print(result.toString());
      if (result['isSuccess']) {
        AppSnackbar(content: 'Image saved successfully');
      } else {
        AppSnackbar(
          error: true,
          content: 'Error while saving image',
        );
      }
    }

    loading.value = false;
  }

  //add purchase to firestore
  addPurchase() async {
    await collection.doc(uid).update({
      'img_credit': 1000,
      'img_res': imgRes.value,
    }).then((value) {
      print('User Purchase Updated');
      AppSnackbar(content: 'Purchased Successfully');
      checkPurchase();
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
      }
    });
  }
}
