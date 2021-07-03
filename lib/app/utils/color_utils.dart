import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color getRatioColor(num ratio) {
  if(ratio > 0) return Colors.green;
  if(ratio < 0) return Colors.red;
  return Get.theme.hintColor;
}