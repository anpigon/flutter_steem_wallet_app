import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrscanController extends GetxController {
  final GlobalKey key = GlobalKey(debugLabel: 'QR');
  late final QRViewController? controller;

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (GetPlatform.isAndroid) {
        controller.pauseCamera();
      } else if (GetPlatform.isIOS) {
        controller.resumeCamera();
      }
      controller.dispose();
      Get.back(result: scanData.code);
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }
}
