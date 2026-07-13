import 'package:petsmore_tele_app/api/api_manager.dart';
import 'package:petsmore_tele_app/api/global_api.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
// import 'package:petsmore_tele_app/services/get_it.dart';
// import 'package:share_whatsapp/share_whatsapp.dart';

class CallSummaryAPI {
  Future<Map> callSummary(String? staffcode) async {
    String url = '${GlobalAPI().callSummary}?staffcode=${staffcode}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'call summary  api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'call summary api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'call summary error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> callSummaryDetail(
      String? staffcode, String platformType, String cid) async {
    String url =
        '${GlobalAPI().callSummaryDetail}?platform=${platformType}&staffcode=${staffcode}&cid=${cid}';

    DateTime currentTime = DateTime.now();
    AppDebug()
        .printDebug(msg: 'call summary detail api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug()
          .printDebug(msg: 'call summary detail api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'call summary detail error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> whatsApp(String? staffcode, String cid) async {
    String url = '${GlobalAPI().whatsapp}?staffcode=${staffcode}&cid=${cid}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'whatsapp api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'whatsapp api response : $response');
      AppDebug().printDebug(msg: 'Api url : $url');
    } catch (e) {
      AppDebug().printDebug(msg: 'whatsapp error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> businessCard(String? staffcode, String cid) async {
    String url =
        '${GlobalAPI().businessCard}?staffcode=${staffcode}&cid=${cid}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'businessCard api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'businessCard api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'businessCard error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> campaignImages(String? staffcode, String cid) async {
    String url =
        '${GlobalAPI().campaignImages}?staffcode=${staffcode}&cid=${cid}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'campaignImages api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'campaignImages api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'campaignImages error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> campaignAudio(String campaignId) async {
    String url = '${GlobalAPI().campaignAudio}?campaign_id=${campaignId}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'campaignAudio api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'campaignAudio api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'campaignAudio error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> campaignVideo(String campaignId) async {
    String url = '${GlobalAPI().campaignVideo}?campaign_id=${campaignId}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'campaignVideo api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'campaignVideo api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'campaignVideo error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  // Future<Map> callLog(String? staffcode, String cid, String contact,
  //     String platformType) async {
  //   String url =
  //       '${GlobalAPI().callLog}?staffcode=${staffcode}&cid=${cid}&contact=${contact}&platform=${platformType}';

  //   DateTime currentTime = DateTime.now();
  //   AppDebug().printDebug(msg: 'callLog api body : $url   $currentTime');
  //   var response;
  //   try {
  //     response = await APIManager()
  //         .getAPICall(url)
  //         .timeout(Duration(seconds: GlobalAPI().timeout));
  //     AppDebug().printDebug(msg: 'callLog api response : $response');
  //   } catch (e) {
  //     AppDebug().printDebug(msg: 'callLog error $e');
  //   }

  //   return response;
  // }

  Future<Map> whatsAppLog(String? staffcode, String cid, String campaignId,
      String platformType, int countWhatsappLog) async {
    String url =
        '${GlobalAPI().whatsappLog}?staffcode=${staffcode}&cid=${cid}&campaign_id=${campaignId}&platform=${platformType}&count_whatsapp_log=${countWhatsappLog}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'whatsAppLog api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'whatsAppLog api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'whatsAppLog error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> smsLog(String number, String message) async {
    String url = '${GlobalAPI().smsLog}?number=${number}&message=${message}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'smsLog api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'smsLog api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'smsLog error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }

  Future<Map> submitRemarks(String platformType, String staffcode, String cid,
      String callStatus, String remarksMsg, String reasonType) async {
    String formattedReasonType =
        reasonType.toLowerCase().replaceAll(' ', '_');
    String url =
        '${GlobalAPI().submitRemarks}?platform=${platformType}&staffcode=${staffcode}&cid=${cid}&callstatus=${callStatus}&remark=${remarksMsg}&reason_type=${formattedReasonType}';

    DateTime currentTime = DateTime.now();
    AppDebug().printDebug(msg: 'submitRemarks api body : $url   $currentTime');
    var response;
    try {
      response = await APIManager()
          .getAPICall(url)
          .timeout(Duration(seconds: GlobalAPI().timeout));
      AppDebug().printDebug(msg: 'submitRemarks api response : $response');
    } catch (e) {
      AppDebug().printDebug(msg: 'submitRemarks error $e');
      // getIt<ErrorMessageService>().setErrorMessage(e.toString());
    }

    return response;
  }
}
