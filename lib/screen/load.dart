import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/global_function/app_logout.dart';
import 'package:petsmore_tele_app/global_function/show_custom_dialog.dart';
import 'package:petsmore_tele_app/main.dart';
import 'package:petsmore_tele_app/screen/home.dart';
import 'package:petsmore_tele_app/screen/splash.dart';
import 'package:petsmore_tele_app/services/get_it.dart';
import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';
import 'package:petsmore_tele_app/widgets/bottom_navigation_bar.dart';

class Load extends ConsumerStatefulWidget {
  const Load({super.key});

  @override
  ConsumerState<Load> createState() => _LoadState();
}

class _LoadState extends ConsumerState<Load> {
  bool isLoggedIn = false;
  String userLogin = '';

  void initState() {
    super.initState();
    checkAndNavigate();
  }

  Future<void> getUserLogin() async {
    userLogin = await GetSharedPreferences().getUserPosition();
    AppDebug().printDebug(msg: 'userlogin in load:$userLogin');
    getIt<UserLoginService>().setUserLogin(userLogin);
    if (userLogin.isEmpty || userLogin == "") {
      await AppLogout().logout(context, ref);
      showCustomDialog(
          context, '', 'userLogin not found, Please re-login.', 'OK', () {});
    }
  }

  Future<bool> checkLoginStatus() async {
    isLoggedIn = await GetSharedPreferences().getLastLoginStatus();
    AppDebug().printDebug(msg: 'isLoggedIn in load:$isLoggedIn');
    return isLoggedIn;
  }

  checkAndNavigate() async {
    await checkLoginStatus();
    if (isLoggedIn == true) {
      await getUserLogin();
      AppDebug()
          .printDebug(msg: 'userLogin in check&nnavigate in load:$userLogin');

      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BottomNavBarWrapper(child: Home())));
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Splash()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo/sh-crm-logo.png'),
      ),
    );
  }
}
