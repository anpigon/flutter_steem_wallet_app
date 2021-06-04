import 'package:get/get.dart';

import 'package:flutter_steem_wallet_app/app/modules/add_account/bindings/add_account_binding.dart';
import 'package:flutter_steem_wallet_app/app/modules/add_account/views/add_account_view.dart';
import 'package:flutter_steem_wallet_app/app/modules/start/bindings/start_binding.dart';
import 'package:flutter_steem_wallet_app/app/modules/start/views/start_view.dart';
import 'package:flutter_steem_wallet_app/app/modules/wallets/bindings/wallets_binding.dart';
import 'package:flutter_steem_wallet_app/app/modules/wallets/views/wallets_view.dart';

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
      name: _Paths.WALLETS,
      page: () => WalletsView(),
      binding: WalletsBinding(),
    ),
  ];
}
