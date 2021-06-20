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
      appBar: AppBar(title: Text('Delegate Power')),
      body: Obx(
        () => Padding(
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
                          amount: AppController.to.wallet().steemPower,
                          symbol: 'STEEM',
                          loading: false,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '스팀 파워(SP)를 다른 사용자에게 임대할 수 있습니다.',
                          style: Get.theme.textTheme.caption,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Username',
                            hintText: 'Steem 계정을 입력하세요.',
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
                            hintText: '임대할 SP 수량을 입력하세요.',
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
        ),
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
            : const Text(
                'Delegate',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
