import 'package:get/get.dart';

import '../controllers/manage_accounts_controller.dart';

class ManageAccountsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageAccountsController>(
      () => ManageAccountsController(),
    );
  }
}
