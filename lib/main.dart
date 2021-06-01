import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/services/hive_services.dart';

Future<void> main() async {
  await initServices();

  runApp(
    GetMaterialApp(
      title: 'Flutter Steem Wallet',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

Future<void> initServices() async {
  print('starting services ...');
  await Get.putAsync(() => HiveService().init());
  print('All services started...');
}
