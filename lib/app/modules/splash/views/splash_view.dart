import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/services/local_data_service.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/steem_logo_with_text.png'),
            if (controller.loading.value) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
