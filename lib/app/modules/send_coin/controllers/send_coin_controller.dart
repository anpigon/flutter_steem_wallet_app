import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/utils/ui_util.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../logger.dart';
import '../../../constants.dart';
import '../../../exceptions/message_exception.dart';
import '../../../models/signature/transfer.dart';
import '../../../services/local_data_service.dart';
import '../../../services/steem_service.dart';
import '../../../services/vault_service.dart';
import '../../../views/dialog/signature_confirm_dialog.dart';

class SendCoinController extends GetxController {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController usernameController;
  late final TextEditingController amountController;
  late final TextEditingController memoController;

  late final String _ownerUsername;
  final symbol = Symbols.STEEM.obs;
  final loading = false.obs;

  /// 잔액 조회
  double get balance {
    switch (symbol.value) {
      case Symbols.STEEM:
        return AppController.to.wallet().steemBalance;
      case Symbols.SBD:
        return AppController.to.wallet().sbdBalance;
      default:
        return 0;
    }
  }

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
    if (Get.focusScope?.hasPrimaryFocus == true) {
      Get.focusScope?.unfocus();
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
      final memo = memoController.text.trim();
      final transferData = Transfer(
        from: _ownerUsername,
        to: recipientUsername,
        amount: amount,
        symbol: symbol.value,
        memo: memo,
      );

      // 서명 동의 확인 다이얼로그
      final result = await SignatureConfirmDialog.show(
        SignatureType.transfer,
        transferData,
      );

      // 서명 및 전송
      if (result == true) {
        final ownerAccount =
            await LocalDataService.to.getAccount(_ownerUsername);

        // TODO: PIN 번호 입력

        final privateKey =
            await VaultService.to.read(ownerAccount.activePublicKey!);
        if (privateKey == null) {
          throw MessageException('송금에는 액티브 키가 필요합니다.');
        }

        // 서명 및 송금
        await SteemService.to.transfer(transferData, privateKey);
        await AppController.to.reload(); // 잔액 정보 업데이트

        logger.d('success');
        UIUtil.showSnackBar('송금에 성공하였습니다.', backgroundColor: Colors.green);
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
    usernameController = TextEditingController();
    amountController = TextEditingController();
    memoController = TextEditingController();

    // set arguments
    final arguments = Get.arguments;
    _ownerUsername = arguments['account'].toString();
    symbol(arguments['symbol'].toString());

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
