import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';
import '../../../../logger.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    logger.d('SplashView');
    logger.d('loading: ${controller.loading.value}');

    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/steem_logo_with_text.png'),
      ),
    );
  }
}
