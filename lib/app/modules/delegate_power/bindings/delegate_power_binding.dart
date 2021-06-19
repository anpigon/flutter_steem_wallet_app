import 'package:get/get.dart';

import '../controllers/delegate_power_controller.dart';

class DelegatePowerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DelegatePowerController>(
      () => DelegatePowerController(),
    );
  }
}
