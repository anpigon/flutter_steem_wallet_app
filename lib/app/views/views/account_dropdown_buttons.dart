import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class AccountDropdownButtons extends StatelessWidget {
  final void Function(String?) onChanged;
  final List<String> items;
  final String? value;
  final Color? color;
  final double minWidth;
  final double maxWidth;

  const AccountDropdownButtons({
    Key? key,
    required this.items,
    required this.onChanged,
    this.value,
    this.color,
    this.minWidth = 100,
    this.maxWidth = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.mediaQuery.size.width;

    return Container(
      decoration: BoxDecoration(
        color: color ?? Get.theme.accentColor,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: DropdownButton(
        onChanged: onChanged,
        value: value,
        items: items
            .map<DropdownMenuItem<String>>(
              (username) => DropdownMenuItem(
                value: username,
                child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18),
                        ),
                        child: ColoredBox(
                          color: Colors.white,
                          child: Image.network(
                            'https://steemitimages.com/u/$username/avatar',
                            fit: BoxFit.cover,
                            width: 36,
                            height: 36,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.account_circle,
                                size: 36,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: min(screenWidth, minWidth),
                          maxWidth: min(screenWidth, maxWidth),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(username),
                        ),
                      ),
                    ],
                  ),
                ),
            )
            .toList(),
        underline: Container(),
        icon: const Icon(Icons.expand_more),
        style: Get.theme.textTheme.subtitle1!.copyWith(color: Colors.white),
        iconEnabledColor: Colors.white,
        dropdownColor: Get.theme.primaryColor,
      ),
    );
    ;
  }
}
