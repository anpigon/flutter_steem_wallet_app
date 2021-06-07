import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/send_coin_controller.dart';

class SendCoinView extends GetView<SendCoinController> {
  @override
  Widget build(BuildContext context) {
    print(Get.arguments);
    return Scaffold(
      appBar: AppBar(title: Text('Transfer')),
      body: Padding(
        padding: EdgeInsets.all(23),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Username',
                          hintText: '받을 Steem 계정을 입력하세요.',
                          prefixIcon: const Icon(Icons.alternate_email),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Amount',
                          hintText: '보낼 Amount를 입력하세요.',
                          suffixIcon: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isDense: true,
                              value: 'STEEM',
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
                              onChanged: (dynamic value) {},
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Memo',
                          hintText: 'Memo를 입력하세요.',
                          helperText: '모두에게 공개되는 메모입니다.',
                        ),
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
                onPressed: () {},
                child: const Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
