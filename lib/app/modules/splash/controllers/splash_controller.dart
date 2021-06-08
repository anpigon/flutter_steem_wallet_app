import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_pages.dart';
import '../../../services/local_data_service.dart';

class SplashController extends GetxController {
  final loading = true.obs;

  @override
  Future<void> onReady() async {
    super.onReady();

    final accounts = await LocalDataService.to.getAccounts();
    loading(false);

    if (accounts.isEmpty) {
      await Get.offAllNamed(Routes.START); // 초기 화면으로 이동
    } else {
      await Get.offAllNamed(Routes.HOME); // 홈 화면으로 이동
    }
  }

}
