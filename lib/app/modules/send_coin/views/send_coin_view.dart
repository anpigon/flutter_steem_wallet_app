import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/balance_small_box.dart';
import '../controllers/send_coin_controller.dart';

class SendCoinView extends GetView<SendCoinController> {
  @override
  Widget build(BuildContext context) {
    print(Get.arguments);
    return Scaffold(
      appBar: AppBar(title: Text('Transfer')),
      body: Padding(
        padding: const EdgeInsets.all(23),
        child: Obx(
          () => Column(
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
                          amount: controller.amount,
                          symbol: controller.symbol(),
                          loading: !controller.balances().isDone,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Username',
                            hintText: '받을 Steem 계정을 입력하세요.',
                            prefixIcon: const Icon(Icons.alternate_email),
                          ),
                          keyboardType: TextInputType.name,
                          validator: controller.usernameValidator,
                          controller: controller.usernameController,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Amount',
                            hintText: '보낼 Amount를 입력하세요.',
                            suffixIcon: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isDense: true,
                                value: controller.symbol(),
                                items: [
                                  DropdownMenuItem(
                                    value: 'STEEM',
                                    child: Text('STEEM'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'SBD',
                                    child: Text('SBD'),
                                  )
                                ],
                                underline: Container(),
                                onChanged: controller.onChangedSymbol,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: controller.amountValidator,
                          controller: controller.amountController,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Memo',
                            hintText: 'Memo를 입력하세요.',
                            helperText: '모두에게 공개되는 메모입니다.',
                          ),
                          controller: controller.memoController,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      controller.balances().isDone ? controller.submit : null,
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
                          'Send',
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
