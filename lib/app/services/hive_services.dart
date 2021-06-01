import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService extends GetxService {
  Future<HiveService> init() async {
    // Hive init
    await Hive.initFlutter();
    return this;
  }
}
