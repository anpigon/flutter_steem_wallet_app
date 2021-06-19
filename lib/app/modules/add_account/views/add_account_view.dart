import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_account_controller.dart';

class AddAccountView extends GetView<AddAccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Account')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(23.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'Steem 계정을 입력하고 Private Posting key 또는 Private Active key 중 하나를 Private Key에 입력하세요.',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: controller.usernameController,
                        focusNode: controller.usernameFocusNode,
                        validator: controller.usernameValidator,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Username',
                          hintText: 'Steem 계정을 입력하세요.',
                          prefixIcon: const Icon(Icons.alternate_email),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        focusNode: controller.privateKeyFocusNode,
                        controller: controller.privateKeyController,
                        validator: controller.privateKeyValidator,
                        onEditingComplete: controller.submit,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Private Key',
                          hintText: 'Private Key를 입력하세요.',
                          prefixIcon: Icon(Icons.vpn_key),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            onPressed: controller.scanQRCode,
                          ),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.security, color: Colors.grey.shade600),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              '사용자의 Private key 정보를 수집하지 않습니다. Private key는 암호화되어 디바이스에 안전하게 저장됩니다.',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: controller.buttonSqueezeAnimation.value,
          //   height: 50,
          //   child: Obx(
          //     () => ElevatedButton(
          //       onPressed: controller.loading() ? () {} : controller.submit,
          //       child: controller.loading()
          //           ? const SizedBox(
          //               height: 20.0,
          //               width: 20.0,
          //               child: CircularProgressIndicator(
          //                 strokeWidth: 2,
          //                 color: Colors.white,
          //               ),
          //             )
          //           : const Text('Import'),
          //     ),
          //   ),
          // ),
          GetBuilder<AddAccountController>(
            builder: (_) => controller.buttonZoomOut.value <= 300
                ? Container(
                    margin: EdgeInsets.all(23.0),
                    width: controller.buttonZoomOut.value == 60
                        ? controller.buttonSqueezeAnimation.value
                        : controller.buttonZoomOut.value,
                    height: controller.buttonZoomOut.value,
                    // decoration: BoxDecoration(),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              controller.buttonSqueezeAnimation.value <
                                          Get.width * 0.5 &&
                                      controller.buttonZoomOut.value == 60
                                  ? 30
                                  : 5),
                        ),
                      ),
                      onPressed: controller.loading()
                          ? () {}
                          : () async {
                              controller.loading(true);
                              await controller.animationController.forward();
                              if (controller.animationController.isCompleted) {
                                Get.back();
                              }
                            },
                      child: controller.loading()
                          ? const SizedBox(
                              height: 30.0,
                              width: 30.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Import'),
                    ),
                  )
                : Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: controller.buttonZoomOut.value,
                      height: controller.buttonZoomOut.value,
                      decoration: BoxDecoration(
                        shape: controller.buttonZoomOut.value < 500
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
