import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:get/get.dart';

import '../controllers/power_down_controller.dart';

import '../../../constants.dart';
import '../../../widgets/balance_small_box.dart';
import '../../../widgets/tight_button.dart';

class PowerDownView extends GetView<PowerDownController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Power Down')),
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
                          symbol: 'SP',
                          loading: false,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            // Text('Current Power Down : '),
                            // Text('200.3 / 10294.5 SP'),
                            Text('다음 파워다운 예정: 모레 (~93.192 SP)')
                          ],
                        ),
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
                                  child: Text(Symbols.SP),
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
            : const Text(
                'Power Down',
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
