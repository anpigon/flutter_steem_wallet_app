import 'package:flutter_steem_wallet_app/app/data/steem_provider.dart';
import 'package:flutter_steem_wallet_app/app/models/account_history.dart';
import 'package:get/get.dart';

class AccountHistoryController extends GetxController
    with StateMixin<List<AccountHistory>> {
  @override
  Future<void> onInit() async {
    final arguments = Get.arguments;
    final account = 'anpigon'; // arguments['account'];

    try {
      change(null, status: RxStatus.loading());
      final results = await SteemProvider.to.getAccountHistory(account);

      if (results.length == 0) {
        change(null, status: RxStatus.empty());
      } else {
        change(results, status: RxStatus.success());
      }
    } catch (error) {
      print(error);
      change(null, status: RxStatus.error(error.toString()));
    }

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
