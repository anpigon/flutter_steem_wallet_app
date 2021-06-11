import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VaultService extends GetxService {
  late final FlutterSecureStorage _secureStorage;

  static VaultService get to => Get.find<VaultService>();

  Future<VaultService> init() async {
    _secureStorage = FlutterSecureStorage();
    return this;
  }

  Future<String> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
    return value;
  }

  Future<String?> read(String key, {String? defaultValue}) async {
    return await _secureStorage.read(key: key) ?? defaultValue;
  }
}
