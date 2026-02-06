import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:petsmore_tele_app/api/call_summary_api.dart';

import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';

class GetCampaignProvider extends ChangeNotifier {
  bool isError = false;
  bool get getIsError => isError;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  String? _failure;
  String? get failure => _failure;

  String cid = '';
  String get getCid => cid;

  Map responseData = {};
  Map get getResponseData => responseData;

  List dataCampaign = [];
  List get getDataCampaign => dataCampaign;

  List campaignImages = [];
  List get getCampaignImages => campaignImages;

  List campaignAudio = [];
  List get getCampaignAudio => campaignAudio;

  List campaignVideo = [];
  List get getCampaignVideo => campaignVideo;

  void _setFailure(failure) {
    _failure = failure;
    AppDebug().printDebug(msg: 'call summary provider failure: $failure');
    notifyListeners();
  }

  void setFetchingState(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  Future<void> clearData() async {
    isError = false;
    _isFetching = false;
    _failure = null;
    cid = '';
    responseData.clear();
    dataCampaign.clear();
    campaignImages.clear();
    campaignAudio.clear();
    campaignVideo.clear();

    // notifyListeners();
  }

  Future fetchCampaignImages(String cid, {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    notifyListeners();

    try {
      await fetchCampaignImagesAPI(cid);
    } catch (f) {
      AppDebug().printDebug(msg: 'images provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> fetchCampaignImagesAPI(String cid) async {
    String staffcode = await GetSharedPreferences().getuserCode();

    responseData = await CallSummaryAPI().campaignImages(staffcode, cid);
    AppDebug().printDebug(msg: 'images provider res: $responseData');

    if (responseData.isNotEmpty && responseData.containsKey('data')) {
      campaignImages = responseData['data'];
      AppDebug().printDebug(msg: 'campaignImages: $campaignImages');

      // var imagesList = responseData['data'];

      // for (var item in imagesList) {
      //   if (item is Map && item.containsKey('images')) {
      //     var images = item['images'];
      //     var campaignId = item['campaign_id'];

      //     if (images != null) {
      //       // if (!campaignImages
      //       //     .any((element) => element['campaign_id'] == campaignId)) {
      //       campaignImages.add({
      //         'campaign_id': campaignId,
      //         'images': images,
      //       });
      //       // campaignImages = imagesList;
      //       AppDebug().printDebug(msg: 'campaignImages: $campaignImages');
      //       // } else {
      //       //   AppDebug()
      //       //       .printDebug(msg: 'Campaign_id $campaignId already exists.');
      //       // }
      //     } else {
      //       campaignImages = [];
      //       AppDebug()
      //           .printDebug(msg: 'No images for campaign_id: $campaignId');
      //     }
      //   }
      // }
    } else {
      AppDebug().printDebug(msg: 'images provider status 0: $responseData');
    }
    notifyListeners();
  }

  // List<String>? getImagesByCampaignId(int campaignId) {
  //   // Find the campaign image data by campaign_id
  //   var campaignData = campaignImages.firstWhere(
  //     (element) => element['campaign_id'] == campaignId,
  //     orElse: () => null, // Return null if not found
  //   );

  //   // If campaignData is found, return its images; otherwise, return null
  //   if (campaignData != null) {
  //     return List<String>.from(campaignData['images']);
  //   }

  //   // Return null if the campaign_id does not exist in the list
  //   return null;
  // }

  Future fetchCampaignAudio(String campaignId, {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    notifyListeners();

    try {
      await fetchCampaignAudioAPI(campaignId);
    } catch (f) {
      AppDebug().printDebug(msg: 'audio provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> fetchCampaignAudioAPI(String campaignId) async {
    responseData = await CallSummaryAPI().campaignAudio(campaignId);
    AppDebug().printDebug(msg: 'audio provider res: $responseData');

    if (responseData.isNotEmpty &&
        responseData.containsKey('data') &&
        responseData['data'] != null) {
      campaignAudio = responseData['data'];
      AppDebug().printDebug(msg: 'audio campaign: $campaignAudio');
    } else {
      AppDebug().printDebug(msg: 'audio provider status 0: $responseData');
    }
    notifyListeners();
  }

  // List<String>? getAudioByCampaignId(int campaignId) {
  //   // Find the campaign image data by campaign_id
  //   var campaignData = campaignAudio.firstWhere(
  //     (element) => element['campaign_id'] == campaignId,
  //     orElse: () => null, // Return null if not found
  //   );

  //   // If campaignData is found, return its images; otherwise, return null
  //   if (campaignData != null) {
  //     return List<String>.from(campaignData['images']);
  //   }

  //   // Return null if the campaign_id does not exist in the list
  //   return null;
  // }

  Future fetchCampaignVideo(String campaignId, {bool? isFetching}) async {
    _setFailure(null);
    _isFetching = isFetching ?? true;
    notifyListeners();

    try {
      await fetchCampaignVideoAPI(campaignId);
    } catch (f) {
      AppDebug().printDebug(msg: 'video provider f: ${f}');
      _setFailure(f);
      return f;
    } finally {
      _isFetching = false;
      notifyListeners();
    }
    _setFailure(null);
    return responseData;
  }

  Future<void> fetchCampaignVideoAPI(String campaignId) async {
    responseData = await CallSummaryAPI().campaignVideo(campaignId);
    AppDebug().printDebug(msg: 'video provider res: $responseData');

    if (responseData.isNotEmpty && responseData.containsKey('data')) {
      var data = responseData['data'];
      var data2 = responseData['data_2'];
      if (data != null && data.isNotEmpty) {
        campaignVideo = data;
      } else if (data2 != null && data2.isNotEmpty) {
        campaignVideo = data2;
      } else {
        campaignVideo = [];
      }
      AppDebug().printDebug(msg: 'Campaign video data: $campaignVideo');
    } else {
      AppDebug().printDebug(msg: 'video status 0: $responseData');
      campaignVideo = [];
    }
    notifyListeners();
  }
}
