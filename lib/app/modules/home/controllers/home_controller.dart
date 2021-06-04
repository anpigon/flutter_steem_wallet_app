import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../wallets/views/wallets_view.dart';

class HomeController extends GetxController {
  final selectedIndex = 0.obs;

  final List _widgetOptions = [
    WalletsView(),
    Center(child: Text('Community')),
    Center(child: Text('DApp')),
    Center(child: Text('Settings')),
  ];

  void onTapBottomNavigationBar(int index) {
    selectedIndex(index);
  }

  Widget get body {
    return _widgetOptions[selectedIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
