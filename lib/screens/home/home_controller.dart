import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ai_assistant/ai_assistant.dart';
import 'chat/chat_screen.dart';
import 'image/image_screen.dart';
import 'video/video_screen.dart';

class HomeController extends GetxController {
  TabController? tabController;
  var currentTab = 0.obs;

  List<Widget> screens = [
    const ChatScreen(),
    const AIAssistants(),
    const ImageScreen(),
    const VideoScreen(),
  ];
}
