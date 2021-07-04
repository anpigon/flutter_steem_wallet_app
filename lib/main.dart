import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/routes/app_pages.dart';
import 'generated/locales.g.dart';
import 'init_services.dart';
import 'initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initServices();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://860fa99d629646339a8f0f5e87544f87@o894390.ingest.sentry.io/5840350';
    },
    appRunner: () => runApp(MyApp()),
  );
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
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.indigo),
        ),
      ),
      initialBinding: InitBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      translationsKeys: AppTranslation.translations,
      locale: Get.deviceLocale,
      // locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'), // 잘못된 지역이 선택된 경우 복구될 지역을 지정
    );
  }
}
