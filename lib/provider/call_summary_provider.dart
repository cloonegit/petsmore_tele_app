// import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nrs_tele_apps/api/call_summary_api.dart';
// import 'package:nrs_tele_apps/api/home_api.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';

class CallSummaryProvider extends ChangeNotifier {
  bool isError = false;
  bool get getIsError => isError;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  String? _failure;
  String? get failure => _failure;

  Map responseData = {};
  Map get getResponseData => responseData;

  List tabList = [];
  List get getTabList => tabList;

  List allList = [];
  List get getallList => allList;

  List noAnswerList = [];
  List get getnoAnswerList => noAnswerList;

  List newLeadList = [];
  List get getnewLeadList => newLeadList;

  List interestedList = [];
  List get getinterestedList => interestedList;

  List followUpList = [];
  List get getfollowUpList => followUpList;

  List makePurchaseList = [];
  List get getmakePurchaseList => makePurchaseList;

  List rejectedList = [];
  List get getrejectedList => rejectedList;

  List campaignList = [];
  List get getCampaignList => campaignList;

  List allCampaignList = [];
  List get getAllCampaignList => allCampaignList;

  String campaignFilter = '';
  String get getcampaignFilter => campaignFilter;

  void _setFailure(failure) {
    _failure = failure;
    AppDebug().printDebug(msg: 'call summary provider failure: $failure');
    notifyListeners();
  }

  Future<void> clearData() async {
    isError = false;
    _isFetching = false;
    _failure = null;
    responseData.clear();
    tabList.clear();
    allList.clear();
    noAnswerList.clear();
    newLeadList.clear();
    interestedList.clear();
    followUpList.clear();
    makePurchaseList.clear();
    rejectedList.clear();
    campaignList.clear();
    allCampaignList.clear();
    campaignFilter = '';

    // notifyListeners();
  }

  void setCampaignFilter(String campaign_filter) {
    campaignFilter = campaign_filter;
    AppDebug().printDebug(
        msg: 'call summary provider campaignFilter: $campaignFilter');
    notifyListeners();
  }

