import 'package:get/get.dart';

import '../controllers/send_coin_controller.dart';

class SendCoinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendCoinController>(
      () => SendCoinController(),
    );
  }
}
