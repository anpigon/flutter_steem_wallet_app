import 'package:get/instance_manager.dart';

import 'app/services/local_data_service.dart';
import 'logger.dart';

Future<void> initServices() async {
  logger.d('starting services ...');
  await Get.putAsync<LocalDataService>(() => LocalDataService().init());
  logger.d('All services started...');
}
