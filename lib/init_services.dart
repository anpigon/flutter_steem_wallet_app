import 'package:get/instance_manager.dart';

import 'app/services/local_data_service.dart';

Future<void> initServices() async {
  print('starting services ...');
  await Get.putAsync(() => LocalDataService().init());
  print('All services started...');
}
