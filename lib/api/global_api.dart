class GlobalAPI {
  int timeout = 30;

//   static String apidomain =
//       'https://sys.senheng.com.my/shmanagement_apps/telemarketing/';
  static String apidomain = 'https://tele.petsmore.com.my/api';
  String login = '$apidomain/login.php';
  String home = '$apidomain/home_3.php';
  // String notification = '$apidomain/notification.php';
  String callSummary = '$apidomain/call_summary_2.php';
  String callSummaryDetail = '$apidomain/call_detail_2.php';
  String whatsapp = '$apidomain/call_detail_whatsapp.php';
  String businessCard = '$apidomain/call_detail_namecard.php';
  String campaignImages = '$apidomain/call_detail_share_new.php';
  String campaignAudio = '$apidomain/get_audio_list.php';
  String campaignVideo = '$apidomain/get_video_list.php';
  String callLog = '$apidomain/call_detail_calllog_submit_3.php';
  String whatsappLog = '$apidomain/whatsapp_log_submit_new.php';
  String smsLog = '$apidomain/sms_sharing.php';
  String setting = '$apidomain/call_setting.php';
  String updateSetting = '$apidomain/call_setting_update.php';
  String submitRemarks = '$apidomain/call_detail_submit.php';
  String outletList = '$apidomain/tele_outlet.php';
  String telemarketerList = '$apidomain/tele_outlet_staff4.php';
  String telemarketerAssign = '$apidomain/tele_outlet_staff_submit.php';
  String campaignAssignOutletList = '$apidomain/tele_outlet_campaign.php';
  String campaignAssignTelemarketerList =
      '$apidomain/tele_outlet_staff_group.php';
  String campaignAssignTelemarketerAssign =
      '$apidomain/tele_outlet_staff_group_submit.php';
  String convertedOutletList = '$apidomain/tele_converted.php';
  String convertedCustList = '$apidomain/tele_converted_customer.php';
  String convertedApprdList = '$apidomain/tele_converted_salesorder.php';
  String convertedApprdDetl = '$apidomain/tele_converted_call_detail.php';
  String convertedApprdSubt =
      '$apidomain/tele_converted_call_detail_submit.php';
}
