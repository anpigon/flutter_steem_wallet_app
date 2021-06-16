import 'package:get/get.dart';

import '../controllers/power_up_controller.dart';

class PowerUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PowerUpController>(
      () => PowerUpController(),
    );
  }
}
