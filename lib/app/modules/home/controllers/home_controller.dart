import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../wallets/views/wallets_view.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  final SystemUiOverlayStyle overlayStyle = GetPlatform.isAndroid
      ? SystemUiOverlayStyle(
          statusBarColor: Get.theme.primaryColorDark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        )
      : SystemUiOverlayStyle.dark;

  final _pages = <Widget>[
    WalletsView(),
    Center(child: Text('Community')),
    Center(child: Text('DApp')),
    Center(child: Text('Settings')),
  ];

  void changePage(int _index) {
    currentIndex(_index);
  }

  Widget get currentPage => _pages[currentIndex.value];
}
