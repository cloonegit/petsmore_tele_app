import 'package:flutter/material.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/global_function/app_logout.dart';
import 'package:petsmore_tele_app/global_function/show_custom_dialog.dart';
import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';
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
