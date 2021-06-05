import 'package:get/instance_manager.dart';

import './app/services/local_data_service.dart';
import './app/services/vault_service.dart';
import './app/services/steem_service.dart';
import './logger.dart';

Future<void> initServices() async {
  logger.d('starting services ...');
  await Get.putAsync<LocalDataService>(() => LocalDataService().init());
  await Get.putAsync<ValutService>(() => ValutService().init());
  await Get.putAsync<SteemService>(() => SteemService().init());
  logger.d('All services started...');
}
