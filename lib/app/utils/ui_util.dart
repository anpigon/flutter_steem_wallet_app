import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UIUtil {
  static bool smallScreen() {
    if (Get.size.height < 667) {
      return true;
    } else {
      return false;
    }
  }

  static void showErrorMessage(String message) {
    Get.snackbar(
      'ERROR',
      message,
      backgroundColor: Get.theme.errorColor,
      colorText: Colors.white,
    );
  }

  static void showSuccessMessage(String message) {
    Get.snackbar(
      'SUCCESS',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  static void showSnackBar(String message, {Color? backgroundColor, Duration? duration,}) {
    ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration ?? Duration(milliseconds: 2000),
      ),
    );
  }

  static void showToast(String message, {ToastGravity? gravity, Toast? toastLength,}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
    );
  }

  

  

  static String formatDateStr(DateTime dt) {
    final currentYear = DateTime.now().toLocal().year;
    final localTime = dt.toLocal();
    DateFormat df;
    if (localTime.year != currentYear) {
      df = DateFormat('MMM dd, yyyy • HH:mm');
    } else {
      df = DateFormat('MMM dd • HH:mm');
    }
    return df.format(localTime);
  }

  static String formatDateStrLong(DateTime dt) {
    //"Jul 08, 2019 • 13:24:01 (1562592241)"
    final secondsSinceEpoch = dt.millisecondsSinceEpoch ~/ 1000;
    final localTime = dt.toLocal();
    DateFormat df;
    df = DateFormat('MMM dd, yyyy • HH:mm:ss');
    return df.format(localTime) + '\n($secondsSinceEpoch)';
  }
}