  Future fetchCallSummary() async {
    _setFailure(null);
    // _isFetching = true;
    // notifyListeners();

    try {
      // Check Shared Preferences first
      // await checkSharedPrefs();
      // If no valid data, fetch from API
      // if (tabList.isEmpty) {
      await fetchCallSummaryAPI();
      // }
    } catch (f) {
      AppDebug().printDebug(msg: 'call summary provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      // _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  // Future<void> checkSharedPrefs() async {
  //   tabList = await GetSharedPreferences().getTabList();
  //   AppDebug().printDebug(msg: 'tabList:$tabList');

  //   // DWAll_Campaign =
  //   //     await GetSharedPreferences().getStringData('DWAll_Campaign');
  //   // CAMPAIGN = await GetSharedPreferences().getStringData('CAMPAIGN');

  //   if (tabList.isNotEmpty) {
  //     AppDebug().printDebug(msg: 'Loaded data from Shared Preferences');
  //     notifyListeners();
  //   }
  // }

  Future<void> checkCampaignList(dynamic responseData) async {
    if (responseData.containsKey('CAMPAIGN') &&
        responseData['CAMPAIGN'] != null &&
        responseData['CAMPAIGN'] != '') {
      campaignList = List<Map<String, dynamic>>.from(responseData['CAMPAIGN']);
      // AppDebug().printDebug(
      //     msg: 'In call summary provider(campaignList): $campaignList');

      final newCategory = {
        "NAME": "ALL",
        "NUM": allList.length.toString(),
        "ID": "ALL",
      };

      // Remove any existing "ALL" category to avoid duplication
      campaignList.removeWhere((element) => element["ID"] == "ALL");

      // Add the new category for "ALL"
      campaignList.insert(0, newCategory); // Insert at the start if needed

      // AppDebug().printDebug(
      //     msg:
      //         'In call summary provider(campaignList) after adding ALL category: $campaignList');
    } else {
      AppDebug().printDebug(
          msg: 'In call summary provider(campaignList) IS NULL: $campaignList');
    }
  }

  Future<void> checkAllCampaignList(dynamic responseData) async {
    if (responseData.containsKey('DWAll_Campaign') &&
        responseData['DWAll_Campaign'] != null &&
        responseData['DWAll_Campaign'] != '') {
      allCampaignList =
          List<Map<String, dynamic>>.from(responseData['DWAll_Campaign']);
      AppDebug().printDebug(
          msg: 'In call summary provider(allCampaignList): $allCampaignList');
    } else {
      AppDebug().printDebug(
          msg:
              'In call summary provider(allCampaignList) IS NULL: $allCampaignList');
    }
  }

  Future<void> checkTabList(dynamic responseData) async {
    if (responseData.containsKey('TAB') &&
        responseData['TAB'] != null &&
        responseData['TAB'] != '') {
      tabList = List<Map<String, dynamic>>.from(responseData['TAB']);
      AppDebug().printDebug(msg: 'In call summary provider(tabList): $tabList');
    } else {
      AppDebug().printDebug(
          msg: 'In call summary provider(tabList) IS NULL: $tabList');
    }
  }

  Future<void> checkRejectedList(dynamic responseData) async {
    // AppDebug().printDebug(msg: 'response data(rejectedList): $responseData');
    if (responseData.containsKey('LIST') &&
        responseData['LIST']['REJECTED_DETAIL'] != null &&
        responseData['LIST']['REJECTED_DETAIL'] != '') {
      rejectedList = List<Map<String, dynamic>>.from(
          responseData['LIST']['REJECTED_DETAIL']);
      AppDebug().printDebug(
          msg: 'In call summary provider(rejectedList): $rejectedList');
    } else {
      rejectedList = [];
      AppDebug().printDebug(
          msg: 'In call summary provider(rejectedList) IS NULL: $rejectedList');
    }
  }

  Future<void> checkNoAnswerList(dynamic responseData) async {
    if (responseData.containsKey('LIST') &&
        responseData['LIST']['NO_ANSWER_DETAIL'] != null &&
        responseData['LIST']['NO_ANSWER_DETAIL'] != '') {
      noAnswerList = List<Map<String, dynamic>>.from(
          responseData['LIST']['NO_ANSWER_DETAIL']);
      AppDebug().printDebug(
          msg: 'In call summary provider(noAnswerList): $noAnswerList');
    } else {
      noAnswerList = [];
      AppDebug().printDebug(
          msg: 'In call summary provider(noAnswerList) IS NULL: $noAnswerList');
    }
  }

  Future<void> checkFollowUpList(dynamic responseData) async {
    if (responseData.containsKey('LIST') &&
        responseData['LIST']['CALLL_ATER_DETAIL'] != null &&
        responseData['LIST']['CALLL_ATER_DETAIL'] != '') {
      followUpList = List<Map<String, dynamic>>.from(
          responseData['LIST']['CALLL_ATER_DETAIL']);
      AppDebug().printDebug(
          msg: 'In call summary provider(followUpList): $followUpList');
    } else {
      followUpList = [];
      AppDebug().printDebug(
          msg: 'In call summary provider(followUpList) IS NULL: $followUpList');
    }
  }

  Future<void> checkNewLeadList(dynamic responseData) async {
    if (responseData.containsKey('LIST') &&
        responseData['LIST']['NEW_LEAD_DETAIL'] != null &&
        responseData['LIST']['NEW_LEAD_DETAIL'] != '') {
      newLeadList = List<Map<String, dynamic>>.from(
          responseData['LIST']['NEW_LEAD_DETAIL']);
      AppDebug().printDebug(
          msg: 'In call summary provider(newLeadList): $newLeadList');
    } else {
      newLeadList = [];
      AppDebug().printDebug(
          msg: 'In call summary provider(newLeadList) IS NULL: $newLeadList');
    }
  }

  Future<void> checkInterestedList(dynamic responseData) async {
    if (responseData.containsKey('LIST') &&
        responseData['LIST']['INTERESTED_DETAIL'] != null &&
        responseData['LIST']['INTERESTED_DETAIL'] != '') {
      interestedList = List<Map<String, dynamic>>.from(
          responseData['LIST']['INTERESTED_DETAIL']);
      AppDebug().printDebug(
          msg: 'In call summary provider(interestedList): $interestedList');
    } else {
      interestedList = [];
      AppDebug().printDebug(
          msg:
              'In call summary provider(interestedList) IS NULL: $interestedList');
    }
  }

  Future<void> checkMakePurchaseList(dynamic responseData) async {
    if (responseData.containsKey('LIST') &&
        responseData['LIST']['CONVERTED_DETAIL'] != null &&
        responseData['LIST']['CONVERTED_DETAIL'] != '') {
      makePurchaseList = List<Map<String, dynamic>>.from(
          responseData['LIST']['CONVERTED_DETAIL']);
      AppDebug().printDebug(
          msg: 'In call summary provider(makePurchaseList): $makePurchaseList');
    } else {
      makePurchaseList = [];
      // makePurchaseList =
      //     List<Map<String, dynamic>>.from(responseData['LIST'][""]);
      AppDebug().printDebug(
          msg:
              'In call summary provider(makePurchaseList) IS NULL: $makePurchaseList');
    }
  }

  Future<void> addAllList() async {
    allList.clear();
    allList
      ..addAll(newLeadList)
      ..addAll(interestedList)
      ..addAll(followUpList)
      ..addAll(noAnswerList)
      ..addAll(makePurchaseList)
      ..addAll(rejectedList);

    AppDebug().printDebug(msg: 'In call summary provider(allList): $allList');

    final newCategory = {
      "NAME": "ALL",
      "NUM": allList.length.toString(),
      "ID": "ALL",
    };

    // Remove any existing "ALL" category to avoid duplication
    tabList.removeWhere((element) => element["ID"] == "ALL");

    // Add the new category for "ALL"
    tabList.insert(0, newCategory); // Insert at the start if needed

    AppDebug().printDebug(
        msg:
            'In call summary provider(tabList) after adding ALL category: $tabList');
  }

  Future<void> fetchCallSummaryAPI() async {
    String staffcode = await GetSharedPreferences().getuserCode();
    responseData = await CallSummaryAPI().callSummary(staffcode);
    AppDebug().printDebug(msg: 'call summary provider res: $responseData');

    if (responseData['status'] == '1') {
      await checkCampaignList(responseData);
      await checkAllCampaignList(responseData);
      await checkTabList(responseData);
      await checkRejectedList(responseData);
      await checkNoAnswerList(responseData);
      await checkFollowUpList(responseData);
      await checkNewLeadList(responseData);
      await checkInterestedList(responseData);
      await checkMakePurchaseList(responseData);
      await addAllList();

      // Save data to Shared Preferences
      await GetSharedPreferences().setTabList(tabList);
      notifyListeners();
    } else {
      AppDebug()
          .printDebug(msg: 'call summary provider status 0: $responseData');
    }
  }
}
