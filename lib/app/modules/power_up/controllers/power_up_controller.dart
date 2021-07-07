import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_util.dart';
import 'package:flutter_steem_wallet_app/app/utils/ui_util.dart';
import 'package:flutter_steem_wallet_app/app/views/dialog/signature_confirm_dialog.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../logger.dart';
import '../../../exceptions/message_exception.dart';
import '../../../models/signature/transfer_to_vesting.dart';
import '../../../services/local_data_service.dart';
import '../../../services/steem_service.dart';
import '../../../services/vault_service.dart';

class PowerUpController extends GetxController {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController usernameController;
  late final TextEditingController amountController;
  late final FocusNode usernameFocusNode;

  

  late final String _ownerUsername;
  final loading = false.obs;
  final enabledEditUsername = false.obs;

  /// username 유효성 체크
  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty || value.length <= 3) {
      return 'Invalid username!';
    }
    return null;
  }

  /// amount 유효성 체크
  String? amountValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invalid amount!';
    }
    try {
      final amount = double.parse(value);
      if (amount.isLowerThan(0.001)) {
        return 'Invalid amount!';
      }
      final steemBalance = AppController.to.wallet().steemBalance;
      if (amount.isGreaterThan(steemBalance)) {
        return '잔액이 부족합니다.';
      }
    } catch (error, stackTrace) {
      Log.e(error, stackTrace);
      Sentry.captureException(error, stackTrace: stackTrace);
      return 'Invalid amount!';
    }
    return null;
  }

  void setRatioAmount(double ratio) {
    final steemBalance = AppController.to.wallet().steemBalance;
    amountController.text = NumUtil.toAmountFormat(max(steemBalance * ratio, 0.001));
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
      // account 존재하는지 여부 체크
      final recipientUsername = usernameController.text.trim();
      final data = await SteemService.to.getAccount(recipientUsername);
      if (data == null) {
        throw MessageException('Account not found');
      }

      // 서명 데이터 생성
      final amount = double.parse(amountController.text.trim());
      final transferToVesting = TransferToVesting(
        from: _ownerUsername,
        to: recipientUsername,
        amount: amount,
      );

      // 서명 동의 확인 다이얼로그
      final result = await SignatureConfirmDialog.show(
        SignatureType.transferToVesting,
        transferToVesting,
      );

      // 서명 및 전송
      if (result == true) {
        final ownerAccount =
            await LocalDataService.to.getAccount(_ownerUsername);

        // TODO: PIN 번호 입력

        final privateKey =
            await VaultService.to.read(ownerAccount.activePublicKey!);
        if (privateKey == null) {
          throw MessageException('파워업에는 액티브 키가 필요합니다.');
        }

        // 서명 및 송금
        await SteemService.to.powerUp(transferToVesting, privateKey);
        await AppController.to.reload();

        UIUtil.showSuccessMessage('파워업에 성공하였습니다.');
        Get.back(result: true);
      }
    } on MessageException catch (error) {
      UIUtil.showErrorMessage(error.message);
    } catch (error, stackTrace) {
      Log.e(error, stackTrace);
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
    usernameController = TextEditingController();
    amountController = TextEditingController();
    usernameFocusNode = FocusNode();

    // set arguments
    final arguments = Get.arguments;
    _ownerUsername = arguments['account'].toString();
    usernameController.text = _ownerUsername;

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
    usernameFocusNode.dispose();

    super.onClose();
  }
}
