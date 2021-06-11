import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:steemdart_ecc/steemdart_ecc.dart' as steem;

import '../../../exceptions/message_exception.dart';
import '../../../services/steem_service.dart';

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

class SendCoinController extends GetxController {
  late final formKey = GlobalKey<FormState>();
  late final usernameController = TextEditingController();
  late final amountController = TextEditingController();
  late final memoController = TextEditingController();

  final balances = Balances().obs;
  final ready = false.obs;
  final symbol = 'STEEM'.obs;
  final loading = false.obs;

  double get amount {
    return balances().get(symbol());
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

      // showSuccessMessage('송금에 성공하였습니다.');
      Get.back(result: true);
    } on MessageException catch (error) {
      showErrorMessage(error.message);
    } catch (error) {
      print(error.toString());
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

  void showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.green.shade700,
    );
  }

  Future<void> getBalance() async {
    final arguments = Get.arguments;
    print('arguments: $arguments');

    symbol(arguments['symbol']);

    // 계정 잔액 조회
    final data = await SteemService.to.getAccount(arguments['account']);
    if (data != null) {
      balances.update((val) {
        val!.steem = steem.Asset.from(data.balance).amount;
        val.sbd = steem.Asset.from(data.sbd_balance).amount;
        val.isDone = true;
      });
    }
  }

  @override
  void onInit() {
    getBalance();

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
