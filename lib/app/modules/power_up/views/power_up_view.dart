import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/balance_small_box.dart';
import '../../../widgets/tight_button.dart';
import '../../wallets/controllers/wallets_controller.dart';
import '../controllers/power_up_controller.dart';

class PowerUpView extends GetView<PowerUpController> {
  final walletsController = Get.find<WalletsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Power Up')),
      body: Padding(
        padding: const EdgeInsets.all(23),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BalanceSmallBox(
                        label: 'Balance',
                        amount: walletsController.wallet().steemBalance!,
                        symbol: 'STEEM',
                        loading: false,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.alternate_email),
                        ),
                        controller: controller.usernameController,
                        validator: controller.usernameValidator,
                        focusNode: controller.usernameFocusNode,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Amount',
                          suffixIcon: Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, top: 15.0),
                            child: Text('STEEM'),
                          ),
                        ),
                        controller: controller.amountController,
                        validator: controller.amountValidator,
                        keyboardType: TextInputType.number,
                      ),
                      Row(
                        children: [
                          TightButton('10%', () {}),
                          SizedBox(width: 5),
                          TightButton('30%', () {}),
                          SizedBox(width: 5),
                          TightButton('50%', () {}),
                          SizedBox(width: 5),
                          TightButton('70%', () {}),
                          SizedBox(width: 5),
                          TightButton('100%', () {}),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.submit,
                child: controller.loading()
                    ? const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Power Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
