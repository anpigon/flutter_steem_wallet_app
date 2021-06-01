import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/account.dart';

const String ACCOUNTS_BOX = 'accounts_box';

class LocalDataService extends GetxService {
  final accountsBox = Get.find<Box<Account>>(tag: ACCOUNTS_BOX);

  Future<List<Account>> getAccounts() async {
    if (accountsBox.isNotEmpty) {
      return accountsBox.values.map((account) => account).toList();
    }
    return <Account>[];
  }

  Future<void> addAccount(Account account) async {
    if (accountsBox.get(account.name) != null) {
      throw Exception('이미 등록되어 있는 account 입니다.');
    }
    await accountsBox.put(account.name, account);
  }

  Future<LocalDataService> init() async {
    print('LocalDataService.init');
    await Hive.initFlutter();
    Hive.registerAdapter(AccountAdapter());

    final searchBox = await Hive.openBox<Account>(ACCOUNTS_BOX);
    Get.put<Box>(searchBox, tag: ACCOUNTS_BOX);
    return this;
  }

  @override
  void onInit() {
    print('LocalDataService.onInit');
    super.onInit();
  }

  @override
  void onReady() {
    print('LocalDataService.onReady');
    super.onReady();
  }

  @override
  void onClose() {
    print('LocalDataService.onClose');
    super.onClose();
  }
}
