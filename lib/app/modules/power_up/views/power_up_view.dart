import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../widgets/balance_small_box.dart';
import '../../../widgets/tight_button.dart';
import '../controllers/power_up_controller.dart';

class PowerUpView extends GetView<PowerUpController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('powerup'.tr)),
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
                          amount: AppController.to.wallet().steemBalance,
                          symbol: 'STEEM',
                          loading: false,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'powerup_influence_token'.tr,
                          style: Get.theme.textTheme.caption,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'powerup_non_transferable'.tr,
                          style: Get.theme.textTheme.caption,
                        ),
                        if (controller.enabledEditUsername()) ...[
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
                          )
                        ],
                        /* const SizedBox(height: 20),
                        controller.enabledEditUsername()
                            ? TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: 'Username',
                                  prefixIcon: const Icon(Icons.alternate_email),
                                ),
                                controller: controller.usernameController,
                                validator: controller.usernameValidator,
                                focusNode: controller.usernameFocusNode,
                                keyboardType: TextInputType.name,
                              )
                            : Container(),
                        TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: 'Username',
                                  prefixIcon: const Icon(Icons.alternate_email),
                                ),
                                controller: controller.usernameController,
                                style: Get.theme.textTheme.subtitle1!.copyWith(
                                  color: Get.theme.disabledColor,
                                ),
                                enableInteractiveSelection: false,
                                readOnly: true,
                                showCursor: false,
                                onTap: () => FocusScope.of(context)
                                    .requestFocus(FocusNode()),
                              ), */
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Checkbox(
                        //       visualDensity: VisualDensity.compact,
                        //       value: controller.enabledEditUsername(),
                        //       onChanged: (value) {
                        //         controller.enabledEditUsername(value);
                        //       },
                        //     ),
                        //     Text('다른 계정에 전송하기'),
                        //   ],
                        // ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Amount',
                            suffixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 15.0),
                                  child: Text(Symbols.STEEM),
                                ),
                              ],
                            ),
                          ),
                          controller: controller.amountController,
                          validator: controller.amountValidator,
                          keyboardType: TextInputType.number,
                        ),
                        buildSetRatioAmountButtons(),
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
            : Text(
                'powerup'.tr,
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }

  Row buildSetRatioAmountButtons() {
    return Row(
      children: [
        TightButton(
          '10%',
          () => controller.setRatioAmount(0.1),
        ),
        SizedBox(width: 5),
        TightButton(
          '30%',
          () => controller.setRatioAmount(0.3),
        ),
        SizedBox(width: 5),
        TightButton(
          '50%',
          () => controller.setRatioAmount(0.5),
        ),
        SizedBox(width: 5),
        TightButton(
          '70%',
          () => controller.setRatioAmount(0.7),
        ),
        SizedBox(width: 5),
        TightButton(
          '100%',
          () => controller.setRatioAmount(1.0),
        ),
      ],
    );
  }
}
