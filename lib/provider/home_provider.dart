import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nrs_tele_apps/api/home_api.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/app_logout.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:nrs_tele_apps/widgets/dialog_global.dart';
import 'package:nrs_tele_apps/widgets/global_utils.dart';

class HomeProvider extends ChangeNotifier {
  bool isError = false;
  bool get getIsError => isError;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  String? _failure;
  String? get failure => _failure;

  Map responseData = {};
  Map get getResponseData => responseData;

  List callStatusList = [];
  List campaignList = [];

  String listTitle = '';
  String campaignTitle = '';

  void _setFailure(failure) {
    _failure = failure;
    AppDebug().printDebug(msg: 'home provider failure: $failure');
    notifyListeners();
  }

  Future<void> clearData() async {
    isError = false;
    _isFetching = false;
    _failure = null;
    responseData.clear();
    callStatusList.clear();
    campaignList.clear();
    listTitle = '';
    campaignTitle = '';

    // notifyListeners();
  }

  Future fetchHome(BuildContext context, WidgetRef ref) async {
    _setFailure(null);
    _isFetching = true;
    notifyListeners();

    try {
      // Check Shared Preferences first
      // await checkSharedPrefs();
      // If no valid data, fetch from API
      // if (callStatusList.isEmpty || campaignList.isEmpty) {
      await fetchDataAPI(context, ref);
      // }
    } catch (f) {
      AppDebug().printDebug(msg: 'home provider f: ${f}');
      if (f.toString() != "") {
        // await AppLogout().logout(context, ref);
      }
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> checkSharedPrefs() async {
    callStatusList = await GetSharedPreferences().getCallStatus();
    campaignList = await GetSharedPreferences().getCampaigns();
    listTitle = await GetSharedPreferences().getStringData('list_title');
    campaignTitle =
        await GetSharedPreferences().getStringData('campaign_title');

    if (callStatusList.isNotEmpty && campaignList.isNotEmpty) {
      AppDebug().printDebug(msg: 'Loaded data from Shared Preferences');
      notifyListeners();
    }
  }

  Future<void> fetchDataAPI(BuildContext context, WidgetRef ref) async {
    // If no data in shared preferences, fetch from API
    String staffcode = await GetSharedPreferences().getuserCode();
    responseData = await HomeAPI().home(staffcode);
    AppDebug().printDebug(msg: 'home provider res: $responseData');

    if (responseData['status'] == '1') {
      // Process and save data
      listTitle = responseData['LIST_TITLE'] ?? '';
      campaignTitle = responseData['CAMPAIGN_TITLE'] ?? '';
      callStatusList = List<Map<String, dynamic>>.from(responseData['LIST']);
      campaignList = List<Map<String, dynamic>>.from(responseData['CAMPAIGN']);

      // Save data to Shared Preferences
      await GetSharedPreferences().setStringData('list_title', listTitle);
      await GetSharedPreferences()
          .setStringData('campaign_title', campaignTitle);
      await GetSharedPreferences().setCallStatus(callStatusList);
      await GetSharedPreferences().setCampaigns(campaignList);
      notifyListeners();
    } else {
      // await AppLogout().logout(context, ref);
      AppDebug().printDebug(msg: 'home provider status 0: $responseData');

      // GlobalUtils.showFloatingMessage(context, responseData['status_message']);
    }
  }
}
