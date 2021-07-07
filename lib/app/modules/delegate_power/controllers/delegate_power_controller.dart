import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/exceptions/message_exception.dart';
import 'package:flutter_steem_wallet_app/app/models/signature/delegate_vesting_shares.dart';
import 'package:flutter_steem_wallet_app/app/services/local_data_service.dart';
import 'package:flutter_steem_wallet_app/app/services/steem_service.dart';
import 'package:flutter_steem_wallet_app/app/services/vault_service.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_util.dart';
import 'package:flutter_steem_wallet_app/app/utils/ui_util.dart';
import 'package:flutter_steem_wallet_app/app/views/dialog/signature_confirm_dialog.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../logger.dart';

class DelegatePowerController extends GetxController {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController usernameController;
  late final TextEditingController amountController;
  late final FocusNode usernameFocusNode;

  late final _ownerUsername;
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
      final steemBalance = AppController.to.wallet().steemBalance;
      if (amount.isGreaterThan(steemBalance)) {
        return '잔액이 부족합니다.';
      }
    } catch (error, stackTrace) {
      logger.e(error);
      Sentry.captureException(error, stackTrace: stackTrace);
      return 'Invalid amount!';
    }
    return null;
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
      final receivingUsername = usernameController.text.trim();
      final data = await SteemService.to.getAccount(receivingUsername);
      if (data == null) {
        throw MessageException('Account not found');
      }

      final globalProperties =
          await SteemService.to.getDynamicGlobalProperties();
      final amount = double.parse(amountController.text.trim());
      final vestingShares = NumUtil.calculateSteemToVest(
        amount,
        globalProperties.total_vesting_shares,
        globalProperties.total_vesting_fund_steem,
      );

      final _delegateVestingShares = DelegateVestingShares(
        delegatee: _ownerUsername,
        delegator: receivingUsername,
        vesting_shares: vestingShares,
      );

      // 서명 데이터 확인 다이얼로그
      final result = await SignatureConfirmDialog.show(
        SignatureType.delegateVestingShares,
        _delegateVestingShares,
      );

      // 서명 및 전송
      if (result == true) {
        final ownerAccount =
            await LocalDataService.to.getAccount(_ownerUsername);
        
        final _activeKey =
            await VaultService.to.read(ownerAccount.activePublicKey!);
        if (_activeKey == null) {
          throw MessageException('서명에는 액티브 키가 필요합니다.');
        }

        // 서명 및 송금
        await SteemService.to.delegate(_delegateVestingShares, _activeKey);
        await AppController.to.reload();

        UIUtil.showSuccessMessage('파워업에 성공하였습니다.');
        Get.back(result: true);
      }
    } on MessageException catch (error) {
      UIUtil.showErrorMessage(error.message);
    } catch (error, stackTrace) {
      logger.e(error, stackTrace);
      await Sentry.captureException(error, stackTrace: stackTrace);
      UIUtil.showErrorMessage(error.toString());
    } finally {
      loading(false);
    }
  }

  @override
  void onInit() {

    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    amountController = TextEditingController();
    usernameFocusNode = FocusNode();

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
    usernameController.dispose();
    amountController.dispose();
    usernameFocusNode.dispose();
    super.onClose();
  }
}
