// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, avoid_print, avoid_function_literals_in_foreach_calls, deprecated_member_use, avoid_single_cascade_in_expression_statements, await_only_futures

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;

import '../../../constants/app_assets.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/app_keys.dart';
import '../../../constants/app_urls.dart';
import '../../../constants/subscription_list.dart';
import '../../../main.dart';
import '../../../services/api_service.dart';
import '../../../widgets/app_snackbar.dart';

class VideoController extends GetxController {
  TextEditingController promptController = TextEditingController();
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? subscription;
  RxBool isPurchase = false.obs;
  RxBool purchaseCheck = false.obs;
  RxBool loading = false.obs;
  RxBool purchasing = false.obs;
  RxBool agree = false.obs;
  RxString selPackage = subscriptionList[2][1]['id'].toString().obs;
  RxString videoMin = '00:00'.obs;
  RxString credit = '00:00'.obs;
  List subList = [];
  XFile? imageFile;
  var videoUrl;
  var uid = storage.read(AppConst.uid);
  var collection = FirebaseFirestore.instance.collection('users');
  List exampleList = [
    AppAssets.example1_img,
    AppAssets.example2_img,
    AppAssets.example3_img,
    AppAssets.example4_img,
  ];

  //check user purchased or not
  checkPurchase({
    bool load = true,
  }) async {
    purchaseCheck.value = load;

    await collection.doc(uid).get().then((value) async {
      if (value.exists) {
        subList.clear();
        var expDate = value.data()?['chat_exp_date'];
        var imgCredit = value.data()?['img_credit'];
        videoMin.value = value.data()?['video_credit'];

        if (expDate != '') {
          var isExpire = DateTime.now().compareTo(DateTime.parse(expDate));

          if (isExpire != -1) {
            subList.add(subscriptionList[0]);
          }
        }

        if (imgCredit == 0) {
          subList.add(subscriptionList[1]);
        }

        if (videoMin.value == '00:00') {
          subList.add(subscriptionList[2]);
          isPurchase.value = false;
        } else {
          isPurchase.value = true;
        }
      }
    });

    purchaseCheck.value = false;
  }

  //send image to AI
  uploadImage() async {
    if (videoMin.value != '00:00') {
      loading.value = true;

      var mimeType = lookupMimeType(imageFile!.path.toString())!.split("/");

      await APIService.uploadImage(
        AppURLs.ADD_IMG_API,
        await http.MultipartFile.fromPath(
          'image',
          imageFile!.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      ).then((response) async {
        var responseData = await response;

        if (responseData.statusCode == 201) {
          var data = await jsonDecode(responseData.body);
          var url = data['url'];
          await createVideo(url);
        } else {
          print('Error on uploading image===> ${responseData.body.toString()}');
          AppSnackbar(
            error: true,
            content: 'Error on uploading image',
          );
        }
      });

      loading.value = false;
    } else {
      AppSnackbar(
        error: true,
        content: 'Please upgrade to premium',
      );
    }
  }

  //create video from image
  createVideo(String url) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'authorization': 'Basic ${AppKeys.did_key}',
      'content-type': 'application/json',
    };
    Map<String, dynamic> body = {
      'source_url': url,
      "script": {
        "type": "text",
        "input": promptController.text.trim(),
      }
    };

    await APIService.postRequest(
      url: AppURLs.CREATE_VIDEO_API,
      headers: headers,
      body: body,
    ).then((response) async {
      var responseData = await jsonDecode(response.body);

      if (response.statusCode == 201) {
        var id = responseData['id'];
        print('id==> ${id.toString()}');
        await Future.delayed(const Duration(seconds: 1));
        await getVideo(id);
      } else {
        AppSnackbar(
          error: true,
          content:
              'Error on generating video: ${responseData['description'].toString()}',
        );
      }
    });
  }

  //get created video from AI
  getVideo(String id) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'authorization': 'Basic ${AppKeys.did_key}',
      'content-type': 'application/json',
    };

    await APIService.getRequest(
      url: AppURLs.GET_VIDEO_API + id,
      headers: headers,
    ).then((response) async {
      var responseData = await jsonDecode(await response);
      debugPrint(responseData.toString(), wrapWidth: 2000);
      if (responseData['kind'] == null) {
        print('status===> ${responseData['status'].toString()}');
        if (responseData['status'] == 'done') {
          VideoPlayerController? videoPlayerController;

          videoPlayerController =
              await VideoPlayerController.network(responseData['result_url']);

          await videoPlayerController.initialize().then((value) async {
            Duration dur = videoPlayerController!.value.duration;
            print('dur: ${dur.toString()}');

            var sub = DateFormat('mm:ss').format(
                DateTime.parse('2023-10-08 00:${videoMin.value}')
                    .subtract(dur));
            print('cr: $sub');

            var exp = DateTime.parse('2023-10-08 00:${videoMin.value}')
                .compareTo(DateTime.parse('2023-10-08 00:$sub'));
            print(exp.toString());

            if (exp != -1) {
              videoUrl = responseData['result_url'];
              print('url====> ${videoUrl.toString()}');
              videoMin.value = sub;
              await collection.doc(uid).update({
                'video_credit': videoMin.value,
              });
            } else {
              AppSnackbar(
                error: true,
                content: 'Please upgrade to premium',
              );
            }
          });
        } else {
          await getVideo(id);
        }
      } else {
        AppSnackbar(
          error: true,
          content: 'Error on getting video: ${responseData.toString()}',
        );
      }
    });
  }

  //download video to local
  videoDownload() async {
    loading.value = true;

    var tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/temp.mp4';
    await Dio().download(
      videoUrl,
      path,
      onReceiveProgress: (count, total) {},
    );
    final result = await ImageGallerySaver.saveFile(path);
    print(result.toString());
    if (result['isSuccess']) {
      AppSnackbar(content: 'Video saved successfully');
    } else {
      AppSnackbar(
        error: true,
        content: 'Error while saving video',
      );
    }
    loading.value = false;
  }

  //add purchase to firestore
  addPurchase() {
    videoMin.value = credit.value;

    collection.doc(uid).update({
      'video_credit': videoMin.value,
    }).then((value) {
      print('User Purchase Updated');
      AppSnackbar(content: 'Purchased Successfully');
      checkPurchase();
    });
  }

  //purchase package
  purchasePackage() async {
    purchasing.value = true;

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
        purchasing.value = false;
        AppSnackbar(
          error: true,
          content: 'Error while purchasing',
        );
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        print('Purchase Cancelled');
        purchasing.value = false;
        AppSnackbar(
          error: true,
          content: 'Purchase cancelled',
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        await inAppPurchase.completePurchase(purchaseDetails);
        print('Purchase Successful');
        if (purchasing.value) {
          Get.back();
          addPurchase();
        }
        purchasing.value = false;
      }
    });
  }
}
