import 'package:get/instance_manager.dart';

import 'package:flutter_steem_wallet_app/app/controller/wallets_controller.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(WalletsController(), permanent: true);
  }
}
