import 'package:petsmore_tele_app/api/api_manager.dart';
import 'package:petsmore_tele_app/api/global_api.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';

class StaffAPI {
  Future<Map> fetchStaffDetail(String staffCode) async {
    String url = '${GlobalAPI().staffDetail}?staffcode=$staffCode';

    AppDebug().printDebug(msg: 'fetchStaffDetail API: $url');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'fetchStaffDetail response: $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'fetchStaffDetail error: $e');
    }

    return response ?? {};
  }
}
