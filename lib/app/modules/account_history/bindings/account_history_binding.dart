import 'package:get/get.dart';

import '../controllers/account_history_controller.dart';

class AccountHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountHistoryController>(
      () => AccountHistoryController(),
    );
  }
}
