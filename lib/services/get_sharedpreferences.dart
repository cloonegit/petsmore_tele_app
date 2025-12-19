import 'dart:convert';

import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetSharedPreferences {
  setPlatform(String platform) async {
    var platformType;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      platformType = prefs.setString("platform", platform);
    } catch (e) {
      AppDebug().printDebug(msg: 'error set platform $e');
    }
    return platformType;
  }

  getPlatform() async {
    var getPlatformType;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      getPlatformType = prefs.getString("platform") ?? "";
    } catch (e) {
      AppDebug().printDebug(msg: 'error getplatform $e');
    }
    return getPlatformType;
  }

  setLastLoginStatus(bool login) async {
    var loginStatus;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      loginStatus = prefs.setBool("last_login", login);
    } catch (e) {
      AppDebug().printDebug(msg: 'error loginstatus $e');
    }
    return loginStatus;
  }

  getLastLoginStatus() async {
    var getLoginStatus;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      getLoginStatus = prefs.getBool("last_login") ?? false;
    } catch (e) {
      AppDebug().printDebug(msg: 'error loginstatus $e');
    }
    return getLoginStatus;
  }

  setUserInfo({
    String? userID,
    String? userCode,
    String? userName,
    String? userPosition,
    String? userHQStaff,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString("userID", userID ?? "");
      prefs.setString("userCode", userCode ?? "");
      prefs.setString("userName", userName ?? "");
      prefs.setString("userPosition", userPosition ?? "");
      prefs.setString("userHQStaff", userHQStaff ?? "");
    } catch (e) {
      AppDebug().printDebug(msg: 'error set user $e');
    }
  }

  clearUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString("userID", "");
      prefs.setString("userCode", "");
      prefs.setString("userName", "");
      prefs.setString("userPosition", "");
      prefs.setString("userHQStaff", "");
    } catch (e) {
      AppDebug().printDebug(msg: 'error set user $e');
    }
  }

  getUserID() async {
    var userID;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      userID = prefs.getString("userID") ?? "";
    } catch (e) {
      AppDebug().printDebug(msg: 'error set userID $e');
    }
    return userID;
  }

  getUserName() async {
    var userName;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      userName = prefs.getString("userName") ?? "";
    } catch (e) {
      AppDebug().printDebug(msg: 'error set userName $e');
    }
    return userName;
  }

  getuserCode() async {
    var userCode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      userCode = prefs.getString("userCode") ?? "";
    } catch (e) {
      AppDebug().printDebug(msg: 'error set userCode $e');
    }
    return userCode;
  }

  getUserPosition() async {
    var userPosition;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      userPosition = prefs.getString("userPosition") ?? "";
    } catch (e) {
      AppDebug().printDebug(msg: 'error set userPosition $e');
    }
    return userPosition;
  }

  getUserHQStaff() async {
    var userHQStaff;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      userHQStaff = prefs.getString("userHQStaff") ?? "";
    } catch (e) {
      AppDebug().printDebug(msg: 'error set userHQStaff $e');
    }
    return userHQStaff;
  }

  Future<void> setDataInPreferences(
      String key, List<Map<String, dynamic>> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(data);
    prefs.setString(key, jsonData);
  }

  Future<List<Map<String, dynamic>>> getDataFromPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(key);
    if (jsonData != null) {
      List<dynamic> jsonList = jsonDecode(jsonData);
      return List<Map<String, dynamic>>.from(jsonList);
    }
    return []; // Return an empty list if no data is found
  }

  Future<List<Map<String, dynamic>>> getCampaigns() async {
    return await getDataFromPreferences('campaign');
  }

  Future<void> setCampaigns(campaigns) async {
    await setDataInPreferences('campaign', campaigns);
  }

  Future<List<Map<String, dynamic>>> getTabList() async {
    return await getDataFromPreferences('tabList');
  }

  Future<void> setTabList(tabList) async {
    await setDataInPreferences('tabList', tabList);
  }

  Future<List<Map<String, dynamic>>> getCallStatus() async {
    return await getDataFromPreferences('callStatus');
  }

  Future<void> setCallStatus(callStatuses) async {
    await setDataInPreferences('callStatus', callStatuses);
  }

  Future<void> setStringData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString(key, value);
    } catch (e) {
      AppDebug().printDebug(msg: 'error setting string data: $e');
    }
  }

  Future<String> getStringData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = "";
    try {
      value = prefs.getString(key) ?? "";
    } catch (e) {
      AppDebug().printDebug(msg: 'error getting string data: $e');
    }
    return value;
  }

  Future<void> clearAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.clear();
    } catch (e) {
      AppDebug().printDebug(msg: 'error clearing SharedPreferences data: $e');
    }
  }
}
