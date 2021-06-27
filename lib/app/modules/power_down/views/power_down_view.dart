import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_utils.dart';
import 'package:get/get.dart';

import '../controllers/power_down_controller.dart';

import '../../../constants.dart';
import '../../../widgets/balance_small_box.dart';
import '../../../widgets/tight_button.dart';

class PowerDownView extends GetView<PowerDownController> {
  @override
  Widget build(BuildContext context) {
    final wallet = AppController.to.wallet();

    return Scaffold(
      appBar: AppBar(title: Text('powerdown_power_down'.tr)),
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
                          label: 'powerdown_current'.tr,
                          amount: AppController.to.wallet().steemPower,
                          symbol: 'SP',
                          loading: false,
                        ),
                        const SizedBox(height: 5),
                        BalanceSmallBox(
                          label: 'powerdown_available'.tr,
                          amount: AppController.to.wallet().steemPower -
                              AppController.to.wallet().delegatedSteemPower,
                          symbol: 'SP',
                          loading: false,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'powerdown_message'.tr,
                          style: Get.theme.textTheme.caption,
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
                        if (wallet.delegatedSteemPower != 0.0) ...[
                          Text(
                            'powerdown_delegating'.trParams({
                              'AMOUNT':
                                  toCurrencyFormat(wallet.delegatedSteemPower),
                            })!,
                            style: Get.theme.textTheme.caption,
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (wallet.toWithdraw - wallet.withdrawn > 0) ...[
                          Text(
                            'powerdown_already_power_down'.trParams({
                              'AMOUNT': toCurrencyFormat(wallet.toWithdraw),
                              'WITHDRAWN': toCurrencyFormat(wallet.withdrawn),
                            })!,
                            style: Get.theme.textTheme.caption,
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (wallet.nextSteemPowerWithdrawRate != 0.0) ...[
                          Text(
                            'powerdown_next_power_down_is_scheduled_to_happen'
                                .trArgs(
                              [
                                '${wallet.nextSteemPowerWithdrawal.toString().split(' ')[0]}',
                                '(~${toCurrencyFormat(wallet.nextSteemPowerWithdrawRate)} STEEM)'
                              ],
                            ),
                            style: Get.theme.textTheme.caption,
                          ),
                          const SizedBox(height: 10),
                        ],
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
                'powerdown_power_down'.tr,
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
