import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/modules/community/views/community_view.dart';
import 'package:flutter_steem_wallet_app/app/views/views/settings_view.dart';
import 'package:get/get.dart';

import '../../../views/views/wallets_view.dart';

class HomeController extends GetxController {
  final currentIndex = 1.obs;

  final _pages = <Widget>[
    WalletsView(),
    CommunityView(),
    Center(child: Text('DApp')),
    SettingsView(),
  ];

  void changePage(int _index) {
    currentIndex(_index);
  }

  Widget get currentPage => _pages[currentIndex.value];
}
