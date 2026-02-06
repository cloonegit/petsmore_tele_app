import 'dart:async';
// import 'dart:io';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petsmore_tele_app/api/api_manager.dart';
import 'package:petsmore_tele_app/api/global_api.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
// import 'package:petsmore_tele_app/main.dart';
// import 'package:petsmore_tele_app/services/get_it.dart';

class LoginAPI {
  Future login(String? username, String? password) async {
    // final connectivityService = getIt<ConnectivityService>();
    // final connectivityResult = await connectivityService.checkConnectivity();

    // if (connectivityResult == ConnectivityResult.none) {
    //   return 'No Internet connection';
    // }
    String url =
        '${GlobalAPI().login}?username=${username}&password=${password}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'login  api body : $url   $currentTime');
    var response;

    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'login api response : $response');
    } catch (e) {
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
      AppDebug().printDebug(msg: 'catch error api login : $e');

      return e.toString();
    }

    return response;
  }
}
