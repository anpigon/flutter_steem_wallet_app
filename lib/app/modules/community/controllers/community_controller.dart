import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/models/steem/steem_subscription.dart';
import 'package:flutter_steem_wallet_app/app/data/steem_provider.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController
    with StateMixin<List<SteemSubscription>>, SingleGetTickerProviderMixin {
  late TabController? tabController;

  Future<void> loadSubscribedCommunities() async {
    change([], status: RxStatus.loading());
    try {
      final steemSubscriptions =
          await SteemProvider.to.getAllSubscriptions('anpigon');
      steemSubscriptions.insert(
          0, SteemSubscription(tag: 'my', title: 'My communities'));
      steemSubscriptions.insert(
          0, SteemSubscription(tag: 'feed', title: 'My friends'));

      tabController =
          TabController(vsync: this, length: steemSubscriptions.length);

      change(steemSubscriptions, status: RxStatus.success());
    } catch (error) {
      change(null, status: RxStatus.error());
    }
  }

  @override
  void onInit() {
    loadSubscribedCommunities();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController?.dispose();

    super.onClose();
  }
}
