import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_account_controller.dart';

class AddAccountView extends GetView<AddAccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(23),
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.loading() ? null : controller.submit,
                  child: controller.loading()
                      ? const SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Import'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
