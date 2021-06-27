import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_utils.dart';
import 'package:get/get.dart';

import '../controllers/power_down_controller.dart';

import '../../../constants.dart';
import '../../../widgets/balance_small_box.dart';
import '../../../widgets/tight_button.dart';

class PowerDownView extends GetView<PowerDownController> {
  // TODO: 1. 임대 중인 스팀파워는 제거하고 실제 파워다운 가능한 vest를 표시한다.
  // "현재 1,000 STEEM을 임대 중입니다. 이 수량은 임대 종료 후 회수 기간이 완전히 지날 때까지는 파워다운을 할 수 없습니다."
  // TODO: 2. 현재 파워 다운 진행 중인 상태 표시하기
  // "이미 1,000 STEEM의 파워 다운을 진행하고 있습니다. 파워 다운 수량을 변경하면 파워 다운 일정이 초기화되니 유의하십시오."

  @override
  Widget build(BuildContext context) {
    final wallet = AppController.to.wallet();

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
                        // Row(
                        //   children: [
                        //     // Text('Current Power Down : '),
                        //     // Text('200.3 / 10294.5 SP'),
                        //     Text('다음 파워다운 예정: 모레 (~93.192 SP)')
                        //   ],
                        // ),
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
                        Text(
                          'powerdown_already_power_down'.trParams({
                            'AMOUNT': toCurrencyFormat(wallet.to_withdraw),
                            'WITHDRAWN': toCurrencyFormat(wallet.withdrawn),
                          })!,
                          style: Get.theme.textTheme.caption,
                        ),
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
