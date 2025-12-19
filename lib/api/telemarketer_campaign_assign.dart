import 'package:nrs_tele_apps/api/api_manager.dart';
import 'package:nrs_tele_apps/api/global_api.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/services/get_it.dart';

class TelemarketerCampaignAssignAPI {
  Future<Map> outletList() async {
    String url = '${GlobalAPI().campaignAssignOutletList}';

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
      getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> telemarketerList(
      String? staffcode, String? outlet, String? campaignId) async {
    String url =
        '${GlobalAPI().campaignAssignTelemarketerList}?staffcode=${staffcode}&outlet=${outlet}&campaignid=${campaignId}';

    DateTime currentTime = DateTime.now();
    AppDebug()
        .printDebug(msg: 'telemarketerList  api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'telemarketerList api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'telemarketerList error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> telemarketerAssign(String? staffcode, String? assign,
      String? outlet, String? campaignId) async {
    String url =
        '${GlobalAPI().campaignAssignTelemarketerAssign}?staffcode=${staffcode}&telemarketer=${assign}&outlet=${outlet}&campaignid=${campaignId}';

    DateTime currentTime = DateTime.now();
    AppDebug()
        .printDebug(msg: 'telemarketerAssign  api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'telemarketerAssign api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'telemarketerAssign error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }
}
