import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_account_controller.dart';

class AddAccountView extends GetView<AddAccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add_account'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(23),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'add_account_info'.tr,
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
                          hintText: 'add_account_hint_username'.tr,
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
                          hintText: 'add_account_hint_key'.tr,
                          prefixIcon: const Icon(Icons.vpn_key),
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
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              'add_account_message'.tr,
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
            AnimatedBuilder(
              animation: controller.animationController,
              builder: (_, __) => SizedBox(
                width: controller.buttonSqueezeAnimation.value,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.loading() ? () {} : controller.submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(controller.loading() ? 30 : 5),
                    ),
                  ),
                  child: controller.loading()
                      ? const SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('add_account_import_key'.tr),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
