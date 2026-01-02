import 'package:flutter/material.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/app_logout.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserLogin {
  Future<String> getUserLogin(BuildContext context, WidgetRef ref) async {
    String userLogin = await GetSharedPreferences().getUserPosition();
    AppDebug().printDebug(msg: 'userlogin:$userLogin');
    if (userLogin.isEmpty || userLogin == "") {
      await AppLogout().logout(context, ref);
      showCustomDialog(
          context, '', 'User login not found, Please re-login.', 'OK', () {});
    }
    return userLogin;
  }
}
