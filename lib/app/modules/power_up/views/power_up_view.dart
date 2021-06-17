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
                          amount: walletsController.wallet().steemBalance,
                          symbol: 'STEEM',
                          loading: false,
                        ),
                        SizedBox(height: 15),
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
                            : TextFormField(
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
                              ),
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
                                Padding(
                                  padding: EdgeInsets.only(right: 15.0),
                                  child: Text('STEEM'),
                                ),
                              ],
                            ),
                          ),
                          controller: controller.amountController,
                          validator: controller.amountValidator,
                          keyboardType: TextInputType.number,
                        ),
                        Row(
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
      ),
    );
  }
}
