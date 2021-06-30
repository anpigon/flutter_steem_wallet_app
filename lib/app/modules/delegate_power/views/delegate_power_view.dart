import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/widgets/balance_small_box.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controllers/delegate_power_controller.dart';

class DelegatePowerView extends GetView<DelegatePowerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('delegate_power'.tr)),
      body: Obx(
        () {
          final wallet = AppController.to.wallet();
          final availableAmount = wallet.steemPower -
              wallet.delegatedSteemPower;
          return Padding(
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
                            label: 'delegate_current'.tr,
                            amount: wallet.steemPower,
                            symbol: 'SP',
                            loading: false,
                          ),
                          const SizedBox(height: 5),
                          BalanceSmallBox(
                            label: 'delegate_available'.tr,
                            amount: availableAmount,
                            symbol: 'SP',
                            loading: false,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'delegate_message'.tr,
                            style: Get.theme.textTheme.caption,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              labelText: 'Username',
                              hintText: 'delegate_hint_username'.tr,
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
                              hintText: 'delegate_hint_amount'.tr,
                              suffixIcon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 15.0),
                                    child: Text(Symbols.SP),
                                  ),
                                ],
                              ),
                            ),
                            controller: controller.amountController,
                            validator: controller.amountValidator,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                buildPowerUpButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  SizedBox buildPowerUpButton() {
    return SizedBox(
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
            :  Text(
                'delegate_to_user'.tr,
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
