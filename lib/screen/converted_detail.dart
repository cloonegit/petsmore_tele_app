import 'package:petsmore_tele_app/config/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/global_function/app_logout.dart';
import 'package:petsmore_tele_app/global_function/show_custom_dialog.dart';
import 'package:petsmore_tele_app/main.dart';
import 'package:petsmore_tele_app/provider/bottom_nav_provider.dart';
import 'package:petsmore_tele_app/services/get_it.dart';
import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';
import 'package:petsmore_tele_app/widgets/appbar.dart';
import 'package:petsmore_tele_app/widgets/bottom_navigation_bar.dart';
import 'package:petsmore_tele_app/widgets/custom_container.dart';
import 'package:petsmore_tele_app/widgets/global_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ConvertedDetail extends ConsumerStatefulWidget {
  final String cid;
  final String outlet;

  ConvertedDetail({super.key, required this.cid, required this.outlet});

  @override
  ConsumerState<ConvertedDetail> createState() => _ConvertedDetailState();
}

class _ConvertedDetailState extends ConsumerState<ConvertedDetail> {
  TextEditingController remarksTMController = TextEditingController();
  TextEditingController sonController = TextEditingController();
  final errorMessageService = GetIt.instance<ErrorMessageService>();

  Map approachedDetails = {};
  bool isLoading = false;
  String sonBranch = '';

