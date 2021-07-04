import 'package:encrypt/encrypt.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/models/account.dart';
import 'package:flutter_steem_wallet_app/app/services/local_data_service.dart';
import 'package:flutter_steem_wallet_app/app/services/vault_service.dart';
import 'package:get/get.dart';

class ShowKey {
  final posting = false.obs;
  final active = false.obs;
  final memo = false.obs;

  void toggle(RxBool rxBool) {
    rxBool(!rxBool.value);
  }

  void init() {
    posting(false);
    active(false);
    memo(false);
  }
}

class PrivateKey {
  Encrypted? _posting;
  Encrypted? _active;
  Encrypted? _memo;

  late final _encryptKey;

  PrivateKey({
    String? posting,
    String? active,
    String? memo,
  }) {
    _encryptKey = Key.fromSecureRandom(32);

    _posting = encrypt(posting);
    _active = encrypt(active);
    _memo = encrypt(memo);
  }

  String? get posting => decrypt(_posting);

  String? get active => decrypt(_active);

  String? get memo => decrypt(_memo);

  Encrypted? encrypt(String? plainText) {
    if (plainText == null) return null;
    return Encrypter(Salsa20(_encryptKey)).encrypt(
      plainText,
      iv: IV.fromLength(8),
    );
  }

  String? decrypt(Encrypted? encrypted) {
    if (encrypted == null) return null;
    return Encrypter(Salsa20(_encryptKey)).decrypt(
      encrypted,
      iv: IV.fromLength(8),
    );
  }
}

class ManageAccountsController extends GetxController with StateMixin<Account> {
  late final LocalDataService localDataService;
  late final VaultService vaultService;

  final selectedAccount = ''.obs;

  void onChangeAccount(String? username) {
    selectedAccount(username);
  }

  final showKey = ShowKey();

  PrivateKey privateKey = PrivateKey();

  @override
  void onInit() {
    localDataService = LocalDataService.to;
    vaultService = VaultService.to;

    ever<String>(selectedAccount, (val) async {
      change(null, status: RxStatus.loading());

      showKey.init();

      final account = await localDataService.getAccount(val);

      if (account != null) {
        privateKey = PrivateKey(
          posting: await vaultService.read(account.postingPublicKey),
          active: await vaultService.read(account.activePublicKey),
          memo: await vaultService.read(account.memoPublicKey),
        );
      }

      change(account, status: RxStatus.success());
    });

    selectedAccount(AppController.to.selectedAccount.value);

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
