import 'package:petsmore_tele_app/api/api_manager.dart';
import 'package:petsmore_tele_app/api/global_api.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
// import 'package:petsmore_tele_app/services/get_it.dart';

class ConvertedAPI {
  Future<Map> outletList(String? staffcode) async {
    String url = '${GlobalAPI().convertedOutletList}?staffcode=${staffcode}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'outlet list  api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'outlet list api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'outlet list error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> customerList(String? outlet) async {
    String url = '${GlobalAPI().convertedCustList}?outletcode=${outlet}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'customerList  api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'customerList api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'customerList error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> approachedList(String? outlet) async {
    String url = '${GlobalAPI().convertedApprdList}?outletcode=${outlet}';

    DateTime currentTime = DateTime.now();
    AppDebug()
        .printDebug(msg: 'approachedList  api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'approachedList api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'approachedList error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> approachedDetail(String? cid) async {
    String url = '${GlobalAPI().convertedApprdDetl}?cid=${cid}';

    DateTime currentTime = DateTime.now();
    AppDebug()
        .printDebug(msg: 'approachedDetail  api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'approachedDetail api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'approachedDetail error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> approachedSubmit(
      String? cid, String? remarks, String? sontype, String? son) async {
    String url =
        '${GlobalAPI().convertedApprdSubt}?cid=${cid}&remark=${remarks}&son_type=${sontype}&son=${son}';

    DateTime currentTime = DateTime.now();
    AppDebug()
        .printDebug(msg: 'approachedSubmit  api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'approachedSubmit api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'approachedSubmit error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }
}
