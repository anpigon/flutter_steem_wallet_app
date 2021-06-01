import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/local_data_service.dart';
import '../../../../logger.dart';

class SplashController extends GetxController {
  final loading = true.obs;

  @override
  void onInit() {
    logger.d('SplashController.onInit');
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    logger.d('SplashController.onReady');
    final localDataService = Get.find<LocalDataService>();
    final accounts = await localDataService.getAccounts();
    logger.d('accounts: ${accounts.length}');
    if (accounts.isEmpty) {
      // 초기 화면으로 이동
      await Get.offNamed(Routes.START);
    } else {
      // 홈 화면으로 이동
      await Get.offNamed(Routes.HOME);
    }
    loading.value = false;
    super.onReady();
  }

  @override
  void onClose() {
    logger.d('SplashController.onClose');
    super.onClose();
  }
}
