import 'package:get/get.dart';

import '../controllers/qrscan_controller.dart';

class QrscanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrscanController>(
      () => QrscanController(),
    );
  }
}
