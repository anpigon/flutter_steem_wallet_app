import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/power_down_controller.dart';

class PowerDownView extends GetView<PowerDownController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PowerDownView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PowerDownView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
