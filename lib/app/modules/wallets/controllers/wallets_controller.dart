import 'package:get/get.dart';

import '../../../services/local_data_service.dart';

class WalletsController extends GetxController {
  final accounts = <String>[].obs;
  final selectedAccount = ''.obs;

  void onChangeAccount(String? account) {
    selectedAccount(account);
  }

  final localDataService = Get.find<LocalDataService>();

  @override
  Future<void> onInit() async {
    final _accounts = (await localDataService.getAccounts())
        .map((account) => account.name)
        .toList();
    if (_accounts.isNotEmpty) {
      accounts.addAll(_accounts);
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
