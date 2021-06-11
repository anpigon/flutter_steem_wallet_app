import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../exceptions/message_exception.dart';
import '../models/account.dart';

const String ACCOUNTS_BOX = 'accounts_box';

class LocalDataService extends GetxService {
  late final Box<Account> accountsBox;

  static LocalDataService get to => Get.find();

  Future<List<Account>> getAccounts() async {
    if (accountsBox.isNotEmpty) {
      return accountsBox.values.map((account) => account).toList();
    }
    return <Account>[];
  }

  Future<Account?> getAccount(String username) async {
    if (accountsBox.isNotEmpty) {
      return accountsBox.get(username);
    }
    return null;
  }

  Future<void> addAccount(Account account) async {
    if (accountsBox.get(account.name) != null) {
      throw MessageException('이미 등록되어 있는 account 입니다.');
    }
    await accountsBox.put(account.name, account);
  }

  Future<LocalDataService> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(AccountAdapter());

    accountsBox = await Hive.openBox<Account>(ACCOUNTS_BOX);
    return this;
  }

  @override
  void onClose() {
    Hive.close();
    super.onClose();
  }
}
