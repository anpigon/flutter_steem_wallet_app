import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/wallet.dart';
import '../../../services/local_data_service.dart';
import '../../../services/steem_service.dart';
import '../../../data/price_provider.dart';

class MarketPrice {
  double price;
  double change;
  MarketPrice(this.price, this.change);
}

class WalletsController extends GetxController
    with StateMixin<Wallet>, SingleGetTickerProviderMixin {
  final accounts = <String>[].obs;
  final selectedAccount = ''.obs;

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
  void loadAccountDetails(String username) async {
    change(null, status: RxStatus.loading());

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

        final wallet = Wallet(
          name: data.name,
          steemBalance: double.parse(data.balance.split(' ')[0]),
          sbdBalance: double.parse(data.sbd_balance.split(' ')[0]),
          steemPower: steemPower,
          votingPower: currentVotingPower / 100,
          resourceCredits: currentResourceCredits / 100,
        );
        print(5);
        change(wallet, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      e.printError();
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void updateMatketPrice() {
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

    updateMatketPrice();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
