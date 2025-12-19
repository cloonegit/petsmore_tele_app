import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppDeviceBackBtn {
  DateTime? lastBackPressTime;

  Future<bool> popped(BuildContext context) async {
    DateTime now = DateTime.now();

    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > Duration(seconds: 2)) {
      lastBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit");
      return Future.value(false);
    } else {
      Fluttertoast.cancel();
      exit(0);
    }
  }
}
