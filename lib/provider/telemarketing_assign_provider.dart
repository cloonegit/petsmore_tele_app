import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:petsmore_tele_app/api/call_summary_api.dart';
import 'package:petsmore_tele_app/api/telemarketer_assign.dart';

import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';

class TelemarketingAssignProvider extends ChangeNotifier {
  bool isError = false;
  bool get getIsError => isError;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  String? _failure;
  String? get failure => _failure;

  String cid = '';
  String get getCid => cid;

  List outletList = [];
  List get getOutletList => outletList;

  List telemarketerList = [];
  List get getTelemarketerList => telemarketerList;

  Map responseData = {};
  Map get getResponseData => responseData;

  void _setFailure(failure) {
    _failure = failure;
    AppDebug().printDebug(msg: 'call summary provider failure: $failure');
    notifyListeners();
  }

  void setFetchingState(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  void setCID(getCid) {
    cid = getCid;
    AppDebug().printDebug(msg: 'CID provider: $getCid');
    notifyListeners();
  }

  Future<void> clearData() async {
    isError = false;
    _isFetching = false;
    _failure = null;
    cid = '';
    responseData.clear();

    notifyListeners();
  }

  Future fetchOutletList({bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    // notifyListeners();

    try {
      // Check Shared Preferences first
      // await checkSharedPrefs();
      // If no valid data, fetch from API
      // if (tabList.isEmpty) {
      await fetchOutletListAPI();
      // }
    } catch (f) {
      AppDebug().printDebug(msg: 'outlet list provider f: ${f}');
      _setFailure(f);
      // return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> fetchOutletListAPI() async {
    String staffcode = await GetSharedPreferences().getuserCode();

    responseData = await TelemarketerAssignAPI().outletList(staffcode);
    AppDebug().printDebug(msg: 'outlet list provider res: $responseData');

    if (responseData.isNotEmpty && responseData.containsKey('LIST')) {
      outletList = responseData['LIST'];
      AppDebug().printDebug(msg: 'outletList: $outletList');
    } else {
      AppDebug().printDebug(msg: 'outlet list status 0: $responseData');
    }
    notifyListeners();
  }

  Future fetchTelemarketerList(String? outlet, {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    // notifyListeners();

    try {
      // Check Shared Preferences first
      // await checkSharedPrefs();
      // If no valid data, fetch from API
      // if (tabList.isEmpty) {
      await fetchTelemarketerListAPI(outlet);
      // }
    } catch (f) {
      AppDebug().printDebug(msg: 'outlet list provider f: ${f}');
      _setFailure(f);
      // return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> fetchTelemarketerListAPI(String? outlet) async {
    String staffcode = await GetSharedPreferences().getuserCode();

    responseData =
        await TelemarketerAssignAPI().telemarketerList(staffcode, outlet);
    AppDebug().printDebug(msg: 'outlet list provider res: $responseData');
    var res = responseData;
    if (responseData.isNotEmpty && res != '') {
      telemarketerList = responseData['LIST'];
      AppDebug().printDebug(msg: 'outletList: $outletList');
    } else {
      AppDebug().printDebug(msg: 'outlet list status 0: $responseData');
    }
    notifyListeners();
  }

  Future setTelemarketerAssign(String? assign, String? outlet,
      {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    // notifyListeners();

    try {
      // Check Shared Preferences first
      // await checkSharedPrefs();
      // If no valid data, fetch from API
      // if (tabList.isEmpty) {
      await telemarketerAssignAPI(assign, outlet);
      // }
    } catch (f) {
      AppDebug().printDebug(msg: 'outlet list provider f: ${f}');
      _setFailure(f);
      // return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> telemarketerAssignAPI(String? assign, String? outlet) async {
    String staffcode = await GetSharedPreferences().getuserCode();

    responseData = await TelemarketerAssignAPI()
        .telemarketerAssign(staffcode, assign, outlet);
    AppDebug().printDebug(msg: 'telemarketerList provider res: $responseData');
    var res = responseData;
    if (responseData['status'] == '1') {
      // AppDebug().printDebug(msg: 'telemarketerList: $res');
    } else {
      AppDebug().printDebug(msg: 'telemarketerList status 0: $responseData');
    }
    notifyListeners();
  }
}
