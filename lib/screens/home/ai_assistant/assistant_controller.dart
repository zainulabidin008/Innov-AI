import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'all_assistant.dart';
import 'other_assistant.dart';

class AssistantController extends GetxController {
  TabController? tabController;
  var currentTab = 0.obs;

  List<Widget> screens = [
    const AllAssistants(),
    const OtherAssistants(),
    const OtherAssistants(),
    const OtherAssistants(),
    const OtherAssistants(),
    const OtherAssistants(),
    const OtherAssistants(),
    const OtherAssistants(),
  ];
}
