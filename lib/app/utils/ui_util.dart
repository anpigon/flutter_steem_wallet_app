import 'package:flutter/material.dart';
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

  static void showSnackbar(String content, BuildContext context) {
    // showToastWidget(
    //   Align(
    //     alignment: Alignment.topCenter,
    //     child: Container(
    //       margin: EdgeInsets.symmetric(
    //           vertical: Get.size.height * 0.05,
    //           horizontal: 14),
    //       padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    //       width: Get.size.width - 30,
    //       decoration: BoxDecoration(
    //         color: Get.theme.snackBarTheme.backgroundColor,
    //         borderRadius: BorderRadius.circular(10),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.black.withOpacity(0.2),
    //             offset: Offset(0, 20),
    //             blurRadius: 40,
    //             spreadRadius: -5,
    //           ),
    //         ],
    //       ),
    //       child: Text(
    //         content,
    //         style: Get.theme.snackBarTheme.contentTextStyle,
    //         textAlign: TextAlign.start,
    //       ),
    //     ),
    //   ),
    //   dismissOtherToast: true,
    //   duration: Duration(milliseconds: 2000),
    //   context: context,
    // );
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
