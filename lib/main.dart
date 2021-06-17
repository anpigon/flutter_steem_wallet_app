import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'initial_binding.dart';
import 'init_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initServices();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    return GetMaterialApp(
      title: 'Flutter Steem Wallet',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        appBarTheme: Get.theme.appBarTheme.copyWith(
          centerTitle: true,
          backgroundColor: Colors.indigo,
          brightness: Brightness.light,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.indigo),
        ),
      ),
      initialBinding: InitBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
