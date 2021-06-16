import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steemdart_ecc/steemdart_ecc.dart' as steem;

import '../../../exceptions/message_exception.dart';
import '../../../routes/app_pages.dart';
import '../../../models/account.dart';
import '../../../services/local_data_service.dart';
import '../../../services/steem_service.dart';
import '../../../services/vault_service.dart';

class AddAccountController extends GetxController {
  late final formKey = GlobalKey<FormState>();
  late final usernameFocusNode = FocusNode();
  late final privateKeyFocusNode = FocusNode();
  late final usernameController = TextEditingController();
  late final privateKeyController = TextEditingController();

  late final loading = false.obs;

  late final String previousRoute;
  @override
  void onInit() {
    previousRoute = Get.previousRoute;

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    usernameFocusNode.dispose();
    usernameController.dispose();
    privateKeyController.dispose();
    super.onClose();
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty || value.length <= 3) {
      return 'Invalid username!';
    }
    return null;
  }

  String? privateKeyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invalid privateKey!';
    } else if (value.startsWith('STM')) {
      return 'Invalid privateKey!';
    } else if (value.length < 51 || !value.startsWith('5')) {
      return 'Invalid privateKey!';
    }
    return null;
  }

  Future<void> scanQRCode() async {
    // referenced solution: https://github.com/flutter/flutter/issues/36948
    // Unfocus all focus nodes
    privateKeyFocusNode.unfocus();

    // Disable text field's focus node request
    privateKeyFocusNode.canRequestFocus = false;

    Future.delayed(Duration(milliseconds: 100), () async {
      final result = await Get.toNamed(Routes.QRSCAN);
      if (result != null) {
        privateKeyController.text = result;
      }

      //Enable the text field's focus node request after some delay
      privateKeyFocusNode.canRequestFocus = true;
    });
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
      // Account 정보 가져오기
      final username = usernameController.text.trim();
      final steemService = Get.find<SteemService>();
      final data = await steemService.getAccount(username);
      if (data == null) {
        throw MessageException('Account not found');
      }

      final account = Account(
        id: data.id,
        name: data.name,
        ownerPublicKey: data.owner.key_auths[0][0],
        activePublicKey: data.active.key_auths[0][0],
        postingPublicKey: data.posting.key_auths[0][0],
        memoPublicKey: data.memo_key,
      );

      // privateKey verify
      final _privateKey =
          steem.SteemPrivateKey.fromString(privateKeyController.text.trim());
      final _publicKey = _privateKey.toPublicKey().toString();

      // active private key 정보 저장
      final vaultService = Get.find<VaultService>();
      if (_publicKey == account.activePublicKey) {
        await vaultService.write(
          account.activePublicKey!,
          _privateKey.toString(),
        );
      } else if (_publicKey == account.postingPublicKey) {
        await vaultService.write(
          account.postingPublicKey!,
          _privateKey.toString(),
        );
      } else {
        privateKeyController.clear();
        throw MessageException('포스팅 키 또는 액티브 키가 필요합니다.');
      }

      // account 정보 저장
      final localDataService = Get.find<LocalDataService>();
      await localDataService.addAccount(account);

      if (previousRoute == Routes.START) {
        await Get.offAllNamed(Routes.HOME);
      } else {
        Get.back(result: username);
      }
    } on MessageException catch (error) {
      showErrorMessage(error.message);
    } catch (error) {
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
}
