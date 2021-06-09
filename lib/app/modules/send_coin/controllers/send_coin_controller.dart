import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steemdart_ecc/steemdart_ecc.dart' as steem;

import '../../../exceptions/message_exception.dart';
import '../../../services/steem_service.dart';

class Balances {
  final loading = true.obs;
  final balances = <String, double>{'STEEM': 0.0, 'SBD': 0.0}.obs;

  double get(String symbol) {
    return balances[symbol] ?? 0.0;
  }

  void set(steem.Account data) {
    balances['STEEM'] = double.parse(data!.balance.split(' ')[0]);
    balances['SBD'] = double.parse(data.sbd_balance.split(' ')[0]);
    loading(false);
  }
}

class SendCoinController extends GetxController {
  late final formKey = GlobalKey<FormState>();
  late final usernameController = TextEditingController();
  late final amountController = TextEditingController();
  late final memoController = TextEditingController();

  final symbol = 'STEEM'.obs;
  final loading = true.obs;
  final balances = Balances();

  double get amount {
    return balances.get(symbol());
  }

  void onChangedSymbol(String? value) {
    symbol(value);
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty || value.length <= 3) {
      return 'Invalid username!';
    }
    return null;
  }

  String? amountValidator(String? value) {
    print(value);
    if (value == null || value.isEmpty) {
      return 'Invalid amount!';
    }
    final _amount = double.parse(value);
    if (!_amount.isGreaterThan(0.0)) {
      return 'Invalid amount!';
    }
    ;
    if (_amount.isGreaterThan(amount)) {
      return '잔액이 부족합니다.';
    }
    return null;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final currentFocus = FocusScope.of(Get.overlayContext!);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    loading(true);

    try {
      // account 존재하는지 여부 체크
      final username = usernameController.text;
      final data = await SteemService.to.getAccount(username);
      if (data == null) {
        throw MessageException('Account not found');
      }

      // Get.back(result: true);
    } on MessageException catch (error) {
      showErrorMessage(error.message);
    } catch (error) {
      showErrorMessage(error.toString());
    } finally {
      loading(false);
    }
  }

  void showErrorMessage(String message) {
    Get.snackbar(
      'ERROR',
      message,
      backgroundColor: Get.theme.errorColor,
      colorText: Colors.white,
    );
  }

  @override
  void onInit() async {
    final arguments = Get.arguments;
    final data = await SteemService.to.getAccount(arguments['account']());
    // balance['STEEM'] = double.parse(data!.balance.split(' ')[0]);
    // balance['SBD'] = double.parse(data.sbd_balance.split(' ')[0]);
    // loading(false);
    balances.set(data!);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
