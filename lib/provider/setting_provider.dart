import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:petsmore_tele_app/api/settings_api.dart';

import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';

class SettingProvider extends ChangeNotifier {
  bool isError = false;
  bool get getIsError => isError;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  String? _failure;
  String? get failure => _failure;

  Map responseData = {};
  Map get getResponseData => responseData;

  Map infoData = {};
  Map get getInfoData => infoData;

  void _setFailure(failure) {
    _failure = failure;
    AppDebug().printDebug(msg: 'setting provider failure: $failure');
    notifyListeners();
  }

  Future<void> clearData() async {
    isError = false;
    _isFetching = false;
    _failure = null;
    responseData.clear();
    infoData.clear();
    // notifyListeners();
  }

  Future fetchSetting() async {
    _setFailure(null);
    _isFetching = true;
    notifyListeners();

    try {
      await fetchSettingAPI();
    } catch (f) {
      AppDebug().printDebug(msg: 'setting provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> fetchSettingAPI() async {
    String staffcode = await GetSharedPreferences().getuserCode();
    responseData = await SettingAPI().setting(staffcode);
    AppDebug().printDebug(msg: 'setting provider res: $responseData');

    if (responseData != null && responseData.isNotEmpty && responseData['status'] == '1') {
      infoData = responseData['INFO'];
      notifyListeners();
    } else {
      AppDebug().printDebug(msg: 'setting provider status 0: $responseData');
    }
  }

  Future submitEditInfo(
      String? staffName,
      String? staffContact,
      String? outletAddress,
      String? outletContact,
      // profilePic,
      imageByte) async {
    _setFailure(null);
    _isFetching = true;
    notifyListeners();

    try {
      await submitEditInfoAPI(
          staffName, staffContact, outletAddress, outletContact, imageByte);
    } catch (f) {
      AppDebug().printDebug(msg: 'setting provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> submitEditInfoAPI(String? staffName, String? staffContact,
      String? outletAddress, String? outletContact, imageByte) async {
    String staffcode = await GetSharedPreferences().getuserCode();

    responseData = await SettingAPI().updateSetting(staffName, staffcode,
        staffContact, outletAddress, outletContact, imageByte);

    AppDebug().printDebug(msg: 'setting provider res: $responseData');

    if (responseData['status'] == '1') {
      notifyListeners();
      return responseData['status_message'];
    } else {
      AppDebug().printDebug(msg: 'setting provider status 0: $responseData');
    }
  }
}
