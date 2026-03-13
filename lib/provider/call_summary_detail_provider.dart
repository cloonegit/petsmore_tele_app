// import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:petsmore_tele_app/api/call_summary_api.dart';
// import 'package:petsmore_tele_app/api/home_api.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';

class CallSummaryDetailProvider extends ChangeNotifier {
  bool isError = false;
  bool get getIsError => isError;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  bool ableCallStatus = false;
  bool get getableCallStatus => ableCallStatus;

  bool ableNoAnswer = false;
  bool get getableNoAnswer => ableNoAnswer;

  bool _isSubmitRemark = false;
  bool get getSubmitRemark => _isSubmitRemark;

  String? _failure;
  String? get failure => _failure;

  String cid = '';
  String get getCid => cid;

  Map responseData = {};
  Map get getResponseData => responseData;

  Map infoData = {};
  Map get getInfoData => infoData;

  List remarks = [];
  List get getRemarks => remarks;

  List teleproductData = [];
  List get getTeleproductData => teleproductData;

  String reason = '';
  String get getReason => reason;

  String reasonType = '';
  String get getReasonType => reasonType;

  String reasonProduct = '';
  String get getReasonProduct => reasonProduct;

  String businessCard = '';
  String get getBusinessCard => businessCard;

  String campaignId = '';
  String get getCampaignId => campaignId;

  String leadCampaignId = '';
  String get getLeadCampaignId => leadCampaignId;

  String campaignName = '';
  String get getCampaignName => campaignName;

  String campaignTypeId = '';
  String get getCampaignTypeId => campaignTypeId;

  String whatsAppUrl = '';
  String get getWhatsAppUrl => whatsAppUrl;

  String whatsappErrorMsg = '';
  String get getwhatsappErrorMsg => whatsappErrorMsg;

  dynamic countWhatsappLog = 0;
  dynamic get getcountWhatsappLog => countWhatsappLog;

  List dataCampaign = [];
  List get getDataCampaign => dataCampaign;

  List callInfo2 = [];
  List get getCallInfo2 => callInfo2;

  List shareImages = [];
  List get getShareImages => shareImages;

  List shareAudio = [];
  List get getShareAudio => shareAudio;

  List shareVideo = [];
  List get getShareVideo => shareVideo;

  List whatsAppData = [];
  List get getwhatsAppData => whatsAppData;

  List SMSData = [];
  List get getSMSData => SMSData;

  Map selection = {};
  Map get getSelection => selection;

  void _setFailure(failure) {
    _failure = failure?.toString();
    AppDebug().printDebug(msg: 'call summary provider failure: $failure');
    notifyListeners();
  }

