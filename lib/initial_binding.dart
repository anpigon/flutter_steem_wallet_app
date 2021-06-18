import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:get/instance_manager.dart';

import 'app/data/price_provider.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController(), permanent: true);
    Get.lazyPut(() => PriceProvider(), fenix: true);
  }
}
