import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../exceptions/message_exception.dart';
import '../../../services/steem_service.dart';
import '../../wallets/controllers/wallets_controller.dart';

class PowerUpController extends GetxController {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController usernameController;
  late final TextEditingController amountController;
  late final FocusNode usernameFocusNode;

  final amountFormat =  NumberFormat('##0.0##', 'en_US');

  late final _owner;
  late final loading = false.obs;
  // late final username = ''.obs;
  late final enabledEditUsername = false.obs;

  late final WalletsController walletsController;

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

    final steemBalance = walletsController.wallet().steemBalance;
    if (_amount.isGreaterThan(steemBalance)) {
      return '잔액이 부족합니다.';
    }
    return null;
  }

  void setRatioAmount(double ratio) {
    final steemBalance = walletsController.wallet().steemBalance;
    final ratioAmount = (steemBalance - steemBalance % 0.001) * ratio;
    amountController.text = amountFormat.format(ratioAmount);
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // 소프트 키보드 감추기
    final currentFocus = FocusScope.of(Get.overlayContext!);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    loading(true);

    try {
      // account 존재하는지 여부 체크
      final username = usernameController.text.trim();
      final data = await SteemService.to.getAccount(username);
      if (data == null) {
        throw MessageException('Account not found');
      }

      // currentFocus.requestFocus(FocusNode());

      final _amount = amountController.text.trim();
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
    _owner = arguments['account'];

    walletsController = Get.find<WalletsController>();

    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    amountController = TextEditingController();
    usernameFocusNode = FocusNode();

    usernameController.text = _owner;
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
