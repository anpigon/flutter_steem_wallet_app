import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Hero(
          tag: 'logo',
          child: Image.asset('assets/images/steem_logo.png'),
        ),
      ),
    );
  }
}
