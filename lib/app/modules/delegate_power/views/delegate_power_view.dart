import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delegate_power_controller.dart';

class DelegatePowerView extends GetView<DelegatePowerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DelegatePowerView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DelegatePowerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
