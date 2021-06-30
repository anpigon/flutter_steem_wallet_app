import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/models/signature/signature_model.dart';
import 'package:get/get.dart';

enum SignatureType {
  transfer, // 송금
  transferToVesting, // 파워업
  withdrawVesting, // 파워다운
  delegateVestingShares, // 임대
}

class SignatureConfirmDialog extends GetView {
  static Future<bool> show(SignatureType type, SignatureModel data) async {
    return await Get.dialog<bool>(
          SignatureConfirmDialog(type, data),
          barrierDismissible: false,
        ) ==
        true;
  }

  final SignatureType type;
  final SignatureModel data;

  SignatureConfirmDialog(this.type, this.data);

  @override
  Widget build(BuildContext context) {
    final prettyJson = data.toPrettyJson();

    return AlertDialog(
      title: Text('Signature'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.grey.shade50,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                prettyJson,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '서명 내용을 확인해주세요.\n실행 후에는 취소할 수 없습니다.',
            style: Get.theme.textTheme.caption,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: true),
          child: Text('Ok'),
        ),
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
