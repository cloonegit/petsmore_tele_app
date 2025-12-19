import 'package:nrs_tele_apps/api/api_manager.dart';
import 'package:nrs_tele_apps/api/global_api.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/services/get_it.dart';

class HomeAPI {
  Future home(String? staffcode) async {
    var response;

    // if (staffcode != '') {
    String url = '${GlobalAPI().home}?staffcode=${staffcode}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'home  api body : $url   $currentTime');
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'home api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'home error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());

      return e;
    }
    // }
    return response;
  }
}
