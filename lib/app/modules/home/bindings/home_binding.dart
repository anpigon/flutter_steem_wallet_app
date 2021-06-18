import 'package:flutter_steem_wallet_app/app/controllers/wallets_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<WalletsController>(
      () => WalletsController(),
    );
  }
}
