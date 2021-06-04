import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wallets_controller.dart';

class WalletsView extends GetView<WalletsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'WalletsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
