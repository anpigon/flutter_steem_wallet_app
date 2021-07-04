import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:get/get.dart';

import '../controllers/qrscan_controller.dart';

class QRScanView extends GetView<QrscanController> {
  @override
  Widget build(BuildContext context) {
    final scanArea = (Get.width < 400 || Get.height < 400) ? 150.0 : 300.0;

    return Scaffold(
      body: SafeArea(
        child: ColoredBox(
          color: Colors.black,
          child: QRView(
            key: controller.key,
            onQRViewCreated: controller.onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea,
            ),
          ),
        ),
      ),
    );
  }
}
