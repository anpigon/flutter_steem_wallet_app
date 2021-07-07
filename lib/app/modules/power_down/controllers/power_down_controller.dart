import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/models/signature/withdraw_vesting.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_util.dart';
import 'package:flutter_steem_wallet_app/app/utils/ui_util.dart';
import 'package:flutter_steem_wallet_app/app/views/dialog/signature_confirm_dialog.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../logger.dart';
import '../../../exceptions/message_exception.dart';
import '../../../services/local_data_service.dart';
import '../../../services/steem_service.dart';
import '../../../services/vault_service.dart';

class PowerDownController extends GetxController {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController amountController;

  late final String _ownerUsername;
  late final loading = false.obs;

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
      final steemPower = AppController.to.wallet().steemPower;
      if (amount.isGreaterThan(steemPower)) {
        return '잔액이 부족합니다.';
      }
    } catch (error, stackTrace) {
      logger.e(stackTrace);
      Sentry.captureException(error, stackTrace: stackTrace);
      return 'Invalid amount!';
    }
    return null;
  }

  void setRatioAmount(double ratio) {
    final wallet = AppController.to.wallet();
    final steemPower = wallet.steemPower;
    final delegatedSteemPower = wallet.delegatedSteemPower;
    final availableSteemPower = steemPower - delegatedSteemPower;
    amountController.text =
        NumUtil.toAmountFormat(max(availableSteemPower * ratio, 0.001));
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // 소프트 키보드 감추기
    final currentFocus = FocusScope.of(Get.overlayContext!);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      currentFocus.requestFocus(FocusNode());
    }

    loading(true);
    try {
      final amount = double.parse(amountController.text.trim());
      final vestingShares = await SteemService.to.calculateSteemToVest(amount);

      // 서명 데이터 생성
      final withdrawVesting = WithdrawVesting(
        account: _ownerUsername,
        vesting_shares: vestingShares,
      );

      // 서명 동의 확인 다이얼로그
      final result = await SignatureConfirmDialog.show(
        SignatureType.withdrawVesting,
        withdrawVesting,
      );

      // 서명 및 전송
      if (result == true) {
        final ownerAccount =
            await LocalDataService.to.getAccount(_ownerUsername);

        // TODO: PIN 번호 입력

        final privateKey =
            await VaultService.to.read(ownerAccount.activePublicKey!);
        if (privateKey == null) {
          throw MessageException('파워다운에는 액티브 키가 필요합니다.');
        }

        // 서명 및 송금
        await SteemService.to.powerDown(withdrawVesting, privateKey);
        await AppController.to.reload();

        UIUtil.showSuccessMessage('파워 다운이 시작되었습니다.');
        Get.back(result: true);
      }
    } on MessageException catch (error) {
      UIUtil.showErrorMessage(error.message);
    } catch (error, stackTrace) {
      logger.e(stackTrace);
      await Sentry.captureException(error, stackTrace: stackTrace);
      UIUtil.showErrorMessage(error.toString());
    } finally {
      loading(false);
    }
  }

  @override
  void onInit() {
    // init
    formKey = GlobalKey<FormState>();
    amountController = TextEditingController();

    // set arguments
    final arguments = Get.arguments;
    _ownerUsername = arguments['account'].toString();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
