import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/exceptions/message_exception.dart';
import 'package:flutter_steem_wallet_app/app/services/vault_service.dart';
import 'package:flutter_steem_wallet_app/app/utils/ui_util.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../logger.dart';
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

class AppController extends GetxController
    with StateMixin<Wallet>, SingleGetTickerProviderMixin {
  late final LocalDataService localDataService;
  late final SteemService steemService;

  final accounts = <String>[].obs;
  final selectedAccount = ''.obs;

  final loading = false.obs;
  final wallet = Wallet().obs;

  final steemMarketPrice = MarketPrice(0, 0).obs;
  final sbdMarketPrice = MarketPrice(0, 0).obs;

  static AppController get to => Get.find();

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
  Future<void> loadAccountDetails(String username,
      [bool showLoader = true]) async {
    if (!accounts.contains(username)) {
      accounts.add(username);
      selectedAccount(username);
    }

    try {
      if (showLoader) loading(true);
      change(null, status: RxStatus.loading());

      final data = await steemService.loadAccountDetails(username);
      if (data == null) throw MessageException('wallet is empty');
      wallet.update((val) {
        val!.update(data);
      });

      change(data, status: RxStatus.success());
    } on Exception catch (e, stackTrace) {
      stackTrace.printError();
      Get.snackbar(
        'ERROR',
        e.toString(),
        backgroundColor: Get.theme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      if (showLoader) loading(false);
    }
  }

  /// account 정보 갱신
  Future<void> reload([bool showLoader = true]) async {
    await loadAccountDetails(selectedAccount.value, showLoader);
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

  Future<void> claimRewardBalance() async {
    try {
      await SteemService.to.claimRewardBalance(wallet.value);
      await reload(false);
    } on MessageException catch (ex) {
      UIUtil.showErrorMessage(ex.message);
    } catch (ex, stackTrace) {
      Log.e(ex);
      await Sentry.captureException(ex, stackTrace: stackTrace);
      UIUtil.showErrorMessage('error_unknown'.tr);
    }
  }

  @override
  Future<void> onInit() async {
    localDataService = Get.find<LocalDataService>();
    steemService = Get.find<SteemService>();

    ever<String>(selectedAccount, loadAccountDetails);

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
