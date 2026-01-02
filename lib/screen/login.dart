import 'package:nrs_tele_apps/config/global.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nrs_tele_apps/global_function/app_back_button.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/provider/bottom_nav_provider.dart';
import 'package:nrs_tele_apps/provider/login_provider.dart';
import 'package:nrs_tele_apps/screen/home.dart';
import 'package:nrs_tele_apps/services/get_it.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:nrs_tele_apps/services/package_info.dart';
import 'package:nrs_tele_apps/widgets/bottom_navigation_bar.dart';
import 'package:nrs_tele_apps/widgets/custom_container.dart';
import 'package:nrs_tele_apps/widgets/custom_textfield.dart';
import 'package:nrs_tele_apps/widgets/dialog_global.dart';
import 'package:nrs_tele_apps/widgets/global_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final AppDeviceBackBtn backBtnHandler = AppDeviceBackBtn();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  String? errorMessageUsername;
  String? errorMessagePassword;
  String version = '';
  String errorMessage = '';
  String appVersion = '';
  String buildNumber = '';
  final errorMessageService = GetIt.instance<ErrorMessageService>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    AppDebug().printDebug(msg: 'init login;');

    _initPackageInfo();
    usernameFocusNode.addListener(() {
      setState(() {});
    });
    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    AppDebug().printDebug(msg: 'dispose login;');
    usernameController.dispose();
    passwordController.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  clearForm() {
    usernameController.clear();
    passwordController.clear();
  }

  signIn() async {
    setState(() {
      errorMessageUsername = null;
      errorMessagePassword = null;
      isLoading = true;
    });

    final username = usernameController.text;
    final password = passwordController.text;

    var response;
    try {
      response = await LoginProvider()
          .fetchLogin(username: username, password: password);
      AppDebug().printDebug(msg: 'response sign in:$response');
      if (response['status'] == '1') {
        AppDebug().printDebug(msg: 'success login:$response');
        AppDebug().printDebug(msg: 'position:${response['LIST']['POSITION']}');
        await GetSharedPreferences().setLastLoginStatus(true);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BottomNavBarWrapper(child: Home())));
        ref.read(bottomNavNotifierProvider.notifier).setIndex(0);
        clearForm();
      } else {
        //response['status'] == '0'
        AppDebug().printDebug(msg: 'fail login:${response['status_message']}');
        GlobalUtils.showFloatingMessage(context, response['status_message']);
      }
    } catch (e) {
      AppDebug().printDebug(msg: 'Error Sign In: ${e.toString()}');
      final errorMessage = errorMessageService.getErrorMessage();
      if (errorMessage != null && errorMessage.isNotEmpty) {
        showCustomDialog(context, '', errorMessage, 'OK', () {
          errorMessageService.clearErrorMessage();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _initPackageInfo() async {
    try {
      appVersion = await AppInfo.getAppVersion();
      buildNumber = await AppInfo.getBuildNumber();
      setState(() {
        appVersion = appVersion;
        buildNumber = buildNumber;
      });
    } catch (e) {
      print('Error initializing package info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await backBtnHandler.popped(context);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/sh-crm-logo.png',
                      height: Adaptive.h(25),
                      width: Adaptive.w(80),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: Adaptive.w(6), top: Adaptive.h(0)),
                      child: const Text(
                        'Welcome back.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                          letterSpacing: 0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: Adaptive.w(7), top: Adaptive.h(0)),
                      child: const Text(
                        'Log in to your account',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: 0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Adaptive.h(4),
                ),
                Row(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextfield(
                            width: Adaptive.w(88),
                            padding: EdgeInsets.only(
                              left: Adaptive.w(6),
                              top: Adaptive.h(0),
                              bottom: Adaptive.h(0),
                            ),
                            labelText: 'Username',
                            controller: usernameController,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value == '') {
                                return '*Please enter your username';
                              }
                              return null;
                            },
                            focusNode: usernameFocusNode,
                            floatingLabelBehavior: usernameFocusNode.hasFocus
                                ? FloatingLabelBehavior.auto
                                : FloatingLabelBehavior.never,
                            obscureText: false,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Adaptive.h(0.5),
                ),
                Row(
                  children: [
                    Form(
                      key: _formKey2,
                      child: CustomTextfield(
                        height: Adaptive.h(10),
                        width: Adaptive.w(88),
                        padding: EdgeInsets.only(left: Adaptive.w(6)),
                        // hintText: passwordFocusNode.hasFocus ? '' : 'Password',
                        labelText: 'Password',
                        controller: passwordController,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value == '') {
                            return '*Please enter your password';
                          }
                          return null;
                        },
                        focusNode: passwordFocusNode,
                        floatingLabelBehavior: passwordFocusNode.hasFocus
                            ? FloatingLabelBehavior.auto
                            : FloatingLabelBehavior.never,
                        obscureText: true,
                        suffixIcon: Icon(
                          Icons.visibility,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Adaptive.h(0),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: Adaptive.w(6)),
                      child: CustomContainer(
                          backgroundColor: AppColors.primary,
                          color: Colors.white,
                          // height: Adaptive.h(6),
                          width: Adaptive.w(88),
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _formKey2.currentState!.validate()) {
                              signIn();
                            }
                          },
                          title: 'LOGIN'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: Adaptive.h(2)),
              child: Text(
                'Version : $appVersion.$buildNumber',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
