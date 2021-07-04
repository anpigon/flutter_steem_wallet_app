import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/models/account.dart';
import 'package:flutter_steem_wallet_app/app/routes/app_pages.dart';
import 'package:flutter_steem_wallet_app/app/services/local_data_service.dart';
import 'package:flutter_steem_wallet_app/app/services/vault_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:steemdart_ecc/steemdart_ecc.dart' as steem;

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
    _encryptKey = enc.Key.fromSecureRandom(32);

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
  static ManageAccountsController get to =>
      Get.find<ManageAccountsController>();

  late final LocalDataService localDataService;
  late final VaultService vaultService;

  final isLoading = false.obs;
  final selectedAccount = ''.obs;

  void onChangeAccount(String? username) {
    selectedAccount(username);
  }

  final showKey = ShowKey();

  PrivateKey privateKey = PrivateKey();

  late final ScrollController scrollController;
  late final GlobalKey<FormState> formKey;
  late final FocusNode privateKeyFocusNode;
  late final TextEditingController privateKeyController;
  String? publicKeyForValidate;

  Future<void> loadAccount([String? username]) async {
    change(null, status: RxStatus.loading());

    showKey.init();

    final account =
        await localDataService.getAccount(username ?? selectedAccount.value);

    if (account != null) {
      privateKey = PrivateKey(
        posting: await vaultService.read(account.postingPublicKey),
        active: await vaultService.read(account.activePublicKey),
        memo: await vaultService.read(account.memoPublicKey),
      );
    }

    change(account, status: RxStatus.success());
  }

  String? privateKeyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invalid privateKey!';
    }
    if (value.startsWith('STM')) {
      return 'Invalid privateKey!';
    }
    if (value.length < 51 || !value.startsWith('5')) {
      return 'Invalid privateKey!';
    }

    final key = privateKeyController.text.trim();
    print(publicKeyForValidate);
    print(steem.SteemPrivateKey.fromString(key).toPublicKey().toString());
    if (publicKeyForValidate !=
        steem.SteemPrivateKey.fromString(key).toPublicKey().toString()) {
      return 'Invalid privateKey!';
    }

    return null;
  }

  Future<bool> addKey() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final value = privateKeyController.text.trim();
    final key =
        steem.SteemPrivateKey.fromString(value).toPublicKey().toString();
    await vaultService.write(key, value);

    return true;
  }

  Future<void> deleteKey(String public) async {
    await vaultService.delete(public);

    await Fluttertoast.showToast(
      msg: 'manage_deleted'.tr,
      gravity: ToastGravity.BOTTOM,
    );

    await loadAccount();
  }

  Future<void> deleteAccount(String username) async {
    isLoading(true);

    final accounts = await localDataService.getAccounts();
    if (accounts.length == 1) {
      await Fluttertoast.showToast(
        msg: 'manage_at_least_one_account_must_exist'.tr,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      final account = await localDataService.getAccount(username);
      if (account != null) {
        await vaultService.delete(account.postingPublicKey!);
        await vaultService.delete(account.activePublicKey!);
        await vaultService.delete(account.memoPublicKey!);
        await localDataService.deleteAccount(username);

        await Fluttertoast.showToast(
          msg: 'manage_deleted'.tr,
          gravity: ToastGravity.BOTTOM,
        );

        await scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn,
        );

        selectedAccount(
            accounts.firstWhere((val) => val.name != username).name);
      }
    }

    isLoading(false);
  }

  Future<void> scanQRCode() async {
    privateKeyFocusNode.unfocus();
    privateKeyFocusNode.canRequestFocus = false;
    Future.delayed(Duration(milliseconds: 100), () async {
      final result = await Get.toNamed(Routes.QRSCAN);
      if (result != null) {
        privateKeyController.text = result;
      }
      privateKeyFocusNode.canRequestFocus = true;
    });
  }

  @override
  void onInit() {
    localDataService = LocalDataService.to;
    vaultService = VaultService.to;

    formKey = GlobalKey<FormState>();
    privateKeyController = TextEditingController();
    scrollController = ScrollController();
    privateKeyFocusNode = FocusNode();

    ever<String>(selectedAccount, loadAccount);

    selectedAccount(AppController.to.selectedAccount.value);

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    privateKeyController.dispose();
    privateKeyFocusNode.dispose();
    scrollController.dispose();

    super.onClose();
  }
}
