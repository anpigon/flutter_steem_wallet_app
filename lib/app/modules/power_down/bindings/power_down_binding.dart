import 'package:get/get.dart';

import '../controllers/power_down_controller.dart';

class PowerDownBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PowerDownController>(
      () => PowerDownController(),
    );
  }
}
