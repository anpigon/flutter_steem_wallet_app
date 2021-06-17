import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/price_provider.dart';
import '../models/wallet.dart';
import '../routes/app_pages.dart';
import '../services/local_data_service.dart';
import '../services/steem_service.dart';

/// 잔액
class Balances {
  double steem;
  double sbd;
  bool isDone;

  double get(String symbol) {
    switch (symbol) {
      case 'STEEM':
        return steem;
      case 'SBD':
        return sbd;
      default:
        return 0.0;
    }
  }

  Balances({this.steem = 0.0, this.sbd = 0.0, this.isDone = false});
}

/// 시장 가격
class MarketPrice {
  double price;
  double change;

  MarketPrice(this.price, this.change);
}

class WalletsController extends GetxController
    with StateMixin<Wallet>, SingleGetTickerProviderMixin {
  final accounts = <String>[].obs;
  final selectedAccount = ''.obs;

  final loading = false.obs;
  final wallet = Wallet().obs;

  final steemMarketPrice = MarketPrice(0, 0).obs;
  final sbdMarketPrice = MarketPrice(0, 0).obs;

  MarketPrice marketPrice(String symbol) {
    if (symbol == 'STEEM') {
      return steemMarketPrice();
    }
    return sbdMarketPrice();
  }

  late final TabController tabController =
      TabController(length: 2, vsync: this);

  void onChangeAccount(String? username) {
    selectedAccount(username);
  }

  static WalletsController get to => Get.find();

  final localDataService = Get.find<LocalDataService>();
  final steemService = Get.find<SteemService>();
  final priceProvider = Get.put<PriceProvider>(PriceProvider());

  /// account 잔액 정보를 가져온다.
  Future<void> loadAccountDetails(String username) async {
    loading(true);

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
        final currentVotingPower =
            steemService.calculateVPMana(data).percentage;

        // RC 계산
        final currentResourceCredits =
            (await steemService.getRCMana(username)).percentage;

        wallet.update((val) {
          val!.name = data.name;
          val.steemBalance = double.parse(data.balance.split(' ')[0]);
          val.sbdBalance = double.parse(data.sbd_balance.split(' ')[0]);
          val.steemPower = steemPower;
          val.votingPower = currentVotingPower / 100;
          val.resourceCredits = currentResourceCredits / 100;
        });
      }
    } catch (e) {
      e.printError();
      change(null, status: RxStatus.error(e.toString()));
    } finally {
      loading(false);
    }
  }

  Future<void> reload() async {
    await loadAccountDetails(selectedAccount.value);
  }

  void updateMarketPrice() {
    // 시장 가격 조회
    priceProvider.getQuotesLatest(['STEEM', 'SBD']).then((value) {
      final steem = value.items['STEEM']!.quote.usd;
      final sbd = value.items['SBD']!.quote.usd;
      steemMarketPrice.update((val) {
        val!.price = steem.price;
        val.change = steem.percentChange1H;
      });
      sbdMarketPrice.update((val) {
        val!.price = sbd.price;
        val.change = sbd.percentChange1H;
      });
    });
  }

  /// 새로운 계정 추가
  Future<void> goAddAccount() async {
    final newAccount = await Get.toNamed(Routes.ADD_ACCOUNT);
    if (!newAccount.isEmpty) {
      accounts.add(newAccount);
    }
  }

  void goSendCoin({String symbol = 'STEEM'}) {
    Get.toNamed(Routes.SEND_COIN, arguments: {
      'account': selectedAccount.value,
      'symbol': symbol,
    });
  }

  void goPowerUp() {
    Get.toNamed(Routes.POWER_UP, arguments: {
      'account': selectedAccount.value,
    });
  }

  void goPowerDown() {
    Get.toNamed(Routes.POWER_DOWN, arguments: {
      'account': selectedAccount.value,
    });
  }

  @override
  Future<void> onInit() async {
    // selectedAccount.firstRebuild = false;
    interval<String>(selectedAccount, loadAccountDetails);

    final _accounts = (await localDataService.getAccounts())
        .map((account) => account.name)
        .toList();
    if (_accounts.isNotEmpty) {
      accounts.assignAll(_accounts);
      selectedAccount(_accounts[0]);
    }

    updateMarketPrice();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
