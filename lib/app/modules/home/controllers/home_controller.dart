import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/views/views/settings_view.dart';
import 'package:get/get.dart';

import '../../../views/views/wallets_view.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  final _pages = <Widget>[
    WalletsView(),
    Center(child: Text('Community')),
    Center(child: Text('DApp')),
    SettingsView(),
  ];

  void changePage(int _index) {
    currentIndex(_index);
  }

  Widget get currentPage => _pages[currentIndex.value];
}
