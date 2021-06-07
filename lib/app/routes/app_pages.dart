import 'package:get/get.dart';

import 'package:flutter_steem_wallet_app/app/modules/add_account/bindings/add_account_binding.dart';
import 'package:flutter_steem_wallet_app/app/modules/add_account/views/add_account_view.dart';
import 'package:flutter_steem_wallet_app/app/modules/qrscan/bindings/qrscan_binding.dart';
import 'package:flutter_steem_wallet_app/app/modules/qrscan/views/qrscan_view.dart';
import 'package:flutter_steem_wallet_app/app/modules/send_coin/bindings/send_coin_binding.dart';
import 'package:flutter_steem_wallet_app/app/modules/send_coin/views/send_coin_view.dart';
import 'package:flutter_steem_wallet_app/app/modules/start/bindings/start_binding.dart';
import 'package:flutter_steem_wallet_app/app/modules/start/views/start_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.START,
      page: () => StartView(),
      binding: StartBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ACCOUNT,
      page: () => AddAccountView(),
      binding: AddAccountBinding(),
    ),
    GetPage(
      name: _Paths.QRSCAN,
      page: () => QrscanView(),
      binding: QrscanBinding(),
    ),
    GetPage(
      name: _Paths.SEND_COIN,
      page: () => SendCoinView(),
      binding: SendCoinBinding(),
    ),
  ];
}