  void setFetchingState(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  Future<void> setSubmitRemarks(bool value) async {
    _isSubmitRemark = value;
    AppDebug().printDebug(msg: 'getSubmitRemark provider: $getSubmitRemark');
    notifyListeners();
  }

  void setCID(getCid) {
    cid = getCid;
    AppDebug().printDebug(msg: 'CID provider: $getCid');
    notifyListeners();
  }

  void setReason(getReason) {
    reason = getReason;
    AppDebug().printDebug(msg: 'reason provider: $getReason');
    notifyListeners();
  }

  void setReasonType(getReasonType) {
    reasonType = getReasonType;
    AppDebug().printDebug(msg: 'getReasonType provider: $getReasonType');
    notifyListeners();
  }

  void setReasonProduct(getReasonProduct) {
    reasonProduct = getReasonProduct;
    AppDebug().printDebug(msg: 'getReasonProduct provider: $getReasonProduct');
    notifyListeners();
  }

  Future<void> clearData() async {
    isError = false;
    _isFetching = false;
    ableCallStatus = false;
    ableNoAnswer = false;
    _failure = null;
    cid = '';
    responseData.clear();
    infoData.clear();
    remarks.clear();
    teleproductData.clear();
    reason = '';
    reasonType = '';
    reasonProduct = '';
    businessCard = '';
    campaignId = '';
    leadCampaignId = '';
    campaignName = '';
    campaignTypeId = '';
    whatsAppUrl = '';
    whatsappErrorMsg = '';
    countWhatsappLog = 0;
    dataCampaign.clear();
    callInfo2.clear();
    shareImages.clear();
    shareAudio.clear();
    shareVideo.clear();
    whatsAppData.clear();
    SMSData.clear();
    selection.clear();

    // Notify listeners that data has changed
    notifyListeners();
  }

  void setCampaignId(getCampaignId) {
    campaignId = getCampaignId;
    AppDebug().printDebug(msg: 'getCampaignId provider: $getCampaignId');
    notifyListeners();
  }

  Future fetchCallSummaryDetail(String cid, {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    // notifyListeners();

    try {
      // Check Shared Preferences first
      // await checkSharedPrefs();
      // If no valid data, fetch from API
      // if (tabList.isEmpty) {
      await fetchCallSummaryDetailAPI(cid);
      // }
    } catch (f) {
      AppDebug().printDebug(msg: 'call summary provider f: ${f}');
      _setFailure(f);
      // return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> fetchCallSummaryDetailAPI(String cid) async {
    String staffcode = await GetSharedPreferences().getuserCode();
    String platformType = await GetSharedPreferences().getPlatform();

    responseData =
        await CallSummaryAPI().callSummaryDetail(staffcode, platformType, cid);
    AppDebug();
    if (responseData != null &&
        responseData.isNotEmpty &&
        responseData.containsKey('INFO')) {
      if (_isSubmitRemark) {
        remarks = responseData['REMARK'] ?? [];
        return;
      }
      remarks = responseData['REMARK'] ?? [];
      dataCampaign = responseData['DataCampaign'] ?? [];
      callInfo2 = responseData['CALL_INFO_2'] ?? [];

      leadCampaignId = responseData['CAMPAIGN_ID'] ?? '';
      campaignTypeId = responseData['CAMPAIGN_TYPE_ID'] ?? '';
      countWhatsappLog = responseData['COUNT_WHATSAPP_LOG'] ?? [];
      whatsappErrorMsg = responseData['WHATSAPP_ERR_MESSAGE'] ?? [];

      infoData = responseData['INFO'];
      teleproductData = infoData['TELEPRODUCT'] ?? [];
      // whatsAppUrl = infoData['WHATSAPP_URL'] ?? [];
      ableNoAnswer = infoData['ABLE_NOANSWER'] ?? [];
      ableCallStatus = infoData['ABLE_CALLSTATUS'] ?? [];
      selection = infoData['SELECTION'] ?? {};

      AppDebug().printDebug(msg: 'selection: $selection');
      // AppDebug().printDebug(msg: 'whatsappErrorMsg: $whatsappErrorMsg');

      // AppDebug().printDebug(
      //     msg:
      //         'campaigntypeId: $campaignTypeId...$ableNoAnswer...$ableCallStatus');

      // AppDebug().printDebug(msg: 'leadCampaignId: $leadCampaignId');
      // AppDebug().printDebug(msg: 'whatsAppUrl: $whatsAppUrl');

      AppDebug().printDebug(msg: 'dataCampaign: $dataCampaign');
    } else {
      AppDebug().printDebug(
          msg: 'call summary detail provider status 0: $responseData');
    }
    notifyListeners();
  }

  Future fetchBusinessCard() async {
    _setFailure(null);
    _isFetching = true;
    notifyListeners();

    try {
      await fetchBusinessCardAPI();
    } catch (f) {
      AppDebug().printDebug(msg: 'business card provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> fetchBusinessCardAPI() async {
    String staffcode = await GetSharedPreferences().getuserCode();
    AppDebug().printDebug(msg: 'getcid in provider is empty: $getCid');

    if (getCid != '' || getCid.isNotEmpty) {
      responseData = await CallSummaryAPI().businessCard(staffcode, getCid);
    } else {
      AppDebug().printDebug(msg: 'cid in provider is empty: $cid');
    }
    AppDebug().printDebug(msg: 'business card provider res: $responseData');

    if (responseData != null &&
        responseData.isNotEmpty &&
        responseData['status'] == '1') {
      businessCard = responseData['images'];
    } else {
      AppDebug()
          .printDebug(msg: 'business card provider status 0: $responseData');
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
    AppDebug().printDebug(msg: 'whatsapp provider res: $responseData');

    if (responseData != null &&
        responseData.isNotEmpty &&
        responseData['status'] == '1') {
      if (responseData.containsKey('list') &&
          responseData['list'] is List &&
          responseData['list'].isNotEmpty) {
        whatsAppData = [];
        whatsAppData = responseData['list'];
        // campaignId=responseData['CAMPAIGN_ID'];
        AppDebug().printDebug(msg: 'WHATSAPP DATA:$whatsAppData');
      } else {
        AppDebug().printDebug(msg: 'No whatsapp data found or it is empty.');
      }

      if (responseData.containsKey('DWData_test') &&
          responseData['DWData_test'] is List &&
          responseData['DWData_test'].isNotEmpty) {
        SMSData = responseData['DWData_test'];
        AppDebug().printDebug(msg: 'SMS DATA:$SMSData');
      } else {
        AppDebug().printDebug(msg: 'No SMS data found or it is empty.');
      }
    } else {
      AppDebug().printDebug(msg: 'SMS provider status 0: $responseData');
    }
    notifyListeners();
  }

  Future submitRemarks(String callStatus, String remarksMsg,
      {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    notifyListeners();

    try {
      await submitRemarksAPI(callStatus, remarksMsg);
    } catch (f) {
      AppDebug().printDebug(msg: 'call summary provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> submitRemarksAPI(String callStatus, String remarksMsg) async {
    String staffcode = await GetSharedPreferences().getuserCode();
    String platformType = await GetSharedPreferences().getPlatform();
    if (getCid != '' || getCid.isNotEmpty) {
      AppDebug().printDebug(
          msg:
              'details in submitRemarksAPI: $callStatus, $remarksMsg ,$getCid');

      responseData = await CallSummaryAPI().submitRemarks(
          platformType, staffcode, getCid, callStatus, remarksMsg);
      AppDebug().printDebug(msg: 'submit remarks  provider res: $responseData');
    } else {
      AppDebug().printDebug(msg: 'cid is emtpy in submit remarks API: ');
    }

    if (responseData != null &&
        responseData.isNotEmpty &&
        responseData['status'] == '1') {
      //success submit remarks
    } else {
      AppDebug()
          .printDebug(msg: 'submit remarks provider status 0: $responseData');
    }
    notifyListeners();
  }

  Future submitWhatsAppLog(String cid, String campaignId, int countWhatsappLog,
      {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    notifyListeners();

    try {
      await submitWhatsAppLogAPI(cid, campaignId, countWhatsappLog);
    } catch (f) {
      AppDebug().printDebug(msg: 'call summary provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> submitWhatsAppLogAPI(
      String cid, String campaignId, int countWhatsappLog) async {
    String staffcode = await GetSharedPreferences().getuserCode();
    String platformType = await GetSharedPreferences().getPlatform();
    if (getCid != '' || getCid.isNotEmpty) {
      responseData = await CallSummaryAPI().whatsAppLog(
          staffcode, cid, campaignId, platformType, countWhatsappLog);

      // AppDebug().printDebug(
      //     msg:
      //         'submit wa  provider res: $responseData...$staffcode, $cid, $campaignId, $platformType, $countWhatsappLog');
    } else {
      AppDebug().printDebug(msg: 'cid is emtpy in submit remarks API: ');
    }

    if (responseData != null &&
        responseData.isNotEmpty &&
        responseData['status'] == '1') {
    } else {
      AppDebug()
          .printDebug(msg: 'submit remarks provider status 0: $responseData');
    }
    notifyListeners();
  }

  Future submitSMSLog(String number, String msg, {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    notifyListeners();

    try {
      await submitSMSLogAPI(number, msg);
    } catch (f) {
      AppDebug().printDebug(msg: 'sms provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> submitSMSLogAPI(
    String number,
    String msg,
  ) async {
    responseData = await CallSummaryAPI().smsLog(number, msg);

    if (responseData != null &&
        responseData.isNotEmpty &&
        responseData['status'] == '1') {
      AppDebug()
          .printDebug(msg: 'submit sms  provider res status 1: $responseData');
    } else {
      AppDebug().printDebug(msg: 'submit sms provider status 0: $responseData');
    }
    notifyListeners();
  }

  Future<void> compareCampaignName(String campaignName) async {
    // for (var callInfo in callInfo2) {
    //   var campaignName2 = callInfo['campaign_name'];

    for (var campaign in dataCampaign) {
      var dataCampaignName = campaign['campaign_name'];

      if (campaignName == dataCampaignName) {
        campaignId = campaign['id'];
        break;
      }
    }
    // }

    AppDebug().printDebug(msg: 'campaignId:$campaignId');
    notifyListeners();
  }
}
