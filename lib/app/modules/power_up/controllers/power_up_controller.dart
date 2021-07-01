import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/views/dialog/signature_confirm_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  final amountFormat = NumberFormat('##0.0##', 'en_US');

  late final _ownerUsername;
  late final loading = false.obs;
  late final enabledEditUsername = false.obs;

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
      final steemBalance = appController.wallet().steemBalance;
      if (amount.isGreaterThan(steemBalance)) {
        return '잔액이 부족합니다.';
      }
    } catch (error) {
      logger.e(error);
      return 'Invalid amount!';
    }
    return null;
  }

  void setRatioAmount(double ratio) {
    final steemBalance = appController.wallet().steemBalance;
    amountController.text = amountFormat.format(steemBalance * ratio);
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

      // 서명 데이터 확인 다이얼로그
      final amount = double.parse(amountController.text.trim());
      final _transferToVesting = TransferToVesting(
        from: _ownerUsername,
        to: receivingUsername,
        amount: amount,
      );
      final result = await SignatureConfirmDialog.show(
        SignatureType.transferToVesting,
        _transferToVesting,
      );

      // 서명 및 전송
      if (result == true) {
        final ownerAccount = await LocalDataService.to.getAccount(_ownerUsername);
        if (ownerAccount == null) {
          throw MessageException('Account not found in local db.');
        }

        final _activeKey =
            await VaultService.to.read(ownerAccount.activePublicKey!);
        if (_activeKey == null) {
          throw MessageException('액티브 키가 필요합니다.');
        }

        // 서명 및 송금
        await SteemService.to.powerUp(_transferToVesting, _activeKey);
        await appController.reload();

        showSuccessMessage('파워업에 성공하였습니다.');
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

    appController = AppController.to;

    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    amountController = TextEditingController();
    usernameFocusNode = FocusNode();

    _ownerUsername = arguments['account'];
    // usernameController.text = _ownerUsername;

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
