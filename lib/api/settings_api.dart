import 'dart:convert';
import 'dart:io';
import 'package:petsmore_tele_app/api/api_manager.dart';
import 'package:petsmore_tele_app/api/global_api.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:http/http.dart' as http;
import 'package:petsmore_tele_app/services/get_it.dart';

class SettingAPI {
  Future<Map> setting(String? staffCode) async {
    String url = '${GlobalAPI().setting}?staffcode=${staffCode}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'setting  api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'setting api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'setting error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response ?? {};
  }

  // Future<Map> updateSetting(
  //     String? staffName,
  //     String staffCode,
  //     String? staffContact,
  //     String? outletAddress,
  //     String? outletContact,
  //     imageBytes) async {
  //   String url =
  //       '${GlobalAPI().updateSetting}?staffName=${staffName}&staffCode=${staffCode}&staffContact=${staffContact}&outletAddress=${outletAddress}&outletContact=${outletContact}&profile_pic=${imageBytes}';

  //   DateTime currentTime = DateTime.now();
  //   AppDebug().printDebug(msg: 'setting  api body : $url   $currentTime');
  //   var response;
  //   try {
  //     response = await APIManager()
  //         .postAPICall(url, {}).timeout(Duration(seconds: GlobalAPI().timeout));
  //     AppDebug().printDebug(msg: 'setting api response : $response');
  //   } catch (e) {
  //     AppDebug().printDebug(msg: 'setting error $e');
  //   }

  //   return response;
  // }

  Future<Map> updateSetting(
      String? staffName,
      String staffCode,
      String? staffContact,
      String? outletAddress,
      String? outletContact,
      String? base64Image) async {
    String url = GlobalAPI().updateSetting;

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['staffName'] = staffName ?? '';
    request.fields['staffCode'] = staffCode;
    request.fields['staffContact'] = staffContact ?? '';
    request.fields['outletAddress'] = outletAddress ?? '';
    request.fields['outletContact'] = outletContact ?? '';

    if (base64Image != null) {
      request.fields['profile_pic'] = base64Image;
    } else {
      AppDebug().printDebug(msg: 'No Base64 image provided.');
    }

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      AppDebug().printDebug(msg: 'API response: ${responseData.body}');

      return responseData.body.isNotEmpty ? jsonDecode(responseData.body) : {};
    } catch (e) {
      AppDebug().printDebug(msg: 'Error during API request: $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
      return {};
    }
  }
}
