import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/account.dart';
import '../../../services/local_data_service.dart';
import '../../../services/steem_service.dart';

class WalletsController extends GetxController
    with StateMixin<Account>, SingleGetTickerProviderMixin {
  final accounts = <String>[].obs;
  final selectedAccount = ''.obs;

  late final TabController tabController =
      TabController(length: 2, vsync: this);

  void onChangeAccount(String? username) {
    selectedAccount(username);
  }

  static WalletsController get to => Get.find();

  final localDataService = Get.find<LocalDataService>();
  final steemService = Get.find<SteemService>();

  /// account 잔액 정보를 가져온다.
  void loadAccountDetails(username) async {
    print(username);
    change(null, status: RxStatus.loading());
    // final data = await steemService.;
    try {
      final globalProperties = await steemService.getDynamicGlobalProperties();
      final data = await steemService.getAccount(username);
      if (data != null) {
        // steem power 계산
        final totalVestingShares =
            double.parse(globalProperties.total_vesting_shares.split(' ')[0]);
        final totalVestingFundSteem = double.parse(
            globalProperties.total_vesting_fund_steem.split(' ')[0]);
        final vestingShares = double.parse(data.vesting_shares.split(' ')[0]);
        final steemPower =
            vestingShares / totalVestingShares * totalVestingFundSteem;

        // 보팅 파워 계산
        final elapsedSeconds = (DateTime.now().millisecondsSinceEpoch -
                DateTime.parse('${data.last_vote_time}Z')
                    .millisecondsSinceEpoch) /
            1000; // 마지막 보팅 후 경과 시간
        final regeneratedPower = (10000 * elapsedSeconds) / (60 * 60 * 24 * 5);
        final currentVotingPower = math
            .min(data.voting_power + regeneratedPower, 10000)
            .round(); // 현재 보팅파워 // 재생된 보팅파워

        // RC 계산
        final manabar = await steemService.getRCMana(username);

        final _account = Account(
          name: data.name,
          steemBalance: double.parse(data.balance.split(' ')[0]),
          sbdBalance: double.parse(data.sbd_balance.split(' ')[0]),
          steemPower: steemPower,
          votingPower: currentVotingPower / 100,
          resourceCredits: manabar!.percentage / 100,
        );
        change(_account, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  @override
  Future<void> onInit() async {
    // selectedAccount.firstRebuild = false;
    ever<String>(selectedAccount, loadAccountDetails);

    final _accounts = (await localDataService.getAccounts())
        .map((account) => account.name)
        .toList();
    if (_accounts.isNotEmpty) {
      accounts.assignAll(_accounts);
      selectedAccount(_accounts[0]);
    }

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
