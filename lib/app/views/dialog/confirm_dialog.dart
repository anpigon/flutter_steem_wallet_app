import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;

  const ConfirmDialog(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: ()  => Get.back(result: true),
          child: Text('OK'),
        )
      ],
    );
  }
}

Future<bool> showConfirmDialog(String message) async {
  return true == await showDialog<bool>(
    context: Get.overlayContext!,
    builder: (ctx) => ConfirmDialog(message),
  );
}