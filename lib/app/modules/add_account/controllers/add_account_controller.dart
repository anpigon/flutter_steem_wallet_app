import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/modules/qrscan/views/qrscan_view.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../models/account.dart';
import '../../../services/local_data_service.dart';
import '../../../services/vault_service.dart';

class AddAccountController extends GetxController {
  late final formKey = GlobalKey<FormState>();
  late final usernameFocusNode = FocusNode();
  late final privateKeyFocusNode = FocusNode();
  late final usernameController = TextEditingController();
  late final privateKeyController = TextEditingController();

  late final loading = false.obs;

  @override
  void onInit() {
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
    if (value == null ||
        value.isEmpty ||
        value.length < 51 ||
        !value.startsWith('5')) {
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
    FocusScope.of(Get.overlayContext!).unfocus();

    loading(true);

    try {
      // Account 정보 가져오기
      final username = usernameController.text;
      final response = await Dio()
          .get<Map<String, dynamic>>('https://steemit.com/@$username.json');
      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Steem API 서버에서 장애가 발생했습니다.');
      }
      //   final json = jsonDecode(response.body);
      final user = response.data!['user'];
      if (response.data!['status'] == '404') {
        throw Exception(user);
      }

      final account = Account(
        id: user['id'],
        name: user['name'],
        ownerPublicKey: user['owner']['key_auths'][0][0],
        activePublicKey: user['active']['key_auths'][0][0],
        postingPublicKey: user['posting']['key_auths'][0][0],
        memoPublicKey: user['memo_key'],
      );

      // account 정보 저장
      final localDataService = Get.find<LocalDataService>();
      await localDataService.addAccount(account);

      // active private key 정보 저장
      final valutService = Get.find<ValutService>();
      await valutService.write(
        account.activePublicKey!,
        privateKeyController.text,
      );

      if (Get.previousRoute == Routes.START) {
        await Get.offAllNamed(Routes.HOME);
      } else {
        Get.back(result: user['name']);
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        colorText: Get.theme.errorColor,
      );
    } finally {
      loading(false);
    }
  }
}
