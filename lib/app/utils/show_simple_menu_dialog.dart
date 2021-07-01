import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleMenuDialogOption {
  late final Icon icon;
  late final String text;
  late final VoidCallback callback;

  SimpleMenuDialogOption(this.icon, this.text, this.callback);
}

Future<void> showSimpleMenuDialog(
  List<SimpleMenuDialogOption> options,
) async {
  final List indexedList = Iterable<int>.generate(options.length).toList();

  final children = indexedList.map((id) {
    final option = options[id];
    return Column(children: [
      if (id > 0) Divider(),
      SimpleDialogOption(
        onPressed: () => Get.back(result: id),
        child: SizedBox(
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(option.text), option.icon],
          ),
        ),
      ),
    ]);
  }).toList();

  final result = await Get.dialog(
    SimpleDialog(
      children: children,
    ),
  );

  if (result != null) {
    options[result].callback();
  }
}
