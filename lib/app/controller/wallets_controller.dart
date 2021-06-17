import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
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
  late final LocalDataService localDataService;
  late final SteemService steemService;
  late final PriceProvider priceProvider;

  final accounts = <String>[].obs;
  final selectedAccount = ''.obs;

  final loading = false.obs;
  final wallet = Wallet().obs;

  final steemMarketPrice = MarketPrice(0, 0).obs;
  final sbdMarketPrice = MarketPrice(0, 0).obs;

  static WalletsController get to => Get.find();

  MarketPrice marketPrice(String symbol) {
    if (symbol == Symbols.STEEM) {
      return steemMarketPrice();
    } else if (symbol == Symbols.SBD) {
      return sbdMarketPrice();
    }
    return MarketPrice(0, 0);
  }

  /// TODO: AppController 로 옮길 것
  late final TabController tabController =
      TabController(length: 2, vsync: this);

  /// account 선택
  void onChangeAccount(String? username) {
    selectedAccount(username);
  }

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

  /// account 정보 갱신
  Future<void> reload() async {
    await loadAccountDetails(selectedAccount.value);
  }

  /// 시장 가격을 조회한다.
  void updateMarketPrice() {
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
    if (newAccount != null && !newAccount.isEmpty) {
      accounts.add(newAccount);
    }
  }

  @override
  Future<void> onInit() async {
    localDataService = Get.find<LocalDataService>();
    steemService = Get.find<SteemService>();
    priceProvider = Get.put(PriceProvider());

    // selectedAccount.firstRebuild = false;
    interval<String>(selectedAccount, loadAccountDetails);

    final accountList = (await localDataService.getAccounts())
        .map((account) => account.name)
        .toList();
    if (accountList.isNotEmpty) {
      accounts.assignAll(accountList);
      selectedAccount(accountList.first);
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