  String son = '';
  String remark = '';
  String remarkAmtm = '';
  List whatsAppData = [];
  String? _selectedValue;
  FocusNode _remarksFocusNode = FocusNode();
  final _mapInstalled =
      WhatsApp.values.asMap().map<WhatsApp, String?>((key, value) {
    return MapEntry(value, null);
  });

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    getUserLogin();
    fetchData();
  }

  @override
  void dispose() {
    remarksTMController.dispose();
    sonController.dispose();
    super.dispose();
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

  Future<void> fetchData() async {
    Future.microtask(() async {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      try {
        await ref.read(convertedProvider).fetchApproachDetail(widget.cid);
        await ref.read(convertedProvider).fetchWhatsappMsg();
        approachedDetails = ref.read(convertedProvider).getApproachedDetails;
        AppDebug().printDebug(msg: 'approachedDetails:$approachedDetails');
        remark = approachedDetails['REMARK'];
        remarksTMController.text = approachedDetails['REMARK_AMTM'];
        sonBranch = approachedDetails['SON_BRANCH'];
        _selectedValue = approachedDetails['SON_TYPE'];

        sonController.text = approachedDetails['SON'];
        whatsAppData = ref.read(convertedProvider).getwhatsAppData;
        AppDebug().printDebug(msg: 'whatsappdata:$whatsAppData');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: Appbar(
        title: 'DETAILS',
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : approachedDetails.isEmpty
              ? Center(
                  child: Text(
                  'No data available',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ))
              : RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: Colors.white,
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Contact Details Card
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: Adaptive.h(2)),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
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
                                  // width: Adaptive.w(90),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        approachedDetails['NAME'] ?? '',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 26,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: Adaptive.h(1)),
                                      Text(
                                        approachedDetails['CARDTYPE'] ?? '',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: Adaptive.h(1)),
                                      Row(
                                        children: [
                                          Text(
                                            'CAMPAIGN : ',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            (approachedDetails['CAMPAIGN'] !=
                                                        null &&
                                                    approachedDetails[
                                                            'CAMPAIGN']
                                                        .isNotEmpty)
                                                ? approachedDetails['CAMPAIGN']
                                                        [0]['name'] ??
                                                    ''
                                                : '',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: AppColors.primary,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Adaptive.h(1)),
                                      Row(
                                        children: [
                                          Text(
                                            'ID : ',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            approachedDetails['P1NO'] ?? '',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Adaptive.h(1)),
                                      Row(
                                        children: [
                                          Text(
                                            'DOB : ',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            approachedDetails['DOB'] != null
                                                ? approachedDetails['DOB']
                                                        .replaceAll(
                                                            "DOB: ", "") ??
                                                    ''
                                                : '',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Adaptive.h(1)),
                                      Row(
                                        children: [
                                          Text(
                                            'Contact Number : ',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            approachedDetails['CONTACT'] ?? '',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Adaptive.h(1)),
                                      _buildActionIcons(
                                          approachedDetails['CONTACT'] ?? ''),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Telemarketer Remarks Section
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
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
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle('Telemarketer Remarks'),
                                    SizedBox(height: Adaptive.h(1)),
                                    _buildTextField(
                                        isTele: true, hintText: remark),

                                    SizedBox(height: Adaptive.h(3)),

                                    // TM Remarks Section
                                    _buildSectionTitle('TM Remarks'),
                                    SizedBox(height: Adaptive.h(1)),
                                    _buildTextField(
                                        isTele: false,
                                        controller: remarksTMController,
                                        hintText: remarksTMController.text == ''
                                            ? 'Remarks'
                                            : ''),

                                    SizedBox(height: Adaptive.h(3)),

                                    // SON/CS Radio Buttons Section
                                    _buildSectionTitle('SON/CS'),
                                    SizedBox(height: Adaptive.h(1)),
                                    _buildRadioButtons(),
                                    SizedBox(height: Adaptive.h(3)),

                                    // GS005*SON Input Field
                                    _buildSectionTitle('$sonBranch * ',
                                        title2:
                                            '$_selectedValue * ${sonController.text}',
                                        isItalic: true),
                                    SizedBox(height: Adaptive.h(1)),
                                    _buildTextField(
                                        controller: sonController,
                                        hintText: 'Enter SON/SCS'),
                                    SizedBox(height: Adaptive.h(3)),

                                    // Submit Button
                                    CustomContainer(
                                        backgroundColor: AppColors.primary,
                                        color: Colors.white,
                                        height: Adaptive.h(5),
                                        width: Adaptive.w(88),
                                        onPressed: () {
                                          submitDetails();
                                        },
                                        title: 'SUBMIT')
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Future<void> _refreshData() async {
    try {
      fetchData();
      AppDebug().printDebug(msg: 'Data Refresh Successful');
    } catch (e) {
      AppDebug().printDebug(msg: 'Error during data refresh: $e');
    }
  }

  submitDetails() async {
    if (remarksTMController.text.trim().isEmpty) {
      showCustomDialog(context, '', 'Please enter remarks', 'OK', () {});
    } else if (_selectedValue == null || _selectedValue == '') {
      showCustomDialog(context, '', 'Please select SON/SCS', 'OK', () {});
    } else if (sonController.text.trim().isEmpty) {
      showCustomDialog(context, '', 'Please enter SON/SCS', 'OK', () {});
    } else {
      showCustomDialog(
        context,
        '',
        'Please confirm your approach to this customer',
        'OK',
        () {
          sendSubmitDetails();
        },
        cancel: 'Cancel',
        onCancel: () {},
      );
    }
  }

  sendSubmitDetails() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final res = await ref.read(convertedProvider).approachedSubmit(widget.cid,
          remarksTMController.text, _selectedValue, sonController.text);

      if (res['status'] == '1') {
        await ref.read(convertedProvider).fetchCustomerList(widget.outlet);
        await ref.read(convertedProvider).fetchApproachedList(widget.outlet);

        showCustomDialog(context, '', res['status_message'], 'OK', () {
          Navigator.pop(context);
        });
      } else {
        GlobalUtils.showFloatingMessage(context, res['status_message']);
      }
    } catch (e) {
      AppDebug().printDebug(msg: 'catch error submitdetails:$e');
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
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title,
      {String? title2, bool isItalic = false}) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 24,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          Text(
            title2 ?? '',
            style: isItalic
                ? TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Poppins')
                : const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }

  // Text Field Widget
  Widget _buildTextField(
      {bool isTele = false,
      TextEditingController? controller,
      required String hintText}) {
    return IntrinsicHeight(
      child: TextField(
        enableInteractiveSelection: false,
        controller: controller,
        maxLines: null,
        expands: true,
        cursorColor: AppColors.primary,
        style: TextStyle(fontStyle: FontStyle.normal),
        readOnly: isTele ? true : false,
        decoration: InputDecoration(
          filled: isTele ? true : false,
          fillColor: isTele ? Colors.grey[300] : Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontStyle: FontStyle.italic),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  // Radio Buttons Widget
  Widget _buildRadioButtons() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedValue == 'SON'
                  ? AppColors.primary
                  : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(10.0),
            color: _selectedValue == 'SON'
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey[300],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: RadioListTile<String>(
            title: const Text('SON'),
            value: 'SON',
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
        SizedBox(
          height: Adaptive.h(1),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedValue == 'SCS'
                  ? AppColors.primary
                  : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(10.0),
            color: _selectedValue == 'SCS'
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey[300],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: RadioListTile<String>(
            title: const Text('SCS'),
            value: 'SCS',
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(String assetPath, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        assetPath,
      ),
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

  Widget _buildActionIcons(String contact) {
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
              final checkWhatsApp = await _checkInstalledWhatsApp();

              if (checkWhatsApp == true) {
                String? newSelectedValue =
                    await GlobalUtils.TickListDialogSmall(
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
                      'https://wa.me/${contact}?text=${decodedMessage}';

                  if (await canLaunchUrlString(whatsAppUrl)) {
                    await launchUrlString(whatsAppUrl);
                  } else {
                    AppDebug().printDebug(
                        msg: 'WhatsApp not installed or cannot open URL.');
                  }
                  // await shareWhatsapp.share(
                  //   text: decodedMessage,
                  //   phone: recipents.first.toString(),
                  // );
                  // await submitWhatsappCallLog();
                } else {
                  selectedWhatsAppValue = null;
                  AppDebug().printDebug(msg: 'selectedWhatsAppValue==null.');
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
