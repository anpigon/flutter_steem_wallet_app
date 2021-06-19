import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletsController extends GetxController
    with SingleGetTickerProviderMixin {
  late final TabController tabController;

  static WalletsController get to => Get.find();

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
