import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/account.dart';
import '../../../services/local_data_service.dart';
import '../../../services/steem_service.dart';

class WalletsController extends GetxController
    with StateMixin<Account>, SingleGetTickerProviderMixin {
  final accounts = <String>[].obs;
  final selectedAccount = ''.obs;

  late final TabController tabController =
      TabController(length: 2, vsync: this);

  void onChangeAccount(String? username) {
    selectedAccount(username);
  }

  static WalletsController get to => Get.find();

  final localDataService = Get.find<LocalDataService>();
  final steemService = Get.find<SteemService>();

  /// account 잔액 정보를 가져온다.
  void loadAccountDetails(username) async {
    print(username);
    final _account = Account(
      id: 0,
      name: '',
      ownerPublicKey: '',
      activePublicKey: '',
      postingPublicKey: '',
      memoPublicKey: '',
    );
    change(_account, status: RxStatus.loading());
    final data = await steemService.getAccount(username);
    print(data.toString());
    await Future.delayed(Duration(seconds: 5));
    change(_account, status: RxStatus.success());
  }

  @override
  Future<void> onInit() async {
    // selectedAccount.firstRebuild = false;
    ever<String>(selectedAccount, loadAccountDetails);

    final _accounts = (await localDataService.getAccounts())
        .map((account) => account.name)
        .toList();
    if (_accounts.isNotEmpty) {
      accounts.assignAll(_accounts);
      selectedAccount(_accounts[0]);
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
