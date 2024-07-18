// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import 'ai_chat_screen.dart';
import 'chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    chatController.checkPurchase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => chatController.purchaseCheck.value
          ? const Center(
              child: CupertinoActivityIndicator(
                color: AppColors.grey,
              ),
            )
          : AIChatScreen(purchase: chatController.isPurchase.value)),
    );
  }
}
