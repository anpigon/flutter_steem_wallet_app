import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/state_manager.dart';

class VaultService extends GetxService {
  late final FlutterSecureStorage _secureStorage;

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
