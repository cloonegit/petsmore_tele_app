import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nrs_tele_apps/api/call_summary_api.dart';
import 'package:nrs_tele_apps/api/converted_api.dart';

import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';

class ConvertedProvider extends ChangeNotifier {
  bool isError = false;
  bool get getIsError => isError;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  List outletList = [];
  List get getOutletList => outletList;

  List custList = [];
  List get getCustList => custList;

  List approachedList = [];
  List get getApproachedList => approachedList;

  List whatsAppData = [];
  List get getwhatsAppData => whatsAppData;

  Map approachedDetails = {};
  Map get getApproachedDetails => approachedDetails;

  String? _failure;
  String? get failure => _failure;

  String cid = '';
  String get getCid => cid;

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
    responseData = await ConvertedAPI().outletList(staffcode);
    // AppDebug().printDebug(msg: 'outlet list provider res: $responseData');

    if (responseData.isNotEmpty && responseData.containsKey('LIST')) {
      outletList = responseData['LIST'];
      AppDebug().printDebug(msg: 'outletList: $outletList');
    } else {
      AppDebug().printDebug(msg: 'outlet list status 0: $responseData');
    }
    notifyListeners();
  }

  Future fetchCustomerList(String? outlet, {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    // notifyListeners();

    try {
      // Check Shared Preferences first
      // await checkSharedPrefs();
      // If no valid data, fetch from API
      // if (tabList.isEmpty) {
      await fetchCustomerListAPI(outlet);
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

  Future<void> fetchCustomerListAPI(String? outlet) async {
    responseData = await ConvertedAPI().customerList(outlet);
    // AppDebug().printDebug(msg: 'outlet list provider res: $responseData');
    var data = responseData['LIST'];
    if (responseData.isNotEmpty && data != null) {
      custList = responseData['LIST'];
      AppDebug().printDebug(msg: 'custList: $custList');
    } else {
      custList = [];
      AppDebug().printDebug(msg: 'custList status 0: $responseData');
    }
    notifyListeners();
  }

  Future fetchApproachedList(String? outlet, {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    // notifyListeners();

    try {
      // Check Shared Preferences first
      // await checkSharedPrefs();
      // If no valid data, fetch from API
      // if (tabList.isEmpty) {
      await fetchApproachedListAPI(outlet);
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

  Future<void> fetchApproachedListAPI(String? outlet) async {
    responseData = await ConvertedAPI().approachedList(outlet);
    // AppDebug().printDebug(msg: 'outlet list provider res: $responseData');
    var data = responseData['LIST'];
    if (responseData.isNotEmpty && data != null) {
      approachedList = responseData['LIST'];
      AppDebug().printDebug(msg: 'approachedList: $approachedList');
    } else {
      approachedList = [];
      AppDebug().printDebug(msg: 'approachedList status 0: $responseData');
    }
    notifyListeners();
  }

  Future fetchApproachDetail(String? cid, {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    // notifyListeners();

    try {
      // Check Shared Preferences first
      // await checkSharedPrefs();
      // If no valid data, fetch from API
      // if (tabList.isEmpty) {
      await fetchApproachDetailAPI(cid);
      // }
    } catch (f) {
      AppDebug().printDebug(msg: 'approachdetails provider f: ${f}');
      _setFailure(f);
      // return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> fetchApproachDetailAPI(String? cid) async {
    responseData = await ConvertedAPI().approachedDetail(cid);
    // AppDebug().printDebug(msg: 'outlet list provider res: $responseData');
    var data = responseData['INFO'] ?? {};
    if (responseData.isNotEmpty && data != null) {
      approachedDetails = responseData['INFO'];
      AppDebug().printDebug(msg: 'approachedDetails: $approachedDetails');
    } else {
      AppDebug().printDebug(msg: 'approachedDetails status 0: $responseData');
    }
    notifyListeners();
  }

  Future approachedSubmit(
      String? cid, String? remarks, String? sontype, String? son,
      {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    // notifyListeners();

    try {
      // Check Shared Preferences first
      // await checkSharedPrefs();
      // If no valid data, fetch from API
      // if (tabList.isEmpty) {
      await approachedSubmitAPI(cid, remarks, sontype, son);
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

  Future<void> approachedSubmitAPI(
      String? cid, String? remarks, String? sontype, String? son) async {
    responseData =
        await ConvertedAPI().approachedSubmit(cid, remarks, sontype, son);
    // AppDebug().printDebug(msg: 'outlet list provider res: $responseData');
    // var data = responseData['LIST'];
    if (responseData.isNotEmpty && responseData['status'] == '1') {
      AppDebug().printDebug(msg: 'approachedSubmit: $responseData');
    } else {
      AppDebug().printDebug(msg: 'approachedSubmit status 0: $responseData');
    }
    notifyListeners();
  }

  Future fetchWhatsappMsg() async {
    _setFailure(null);
    _isFetching = true;
    notifyListeners();

    try {
      await fetchWhatsappMsgAPI();
    } catch (f) {
      AppDebug().printDebug(msg: 'whatsapp provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> fetchWhatsappMsgAPI() async {
    String staffcode = await GetSharedPreferences().getuserCode();
    AppDebug().printDebug(msg: 'getcid in provider is empty: $getCid');

    if (getCid != '' || getCid.isNotEmpty) {
      responseData = await CallSummaryAPI().whatsApp(staffcode, getCid);
    } else {
      AppDebug().printDebug(msg: 'cid in provider is empty: $cid');
    }
    // AppDebug().printDebug(msg: 'whatsapp provider res: $responseData');

    if (responseData['status'] == '1') {
      if (responseData.containsKey('list') &&
          responseData['list'] is List &&
          responseData['list'].isNotEmpty) {
        whatsAppData = responseData['list'];
        // campaignId=responseData['CAMPAIGN_ID'];
        AppDebug().printDebug(msg: 'WHATSAPP DATA:$whatsAppData');
      } else {
        AppDebug().printDebug(msg: 'No whatsapp data found or it is empty.');
      }
    } else {
      AppDebug().printDebug(msg: 'SMS provider status 0: $responseData');
    }
    notifyListeners();
  }
}
