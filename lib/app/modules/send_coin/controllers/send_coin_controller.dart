import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controller/wallets_controller.dart';
import 'package:get/get.dart';

import '../../../../logger.dart';
import '../../../constants.dart';
import '../../../exceptions/message_exception.dart';
import '../../../models/signature/transfer.dart';
import '../../../services/local_data_service.dart';
import '../../../services/steem_service.dart';
import '../../../services/vault_service.dart';
import '../../../views/dialog/signature_confirm_dialog.dart';

class SendCoinController extends GetxController {
  late final formKey = GlobalKey<FormState>();
  late final usernameController = TextEditingController();
  late final amountController = TextEditingController();
  late final memoController = TextEditingController();

  late final _ownerUsername;
  final symbol = Symbols.STEEM.obs;
  final loading = false.obs;

  late final WalletsController walletsController;

  /// 잔액 조회
  double get balance {
    switch (symbol()) {
      case Symbols.STEEM:
        return walletsController.wallet().steemBalance;
      case Symbols.SBD:
        return walletsController.wallet().sbdBalance;
      default:
        return 0;
    }
  }

  /// 유효성 체크
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
    try {
      final amount = double.parse(value);
      if (amount.isLowerThan(0.001)) {
        return 'Invalid amount!';
      }
      if (amount.isGreaterThan(balance)) {
        return '잔액이 부족합니다.';
      }
    } catch (error) {
      logger.e(error);
      return 'Invalid amount!';
    }
    return null;
  }

  /// 전송
  Future<void> submit() async {
    // 입력값 유효성 체크
    if (!formKey.currentState!.validate()) {
      return;
    }

    // 소프트 키보드 숨김
    final currentFocus = FocusScope.of(Get.overlayContext!);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      currentFocus.requestFocus(FocusNode());
    }

    loading(true);
    try {
      // account 존재하는지 여부 체크
      final receivingUsername = usernameController.text.trim();
      final data = await SteemService.to.getAccount(receivingUsername);
      if (data == null) {
        throw MessageException('Account not found');
      }

      // 서명 데이터 확인
      final amount = amountController.text.trim();
      final memo = memoController.text.trim();
      final _transferData = Transfer(
        from: _ownerUsername,
        to: receivingUsername,
        amount: double.parse(amount),
        symbol: symbol.value,
        memo: memo,
      );
      final result = await SignatureConfirmDialog.show(
        SignatureType.TRANSFER,
        _transferData,
      );

      // 서명 및 전송
      if (result == true) {
        final ownerAccount =
            await LocalDataService.to.getAccount(_ownerUsername);
        if (ownerAccount == null) {
          throw MessageException('Account not found in local db.');
        }

        // TODO: PIN 번호 입력

        final _activeKey =
            await VaultService.to.read(ownerAccount.activePublicKey!);
        if (_activeKey == null) {
          throw MessageException('액티브 키가 필요합니다.');
        }

        // 서명 및 송금
        await SteemService.to.transfer(_transferData, _activeKey);

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

  @override
  void onInit() {
    final arguments = Get.arguments;
    print('arguments: $arguments');

    walletsController = Get.find<WalletsController>();

    _ownerUsername = arguments['account'];
    symbol(arguments['symbol']);

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
