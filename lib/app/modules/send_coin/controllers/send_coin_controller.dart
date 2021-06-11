import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/services/local_data_service.dart';
import 'package:get/get.dart';
import 'package:steemdart_ecc/steemdart_ecc.dart' as steem;

import '../../../../logger.dart';
import '../../../models/transfer.dart';
import '../../../services/vault_service.dart';
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

  late final _owner;
  final balances = Balances().obs;
  final ready = false.obs;
  final symbol = 'STEEM'.obs;
  final loading = false.obs;

  double get balance {
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
    if (value == null || value.isEmpty) {
      return 'Invalid amount!';
    }
    final _amount = double.parse(value);
    if (!_amount.isGreaterThan(0.0)) {
      return 'Invalid amount!';
    }
    ;
    if (_amount.isGreaterThan(balance)) {
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

      // TODO: 액티브 키가 있는지 체크

      FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());

      final _amount = amountController.text;
      final _memo = memoController.text;
      final _transferData = Transfer(
        from: _owner,
        to: username,
        amount: double.parse(_amount),
        symbol: symbol.value,
        memo: _memo,
      );
      final result = await Get.dialog(
        AlertDialog(
          title: Text('Signature'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.grey.shade50,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    _transferData.toPrettyJson(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '서명 내용을 확인해주세요.\n실행 후에는 취소할 수 없습니다.',
                style: Get.theme.textTheme.caption,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('Sign'),
            ),
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancel'),
            ),
          ],
        ),
      );
      print(result);

      if (result == true) {
        final _account = await LocalDataService.to.getAccount(_owner);
        if (_account == null) {
          throw MessageException('Account not found in local db.');
        }

        final _key = await VaultService.to.read(_account.activePublicKey!);
        if (_key == null) {
          throw MessageException('액티브 키가 필요합니다.');
        }

        logger.d('key: $_key');
        logger.d('tx: ${_transferData.toJson()}');

        // 서명 및 송금
        await SteemService.to.transfer(_transferData, _key);

        logger.d('success');
        showSuccessMessage('송금에 성공하였습니다.');
        Get.back(result: true);
      }
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
    ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        duration: Duration(milliseconds: 2000),
      ),
    );
  }

  Future<void> getBalance() async {
    // 계정 잔액 조회
    final data = await SteemService.to.getAccount(_owner);
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
    final arguments = Get.arguments;
    print('arguments: $arguments');

    _owner = arguments['account'];
    symbol(arguments['symbol']);

    getBalance();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    usernameController.dispose();
    amountController.dispose();
    memoController.dispose();
    super.onClose();
  }
}
