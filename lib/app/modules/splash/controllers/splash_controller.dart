import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/local_data_service.dart';

class SplashController extends GetxController {
  final loading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    final localDataService = Get.find<LocalDataService>();

    final accounts = await localDataService.getAccounts();
    if (accounts.isEmpty) {
      // 초기 화면으로 이동
      await Get.offNamed(Routes.START);
    } else {
      // 홈 화면으로 이동
      await Get.offNamed(Routes.HOME);
    }
    loading(false);
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
