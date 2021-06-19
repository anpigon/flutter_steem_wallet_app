import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/models/signature/withdraw_vesting.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_utils.dart';
import 'package:flutter_steem_wallet_app/app/views/dialog/signature_confirm_dialog.dart';
import 'package:get/get.dart';

import '../../../../logger.dart';
import '../../../exceptions/message_exception.dart';
import '../../../services/local_data_service.dart';
import '../../../services/steem_service.dart';
import '../../../services/vault_service.dart';

class PowerDownController extends GetxController {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController amountController;

  late final _ownerUsername;
  late final loading = false.obs;

  late final AppController appController;

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
      final steemPower = appController.wallet().steemPower;
      if (amount.isGreaterThan(steemPower)) {
        return '잔액이 부족합니다.';
      }
    } catch (error) {
      logger.e(error);
      return 'Invalid amount!';
    }
    return null;
  }

  void setRatioAmount(double ratio) {
    final steemPower = appController.wallet().steemPower;
    amountController.text = toFixedTrunc(steemPower * ratio, 3);
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

      final globalProperties =
          await SteemService.to.getDynamicGlobalProperties();
      final totalVestingShares =
          double.parse(globalProperties.total_vesting_shares.split(' ')[0]);
      final totalVestingFundSteem =
          double.parse(globalProperties.total_vesting_fund_steem.split(' ')[0]);

      final vestingShares = amount / totalVestingFundSteem * totalVestingShares;

      // 서명 데이터 확인 다이얼로그
      final _withdrawVesting = WithdrawVesting(
        account: _ownerUsername,
        vesting_shares: vestingShares,
      );
      final result = await SignatureConfirmDialog.show(
        SignatureType.withdrawVesting,
        _withdrawVesting,
      );

      // 서명 및 전송
      if (result == true) {
        final ownerAccount =
            await LocalDataService.to.getAccount(_ownerUsername);
        if (ownerAccount == null) {
          throw MessageException('Account not found in local db.');
        }

        final _activeKey =
            await VaultService.to.read(ownerAccount.activePublicKey!);
        if (_activeKey == null) {
          throw MessageException('액티브 키가 필요합니다.');
        }

        // 서명 및 송금
        await SteemService.to.powerDown(_withdrawVesting, _activeKey);
        await AppController.to.reload();

        showSuccessMessage('파워 다운이 시작되었습니다.');
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
    formKey = GlobalKey<FormState>();
    amountController = TextEditingController();

    appController = AppController.to;

    final arguments = Get.arguments;
    _ownerUsername = arguments['account'];

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
