import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/main.dart';

import 'package:petsmore_tele_app/screen/login.dart';
import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';

class AppLogout {
  logout(BuildContext context, WidgetRef ref) async {
    await GetSharedPreferences().clearAllData();
    await ref.read(callSummaryProvider).clearData();
    await ref.read(callSummaryDetailProvider).clearData();
    await ref.read(campaignProvider).clearData();
    await ref.read(homeProvider).clearData();
    await ref.read(loginProvider).clearData();
    await ref.read(settingProvider).clearData();
    String userLogin = await GetSharedPreferences().getUserPosition();
    AppDebug().printDebug(msg: 'userLogin in logout:$userLogin');
    // Navigator.popAndPushNamed(context, '/login');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
        (Route<dynamic> route) => false);
    if (context.mounted) {
      // ref.read(bottomNavNotifierProvider.notifier).setIndex(0);
    }
  }
}
