import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:send_message/send_message.dart';
import 'package:get_it/get_it.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/app_logout.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/provider/bottom_nav_provider.dart';
// import 'package:nrs_tele_apps/screen/call_summary.dart';
import 'package:nrs_tele_apps/services/get_it.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:nrs_tele_apps/widgets/call_status_dropdown.dart';
import 'package:nrs_tele_apps/screen/remarks_tab.dart';
import 'package:nrs_tele_apps/widgets/appbar.dart';
import 'package:nrs_tele_apps/widgets/bottom_navigation_bar.dart';
import 'package:nrs_tele_apps/widgets/business_card_modal.dart';
import 'package:nrs_tele_apps/widgets/custom_container.dart';
import 'package:nrs_tele_apps/widgets/global_utils.dart';
import 'package:nrs_tele_apps/widgets/single_accordion.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CallDetails extends ConsumerStatefulWidget {
  // final Function(dynamic index) onNavBarItemTapped;
  final String? cid;
  final VoidCallback? onPop;
  CallDetails({
    super.key,
    //  this.onNavBarItemTapped,
    required this.cid,
    this.onPop,
  });

  @override
  ConsumerState<CallDetails> createState() => _CallDetailsState();
}

class _CallDetailsState extends ConsumerState<CallDetails>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // final indexBottomNavbarProvider = StateProvider<int>((ref) {
  //   return 1;
  // });
  final _mapInstalled =
      WhatsApp.values.asMap().map<WhatsApp, String?>((key, value) {
    return MapEntry(value, null);
  });
  // String _kTextMessage = 'Test share whatsapp message from telemarketing app';
  // String message = 'test sms message';
  // String number = '';
  String _selectedIcon = '';
  String callStatus = '';
  String campaignName = '';
  String campaignId = '';
  String userLogin = '';
  String reason = '';
  String reasonType = '';
  String reasonProduct = '';
  String whatsappErrorMsg = '';
  String prevCallStatus = '';
  String campaignTypeId = '';
  String onlineMakePurchase = Uri.encodeComponent(
      'Please click here to buy >>> https://tele.senheng.com.my/index?code=Y2xvb25lMQ||&prod=lgbv');
  int parsedCountWhatsappLog = 0;
  dynamic countWhatsappLog;
  // String whatsAppUrl='https://wa.me/${CONTACT}?text=${sendMsg}';
  String sendMsg = '';
  List callInfo2 = [];
  List remarksList = [];
  List whatsAppData = [];
  List SMSData = [];
  List dataCampaign = [];
  Map selection = {};
  Map data = {};
  bool ableCallStatus = false;
  bool ableNoAnswer = false;
  // List<String> recipents = ['+601119430092'];
  List<String> recipents = [];

  late TabController _tabController;
  TextEditingController remarksController = TextEditingController();
  FocusNode _remarksFocusNode = FocusNode();
  bool isLoading = true;
  bool isLoadingRemarks = false;
  bool isOnline = false;
  final errorMessageService = GetIt.instance<ErrorMessageService>();

  @override
  void initState() {
    super.initState();
    getUserLogin();
    WidgetsBinding.instance.addObserver(this);
    fetchData();
    _tabController = TabController(length: 1, vsync: this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     // fetchData();
  //   }
  // }

  Future<void> fetchData() async {
    Future.microtask(() async {
      try {
        final callSummaryDetail = ref.read(callSummaryDetailProvider);
        await callSummaryDetail.fetchCallSummaryDetail(widget.cid ?? '');
        // await callSummaryDetail.fetchBusinessCard();
        // await callSummaryDetail.fetchWhatsappMsg();

        getCallSummaryDetail(callSummaryDetail);
        getBusinessCard(callSummaryDetail);
        getDataCampaignData(callSummaryDetail);
        getWhatsappData(callSummaryDetail);
        getCallStatusData(callSummaryDetail);
        getContactData(callSummaryDetail);
        getRemarksData();

        if (widget.cid != null) {
          ref.read(callSummaryDetailProvider.notifier).setCID(widget.cid);
        }
      } catch (e) {
        final errorMessage = errorMessageService.getErrorMessage();
        if (errorMessage != null && errorMessage.isNotEmpty) {
          showCustomDialog(context, '', errorMessage, 'OK', () {
            errorMessageService.clearErrorMessage();
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  Future<void> getUserLogin() async {
    userLogin = await GetSharedPreferences().getUserPosition();
    AppDebug().printDebug(msg: 'userlogin:$userLogin');
    if (userLogin.isEmpty || userLogin == "") {
      await AppLogout().logout(context, ref);
      showCustomDialog(
          context, '', 'userLogin not found, Please re-login.', 'OK', () {});
    }
  }

  Future<void> _refreshData() async {
    try {
      fetchData();
      AppDebug().printDebug(msg: 'Data Refresh Successful');
    } catch (e) {
      AppDebug().printDebug(msg: 'Error during data refresh: $e');
    }
  }

  Future<void> getCallSummaryDetail(callSummaryDetail) async {
    try {
      await callSummaryDetail.fetchCallSummaryDetail(widget.cid ?? '');
    } catch (e) {
      final errorMessage = errorMessageService.getErrorMessage();
      if (errorMessage != null && errorMessage.isNotEmpty) {
        showCustomDialog(context, '', errorMessage, 'OK', () {
          errorMessageService.clearErrorMessage();
        });
      }
    }
  }

  Future<void> getBusinessCard(callSummaryDetail) async {
    try {
      await callSummaryDetail.fetchBusinessCard();
    } catch (e) {
      final errorMessage = errorMessageService.getErrorMessage();
      if (errorMessage != null && errorMessage.isNotEmpty) {
        showCustomDialog(context, '', errorMessage, 'OK', () {
          errorMessageService.clearErrorMessage();
        });
      }
    }
  }

  // Future<void> getBottomNavBarIndex() async {
  //   if (userLogin == 'STAFF') {
  //     ref.read(bottomNavNotifierProvider.notifier).setIndex(1);
  //   } else if (userLogin == 'TM') {
  //     ref.read(bottomNavNotifierProvider.notifier).setIndex(2);
  //   }
  // }

  Future<void> getDataCampaignData(callSummaryDetail) async {
    callInfo2 = callSummaryDetail.getCallInfo2;
    dataCampaign = callSummaryDetail.getDataCampaign;
  }

  Future<void> getWhatsappData(callSummaryDetail) async {
    await callSummaryDetail.fetchWhatsappMsg();
    whatsappErrorMsg = callSummaryDetail.getwhatsappErrorMsg;
    whatsAppData = callSummaryDetail.getwhatsAppData;
    SMSData = callSummaryDetail.getSMSData;
  }

  Future<void> getRemarksData() async {
    remarksList = ref.read(callSummaryDetailProvider).getRemarks;
  }

  Future<void> getCallStatusData(callSummaryDetail) async {
    ableCallStatus = callSummaryDetail.getableCallStatus;
    ableNoAnswer = callSummaryDetail.getableNoAnswer;
    selection = callSummaryDetail.getSelection;
  }

  Future<void> getContactData(callSummaryDetail) async {
    data = callSummaryDetail.infoData;
    if (data['CONTACT'].isNotEmpty) {
      recipents = [];
      recipents.add(data['CONTACT']);
      AppDebug().printDebug(msg: 'recipents:${recipents.first}');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    remarksController.dispose();
    _remarksFocusNode.dispose();
    AppDebug().printDebug(msg: 'dispose calldetails');
    super.dispose();
  }

  Future<bool> _checkInstalledWhatsApp() async {
    String whatsAppInstalled = await _check(WhatsApp.standard),
        whatsAppBusinessInstalled = await _check(WhatsApp.business);

    if (!mounted) return false;
    AppDebug().printDebug(msg: 'whatsAppInstalled:$whatsAppInstalled');
    // if (whatsAppInstalled == 'NOT INSTALLED') {
    //   showCustomDialog(context, '', 'Please install Whatsapp first to proceed.',
    //       'OK', () {});
    //   return false;
    // }
    setState(() {
      _mapInstalled[WhatsApp.standard] = whatsAppInstalled;
      _mapInstalled[WhatsApp.business] = whatsAppBusinessInstalled;
    });

    return true;
  }

  Future<String> _check(WhatsApp type) async {
    try {
      return await shareWhatsapp.installed(type: type)
          ? 'INSTALLED'
          : 'NOT INSTALLED';
    } on PlatformException catch (e) {
      return e.message ?? 'Error';
    }
  }

  String extractDate(String expiryString) {
    final RegExp regex = RegExp(r'(\d{2}/\d{2}/\d{4})');
    final Match? match = regex.firstMatch(expiryString);

    return match != null ? match.group(0) ?? '-' : '-';
  }

  @override
  Widget build(BuildContext context) {
    // final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
    // if (kDebugMode) print('indexBottomNavbar:$indexBottomNavbar');
    final callSummaryDetail = ref.watch(callSummaryDetailProvider);
    data = callSummaryDetail.infoData;

    return Scaffold(
      appBar: Appbar(title: 'DETAILS'),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFED1C24)),
              ),
            )
          : RefreshIndicator(
              color: Color(0xFFED1C24),
              backgroundColor: Colors.white,
              onRefresh: _refreshData,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  _remarksFocusNode.unfocus();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: Adaptive.h(2)),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            // height: Adaptive.h(50),
                            width: Adaptive.w(90),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Section 1: Customer details: name, gender,cardtype, contact number
                                Text(
                                  data['NAME'] ?? '',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: Adaptive.h(2)),
                                _buildDetailRow(
                                    data['GENDER'] ?? '-',
                                    '|',
                                    data['SENHENGAPP'].isNotEmpty
                                        ? data['SENHENGAPP']
                                        : 'Download Senheng App: NO'),
                                SizedBox(height: Adaptive.h(2)),
                                Text(
                                  data['CARDTYPE'] ?? '-',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: Adaptive.h(2)),
                                _buildDetailRow2('ID : ', data['P1NO'] ?? '-'),
                                SizedBox(height: Adaptive.h(2)),
                                _buildDetailRow2('Expiry Date : ',
                                    extractDate(data['EXPIRY'].toString())),
                                SizedBox(height: Adaptive.h(2)),
                                _buildDetailRow2('Contact Number : ',
                                    data['CONTACT'] ?? '-'),
                                SizedBox(height: Adaptive.h(2)),
                                //Section 2: Icon: whatsapp, sms , share business card
                                _buildActionIcons(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Section 3: single accordion: based on campaign name. To share campaign image, donwload video and audio
                      if (callInfo2.isNotEmpty)
                        SingleAccordion(
                          cid: widget.cid ?? '',
                          callInfo2: callInfo2,
                        ),

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        // height: Adaptive.h(50),
                        //Section 4: Update status customer based on : interested, rejected, no answer, make purchase, follow up
                        width: Adaptive.w(90),
                        child: Column(
                          children: [
                            _buildActionIcons2(),
                            SizedBox(
                              height: Adaptive.h(3),
                            ),
                            if (callStatus == 'NOANS' ||
                                callStatus == 'PURCHASE')
                              CallStatusDropdown(callStatus: callStatus),
                            if (_selectedIcon != '') remarks(),
                          ],
                        ),
                      ),
                      SizedBox(height: Adaptive.h(2)),
                      //Section 5: Remarks. To display remarks for each customer
                      Container(
                          height: Adaptive.h(30),
                          width: Adaptive.w(90),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: buildTabRemarks()),
                      SizedBox(height: Adaptive.h(2)),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: ref.read(bottomNavNotifierProvider).index,
        onTap: (index) {
          ref.read(bottomNavNotifierProvider.notifier).setIndex(index);
        },
      ),
    );
  }

  //Section 1 Widget

  Widget _buildDetailRow(String label, String value, [String? extra]) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: Adaptive.w(4)),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (extra != null) ...[
          SizedBox(width: Adaptive.w(4)),
          Text(
            extra,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildDetailRow2(String label, String value, [String? extra]) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: Adaptive.w(2)),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (extra != null) ...[
          SizedBox(width: Adaptive.w(2)),
          Text(
            extra,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  //Section 2 Widget,Whatsapp icon, sms icon, share icon:
  Widget _buildIconButton(String assetPath, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        assetPath,
      ),
    );
  }

  Widget _buildActionIcons() {
    // List<Map<String, String>> whatsAppData = [
    //   {
    //     'NAME': 'Template 1',
    //     'MSG': 'Hello, this is a message from Template 1.',
    //   },
    //   {
    //     'NAME': 'Template 2',
    //     'MSG': 'Hi there, this is another template message.',
    //   },
    //   {
    //     'NAME': 'Template 3',
    //     'MSG': 'Greetings, this is Template 3 for WhatsApp messaging.',
    //   },
    // ];
    List whatsappOptions =
        whatsAppData.map((item) => item['NAME'] as String).toList();
    // List SMSOptions = SMSData.map((item) => item['name'] as String).toList();
    String? selectedWhatsAppValue;
    String? selectedSMSValue;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.flip(
          flipX: true,
          child: _buildIconButton(
            'assets/icons/whatsapp.png',
            () async {
              _remarksFocusNode.unfocus();

              if (whatsAppData.isEmpty) {
                showCustomDialog(context, 'Invalid',
                    'No whatsapp template for this campaign', 'OK', () {});
                return;
              }
              // final checkWhatsApp = await _checkInstalledWhatsApp();

              // if (checkWhatsApp == true) {
              String? newSelectedValue = await GlobalUtils.TickListDialogSmall(
                context,
                whatsappOptions,
                'Please choose a template to send',
              );
              AppDebug().printDebug(msg: 'Selectedvalue:$newSelectedValue');

              if (newSelectedValue != null) {
                selectedWhatsAppValue = newSelectedValue;
                // String? selectedMessage = whatsAppData.firstWhere(
                //   (item) => item['NAME'] == selectedWhatsAppValue,
                // )['MSG'];

                int index = int.parse(selectedWhatsAppValue ?? '');
                String? selectedMessage = whatsAppData[index]['MSG'];

                String decodedMessage = decodeMessage(selectedMessage ?? '');

                AppDebug().printDebug(msg: 'Selectedvalue:$decodedMessage');
                String whatsAppUrl =
                    'https://wa.me/${recipents.first.toString()}?text=${decodedMessage}';

                if (await canLaunchUrlString(whatsAppUrl)) {
                  await launchUrlString(whatsAppUrl,
                      mode: LaunchMode.externalApplication);
                } else {
                  AppDebug().printDebug(
                      msg: 'WhatsApp not installed or cannot open URL.');
                }
                // await shareWhatsapp.share(
                //   text: decodedMessage,
                //   phone: recipents.first.toString(),
                // );
                await submitWhatsappCallLog();
              } else {
                selectedWhatsAppValue = null;
              }
              // }
            },
          ),
        ),
        _buildIconButton(
          'assets/icons/sms.png',
          () async {
            if (SMSData.isEmpty) {
              showCustomDialog(context, 'Invalid',
                  'No sms template for this campaign', 'OK', () {});
              return;
            }

            String? newSelectedValue = await GlobalUtils.TickListDialogSmall(
              context,
              whatsappOptions,
              'Please choose a template to send',
            );

            if (newSelectedValue != null) {
              selectedSMSValue = newSelectedValue;
              // String? selectedMessage = whatsAppData.firstWhere(
              //   (item) => item['NAME'] == selectedSMSValue,
              // )['MSG'];
              int index = int.parse(selectedSMSValue ?? '');
              String? selectedMessage = SMSData[index]['detail'];
              String plainText = decodeMessage(selectedMessage ?? '');

              _sendSMS(plainText, recipents);
              submitSMSLog(plainText);
            } else {
              AppDebug().printDebug(msg: 'sms message not empty');
              selectedSMSValue = null;
            }
          },
        ),
        _buildIconButton(
          'assets/icons/share.png',
          () {
            showBusinessCard(
              context,
            );
          },
        ),
      ],
    );
  }

  String decodeMessage(String encodedSMS) {
    String decodedMessage = Uri.decodeFull(encodedSMS);

    decodedMessage = decodedMessage.replaceAll('+', ' ');

    return decodedMessage.replaceAllMapped(
      RegExp(r'[\*%]|[\u2600-\u27BF]'),
      (match) {
        if (match[0] == '*') {
          return '**';
        } else if (match[0] == '%') {
          return '';
        } else {
          return match[0]!;
        }
      },
    );
  }

  // String decodeMessage(String message) {
  //   String decoded = Uri.decodeComponent(message);

  //   decoded = decoded.replaceAll('%0D%0A', '\n').replaceAll('+', ' ').trim();

  //   return decoded;
  // }

  submitWhatsappCallLog() async {
    countWhatsappLog = ref.watch(callSummaryDetailProvider).getcountWhatsappLog;
    campaignId = ref.watch(callSummaryDetailProvider).getLeadCampaignId;
    if (countWhatsappLog is String) {
      parsedCountWhatsappLog = int.tryParse(countWhatsappLog) ?? 0;
    } else if (countWhatsappLog is int) {
      parsedCountWhatsappLog = countWhatsappLog;
    } else {
      parsedCountWhatsappLog = 0;
    }
    try {
      final res = await ref.read(callSummaryDetailProvider).submitWhatsAppLog(
          widget.cid ?? '', campaignId, parsedCountWhatsappLog);

      AppDebug().printDebug(
          msg: 'res submitwhatsapplog:$res....$countWhatsappLog...$campaignId');
    } catch (e) {
      AppDebug().printDebug(msg: 'error submitwhatsapplog:$e');
      final errorMessage = errorMessageService.getErrorMessage();
      if (errorMessage != null && errorMessage.isNotEmpty) {
        showCustomDialog(context, '', errorMessage, 'OK', () {
          errorMessageService.clearErrorMessage();
        });
      }
    }
  }

  submitSMSLog(String msg) async {
    try {
      final res = await ref
          .read(callSummaryDetailProvider)
          .submitSMSLog(recipents.first, msg);

      // AppDebug().printDebug(
      //     msg: 'res submitwhatsapplog:$res....$msg...${recipents.first}');
    } catch (e) {
      AppDebug().printDebug(msg: 'error submitwhatsapplog:$e');
      final errorMessage = errorMessageService.getErrorMessage();
      if (errorMessage != null && errorMessage.isNotEmpty) {
        showCustomDialog(context, '', errorMessage, 'OK', () {
          errorMessageService.clearErrorMessage();
        });
      }
    }
  }

  void _sendSMS(String message, List<String> recipents) async {
    AppDebug().printDebug(msg: 'sms number clicked');
    String _result = await sendSMS(message: message, recipients: recipents);
    AppDebug().printDebug(msg: 'result of SMS:$_result');
  }

  void showBusinessCard(BuildContext context) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return BusinessCardModal(
          contact: recipents.first.toString(),
        );
      },
    );
  }

  //Section 4 Icon, Interested, rejected etc:
  Widget _buildActionIcons2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconButton2('assets/icons/interested.png', () {
          if (kDebugMode) print('Selected');
          _toggleSelected('Interested\n');
        }, 'assets/icons/interested-active.png', 'Interested\n'),
        _buildIconButton2('assets/icons/rejected.png', () {
          _toggleSelected('Rejected\n');
        }, 'assets/icons/rejected-active.png', 'Rejected\n'),
        _buildIconButton2('assets/icons/no-answer.png', () {
          _toggleSelected('No\nAnswer');
        }, 'assets/icons/no-answer-active.png', 'No\nAnswer'),
        _buildIconButton2('assets/icons/make-purchase.png', () {
          _toggleSelected('Make\nPurchase');
        }, 'assets/icons/make-purchase-active.png', 'Make\nPurchase'),
        _buildIconButton2('assets/icons/follow-up.png', () {
          _toggleSelected('Follow\nUp');
        }, 'assets/icons/follow-up-active.png', 'Follow\nUp'),
      ],
    );
  }

  changeCallStatus() async {
    final callsummarydetail = await ref.read(callSummaryDetailProvider);

    if (prevCallStatus != callStatus) {
      prevCallStatus = callStatus;

      callsummarydetail.setReason('');
      callsummarydetail.setReasonProduct('');
      callsummarydetail.setReasonType('');
      AppDebug().printDebug(
          msg: 'reasonCallStatus:..$callStatus...$prevCallStatus...');
      AppDebug()
          .printDebug(msg: 'reason :$reason...$reasonType...$reasonProduct');
    }
  }

  void _toggleSelected(String iconName) {
    setState(() {
      if (_selectedIcon == iconName) {
        _selectedIcon = '';
        callStatus = '';
        changeCallStatus();
      } else {
        _selectedIcon = iconName;
      }
    });
    AppDebug().printDebug(msg: 'iconName:${_selectedIcon.trim()}');

    if (_selectedIcon.isNotEmpty) {
      setCallStatus(_selectedIcon);
    } else {
      AppDebug().printDebug(msg: 'No icon selected');
    }
  }

  void setCallStatus(String iconName, {bool isOnline = true}) {
    if (!mounted) return;

    setState(() {
      switch (iconName.trim()) {
        case 'Interested':
          callStatus = 'INTERESTED';
          break;
        case 'Rejected':
          callStatus = 'REJECTED';
          break;
        case 'No\nAnswer':
          callStatus = 'NOANS';
          break;
        case 'Make\nPurchase':
          if (isOnline) {
            callStatus = 'PURCHASE'; // Online purchase
          } else {
            callStatus = 'CONVERT'; // Offline purchase
          }
          break;
        case 'Follow\nUp':
          callStatus = 'CALLLATER';
          break;
        default:
          callStatus = 'UNKNOWN';
      }
    });
    AppDebug().printDebug(msg: 'callStatus:${callStatus}');
  }

  Widget _buildIconButton2(String assetPath, VoidCallback onPressed,
      String selectedIcon, String iconName) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          highlightColor: Colors.transparent,
          onPressed: onPressed,
          icon: Image.asset(
            _selectedIcon == iconName ? selectedIcon : assetPath,
            width: Adaptive.w(11),
            height: Adaptive.h(11),
          ),
        ),
        Text(
          // _selectedIcon == iconName ? iconName : '',
          iconName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          // maxLines: 2,
          // overflow: TextOverflow.visible,
        ),
      ],
    );
  }

  //Section 5, Remarks:
  Widget remarks() {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            height: Adaptive.h(10),
            width: Adaptive.w(80),
            child: Padding(
              padding: EdgeInsets.only(left: Adaptive.w(3)),
              child: TextField(
                enableInteractiveSelection: false,
                cursorColor: Color(0xFFED1C24),
                controller: remarksController,
                focusNode: _remarksFocusNode,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Remarks',
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            )),
        SizedBox(height: Adaptive.h(2)),
        CustomContainer(
          onPressed: () {
            submitRemarks(callStatus);
          },
          title: 'SUBMIT',
          width: Adaptive.w(80),
          // height: Adaptive.h(5),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          backgroundColor: const Color(0xFFED1C24),
        )
      ],
    );
  }

  submitRemarks(String callStatus) async {
    final callsummarydetail = await ref.read(callSummaryDetailProvider);
    whatsappErrorMsg = callsummarydetail.getwhatsappErrorMsg;
    campaignTypeId = callsummarydetail.getCampaignTypeId;
    countWhatsappLog = callsummarydetail.getcountWhatsappLog;
    reason = await callsummarydetail.getReason;
    reasonType = await callsummarydetail.getReasonType;
    reasonProduct = await callsummarydetail.getReasonProduct;

    AppDebug().printDebug(
        msg:
            'submitRemarks:..$countWhatsappLog...$whatsappErrorMsg...$campaignTypeId');

    if (remarksController.text.trim().isEmpty) {
      showCustomDialog(context, 'Remarks Required',
          'Please enter your remarks before submitting', 'OK', () {});
      return;
    }

    if (campaignTypeId == '2' && countWhatsappLog == 0) {
      showCustomDialog(context, '', whatsappErrorMsg, 'OK', () {});
      return;
    }

    if (ableCallStatus || campaignTypeId == '2') {
      switch (callStatus) {
        case 'INTERESTED':
        // INTERESTED_DETAIL
        case 'REJECTED':
        // REJECTED_DETAIL
        case 'CALLLATER':
          // CALLL_ATER_DETAIL
          await doSubmitRemarks();
          break;
        case 'NOANS':
          // NO_ANSWER_DETAIL
          await _handleNoAnswerStatus(reason);
          break;
        case 'PURCHASE':
          // CONVERTED_DETAIL
          await _handlePurchaseStatus(reasonType);
          break;

        default:
          break;
      }
    } else {
      showCustomDialog(
          context, '', 'Please call before updating status', 'OK', () {});
    }
  }

  Future<void> _handleNoAnswerStatus(String reason) async {
    if (reason.isEmpty) {
      showCustomDialog(
          context, '', 'Please choose reason before submit', 'OK', () {});
    }
    // else if (ableNoAnswer && reason != 'Wrong Number') {
    //   showCustomDialog(context, 'Unable to Submit',
    //       'Please call 3 times before updating status', 'OK', () {});
    // }
    else {
      await doSubmitRemarks();
    }
  }

  Future<void> _handlePurchaseStatus(String reasonType) async {
    if (reasonType.isEmpty) {
      showCustomDialog(
          context, '', 'Please choose type before submit', 'OK', () {});
      return;
    }
    if (reasonType == 'Payment via Tele Apps Link') {
      if (reasonProduct.isEmpty) {
        showCustomDialog(
            context, '', 'Please choose product before submit', 'OK', () {});
        return;
      }
      if (selection['ONLINE'] == '0') {
        showCustomDialog(context, '', selection['ONLINE_MSG'], 'OK', () {});
      } else {
        showCustomDialog(
            context,
            '',
            '${selection['PURCHASE_MSG_CONFIRM']}\n$reasonProduct ',
            'OK', () async {
          String whatsAppUrl =
              'https://wa.me/${recipents.first.toString()}?text=${onlineMakePurchase}';

          if (await canLaunchUrlString(whatsAppUrl)) {
            await launchUrlString(whatsAppUrl,
                mode: LaunchMode.externalApplication);
          } else {
            AppDebug()
                .printDebug(msg: 'WhatsApp not installed or cannot open URL.');
          }
          // shareWhatsapp.share(
          //     phone: recipents.first.toString(), text: onlineMakePurchase);
        }, cancel: 'Cancel');
      }
    } else if (reasonType == 'Escalate to TQM') {
      if (selection['OFFLINE'] == '0') {
        showCustomDialog(context, '', selection['OFFLINE_MSG'], 'OK', () {});
      } else {
        callStatus = 'CONVERT';
        await doSubmitRemarks();
      }
    }
  }

  Future<void> doSubmitRemarks() async {
    setState(() {
      isLoadingRemarks = true;
      isLoading = false;
    });
    try {
      final res = await ref
          .read(callSummaryDetailProvider)
          .submitRemarks(callStatus, remarksController.text);

      AppDebug().printDebug(msg: 'submit remarks:$res');

      if (res['status'] == '1') {
        remarksController.clear();
        // isLoadingRemarks = true;
        // await ref.read(callSummaryDetailProvider).setSubmitRemarks(true);
        // use below if user stay on call summary detail page but for now user not stay user navigate back from call details to call summary page
        // await ref
        //     .read(callSummaryDetailProvider)
        //     .fetchCallSummaryDetail(widget.cid ?? '');

        showCustomDialog(context, '', res['status_message'], 'OK', () {
          Navigator.pop(context);
          widget.onPop!();
        });
      } else {
        showCustomDialog(context, '', res['status_message'], 'OK', () {});
      }
    } catch (e) {
      AppDebug().printDebug(msg: 'error when submit remarks:$e');
      final errorMessage = errorMessageService.getErrorMessage();
      if (errorMessage != null && errorMessage.isNotEmpty) {
        showCustomDialog(context, '', errorMessage, 'OK', () {
          errorMessageService.clearErrorMessage();
        });
      }
    } finally {
      setState(() {
        isLoadingRemarks = false;
      });
    }
  }

  Widget buildTabRemarks() {
    getRemarksData();

    return Column(
      children: [
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: const Color(0xFFED1C24),
          labelColor: const Color(0xFFED1C24),
          controller: _tabController,
          tabs: const [
            Tab(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  //display remarks
                  'REMARKS',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
              ],
            )),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              remarksList.isEmpty
                  ? Center(
                      child: Text(
                        'No remarks',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : RemarksTab()
            ],
          ),
        ),
      ],
    );
  }
}
