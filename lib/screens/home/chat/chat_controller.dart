// ignore_for_file: avoid_print, depend_on_referenced_packages, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_constant.dart';
import '../../../constants/app_keys.dart';
import '../../../constants/app_urls.dart';
import '../../../constants/subscription_list.dart';
import '../../../main.dart';
import '../../../services/api_service.dart';
import '../../../widgets/app_snackbar.dart';

class ChatController extends GetxController {
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? subscription;
  RewardedAd? rewardedAd;
  RxBool isPurchase = false.obs;
  RxBool purchaseCheck = false.obs;
  RxBool loading = false.obs;
  RxBool sending = false.obs;
  RxString selPackage = subscriptionList[0][1]['id'].toString().obs;
  RxInt credit = 0.obs;
  RxString validity = ''.obs;
  int days = subscriptionList[0][1]['days'];
  var history = [].obs;
  var chats = [].obs;
  var uid = storage.read(AppConst.uid);
  var collection = FirebaseFirestore.instance.collection('users');

  //check user purchased or not
  checkPurchase() async {
    purchaseCheck.value = true;

    await collection.doc(uid).get().then((value) async {
      if (value.exists) {
        var expDate = value.data()?['chat_exp_date'];

        if (expDate != '') {
          var isExpire = DateTime.now().compareTo(DateTime.parse(expDate));

          if (isExpire != -1) {
            isPurchase.value = false;
            credit.value = 0;
            storage.write(AppConst.chatCredit, 0);
          } else {
            validity.value = DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(expDate))
                .toString();
            credit.value = -1;
            storage.write(AppConst.chatCredit, -1);
            isPurchase.value = true;
          }
        } else {
          credit.value = storage.read(AppConst.chatCredit);
        }
      }
    });

    purchaseCheck.value = false;
  }

  //load rewarded ad
  loadRewardedAD() {
    RewardedAd.load(
      adUnitId: Platform.isAndroid ? AppKeys.android_ad_id : AppKeys.ios_ad_id,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          rewardedAd = null;
        },
      ),
    );
  }

  //show rewarded ad
  showRewardedAD() {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadRewardedAD();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('RewardedAd: Ad failed to load: ${error.message.toString()}');
          ad.dispose();
          loadRewardedAD();
        },
      );
      rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          credit.value++;
        },
      );
      rewardedAd = null;
    }
  }

  //get history of chat
  getHistory() async {
    history.value = storage.read(AppConst.chat_history) ?? [];
  }

  //send query to AI
  sendQuery() async {
    if (!sending.value) {
      if (credit.value != 0) {
        sending.value = true;
        var query = messageController.text.trim();
        String date =
            DateFormat('dd MMM yyyy').format(DateTime.now()).toString();

        if (query.isNotEmpty && credit.value != 0) {
          messageController.clear();
          chats.add({
            "role": "user",
            "content": query,
          });
          history.add({
            'text': query,
            'date': date,
          });
          if (credit.value != -1) {
            credit.value--;
            storage.write(AppConst.chatCredit, credit.value);
          }
          storage.write(AppConst.chat_history, history);

          Future.delayed(
            const Duration(milliseconds: 200),
            () {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            },
          );

          Map<String, String> headers = {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${AppKeys.chatgpt_key}",
          };
          Map<String, dynamic> body = {
            "model": "gpt-3.5-turbo",
            "messages": chats,
            "max_tokens": 3000,
          };

          await APIService.postRequest(
            url: AppURLs.CHAT_COM_API,
            headers: headers,
            body: body,
          ).then((response) {
            print(response.statusCode.toString());

            if (response.statusCode == 200) {
              var responseData = json.decode(response.body);

              chats.add(
                {
                  "role": responseData['choices'][0]['message']['role'],
                  "content": responseData['choices'][0]['message']['content'],
                },
              );
              Future.delayed(
                const Duration(milliseconds: 200),
                () {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                },
              );
            } else {
              var responseData = json.decode(response.body);

              print('Error==> ${responseData.toString()}');
            }
          });
        }
        sending.value = false;
      } else {
        AppSnackbar(
          error: true,
          content: 'Please upgrade to premium',
        );
      }
    }
  }

  //add purchase to firestore
  addPurchase() async {
    var date = DateTime.now().add(Duration(days: days));

    await collection.doc(uid).update({
      'chat_exp_date': date.toString(),
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
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        print('restored');
        AppSnackbar(content: 'Purchase restored');
      }
    });
  }
}
