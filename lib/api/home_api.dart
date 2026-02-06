import 'package:petsmore_tele_app/api/api_manager.dart';
import 'package:petsmore_tele_app/api/global_api.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
// import 'package:petsmore_tele_app/services/get_it.dart';

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
