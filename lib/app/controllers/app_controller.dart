import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_utils.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../data/price_provider.dart';
import '../models/wallet.dart';
import '../routes/app_pages.dart';
import '../services/local_data_service.dart';
import '../services/steem_service.dart';

/// 시장 가격
class MarketPrice {
  double price;
  double change;

  MarketPrice(this.price, this.change);
}

class AppController extends GetxController with SingleGetTickerProviderMixin {
  late final LocalDataService localDataService;
  late final SteemService steemService;

  final accounts = <String>[].obs;
  final selectedAccount = ''.obs;

  final loading = false.obs;
  final wallet = Wallet().obs;

  final steemMarketPrice = MarketPrice(0, 0).obs;
  final sbdMarketPrice = MarketPrice(0, 0).obs;

  static AppController get to => Get.find();

  late final StreamController<String> loadAccountCtrl;
  late final StreamSubscription<String> loadAccountSub;

  MarketPrice marketPrice(String symbol) {
    if (symbol == Symbols.STEEM) {
      return steemMarketPrice();
    } else if (symbol == Symbols.SBD) {
      return sbdMarketPrice();
    }
    return MarketPrice(0, 0);
  }

  /// account 선택
  void onChangeAccount(String? username) {
    selectedAccount(username);
    update(['selectedAccount']);
  }

  /// account 잔액 정보를 가져온다.
  Future<void> loadAccountDetails(String username) async {
    print(username);
    loading(true);

    if (!accounts.contains(username)) {
      accounts.add(username);
      selectedAccount(username);
    }

    try {
      final globalProperties = await steemService.getDynamicGlobalProperties();
      final data = await steemService.getAccount(username);
      if (data != null) {
        // steem power 계산
        final steemPower = calculateVestToSteem(
          data.vesting_shares,
          globalProperties.total_vesting_shares,
          globalProperties.total_vesting_fund_steem,
        );

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
          val.toWithdraw = calculateVestToSteem(
                data.to_withdraw,
                globalProperties.total_vesting_shares,
                globalProperties.total_vesting_fund_steem,
              ) /
              1e6;
          val.withdrawn = calculateVestToSteem(
                data.withdrawn,
                globalProperties.total_vesting_shares,
                globalProperties.total_vesting_fund_steem,
              ) /
              1e6;
          val.delegatedSteemPower = calculateVestToSteem(
            data.delegated_vesting_shares,
            globalProperties.total_vesting_shares,
            globalProperties.total_vesting_fund_steem,
          );
          val.receivedSteemPower = calculateVestToSteem(
            data.received_vesting_shares,
            globalProperties.total_vesting_shares,
            globalProperties.total_vesting_fund_steem,
          );
          val.nextSteemPowerWithdrawRate = calculateVestToSteem(
            data.vesting_withdraw_rate,
            globalProperties.total_vesting_shares,
            globalProperties.total_vesting_fund_steem,
          );
          val.nextSteemPowerWithdrawal =
              DateTime.parse('${data.next_vesting_withdrawal}Z');
        });
      }
    } on Exception catch (e, stackTrace) {
      stackTrace.printError();
      Get.snackbar(
        'ERROR',
        e.toString(),
        backgroundColor: Get.theme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      loading(false);
    }
  }

  /// account 정보 갱신
  Future<void> reload() async {
    await loadAccountDetails(selectedAccount.value);
  }

  /// 시장 가격을 조회한다.
  Future<void> updateMarketPrice() async {
    try {
      final value = await PriceProvider.to.getQuotesLatest(['STEEM', 'SBD']);
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
    } catch (error) {
      Get.snackbar(
        'ERROR',
        error.toString(),
        backgroundColor: Get.theme.errorColor,
        colorText: Colors.white,
      );
    }
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

    loadAccountCtrl = StreamController<String>();
    loadAccountSub = loadAccountCtrl.stream.listen(
      (String account) {
        print('listen: $account');
        loadAccountDetails(account);
      },
      // cancelOnError: false,
      onError: ((error) {
        print('onError: ${error.toString()}');
      }),
      onDone: (() {
        print('onDone');
      }),
    );

    ever<String>(selectedAccount, (account) {
      print('$account: ${loading.value}');
      if (loading.value) {
        loadAccountSub.cancel();
      }
      loadAccountCtrl.add(account);
    });

    final accountList = (await localDataService.getAccounts())
        .map((account) => account.name)
        .toList();
    if (accountList.isNotEmpty) {
      accounts.assignAll(accountList);
      selectedAccount(accountList.first);
    }

    await updateMarketPrice();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
