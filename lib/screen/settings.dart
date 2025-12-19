import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nrs_tele_apps/global_function/app_back_button.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/app_logout.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/provider/bottom_nav_provider.dart';
import 'package:nrs_tele_apps/services/get_it.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:nrs_tele_apps/services/package_info.dart';
import 'package:nrs_tele_apps/widgets/appbar.dart';
import 'package:nrs_tele_apps/widgets/custom_container.dart';
import 'package:nrs_tele_apps/widgets/global_utils.dart';
import 'package:nrs_tele_apps/widgets/separator.dart';
import 'package:nrs_tele_apps/widgets/text_style_global.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

import 'dart:typed_data';
import 'package:image/image.dart' as img;

class Setting extends ConsumerStatefulWidget {
  const Setting({super.key});

  @override
  ConsumerState<Setting> createState() => _SettingState();
}

class _SettingState extends ConsumerState<Setting> with WidgetsBindingObserver {
  final AppDeviceBackBtn backBtnHandler = AppDeviceBackBtn();
  final errorMessageService = GetIt.instance<ErrorMessageService>();

  String appVersion = '';
  String buildNumber = '';
  String userLogin = '';
  bool isLoading = true;
  bool isSave = false;
  bool isEditing = false;
  final ImagePicker _picker = ImagePicker();
  Uint8List? imageByte;
  Map userData = {};

  XFile? pickedFile;
  String? _base64Image;
  String? profilePic;
  String? base64ImageString;

  TextEditingController staffCodeController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController outletAddressController = TextEditingController();
  TextEditingController outletContactController = TextEditingController();
  Map originalData = {};
  Map editedData = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initPackageInfo();
    fetchData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    staffCodeController.dispose();
    contactController.dispose();
    outletAddressController.dispose();
    outletContactController.dispose();
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {

  //   }
  // }

  void resetToOriginalData() {
    setState(() {
      isEditing = false;
    });
  }

  Future<void> _refreshData() async {
    try {
      fetchData();
      AppDebug().printDebug(msg: 'Data Refresh Successful');
    } catch (e) {
      AppDebug().printDebug(msg: 'Error during data refresh: $e');
    }
  }

  Future<void> _initPackageInfo() async {
    try {
      appVersion = await AppInfo.getAppVersion();
      buildNumber = await AppInfo.getBuildNumber();

      appVersion = appVersion;
      buildNumber = buildNumber;
    } catch (e) {
      AppDebug().printDebug(msg: 'Error initializing package info: $e');
    }
  }

  Future<void> fetchData() async {
    userLogin = await GetSharedPreferences().getUserPosition();
    AppDebug().printDebug(msg: 'userLogin: $userLogin');

    try {
      await ref.read(settingProvider).fetchSetting();

      userData = ref.read(settingProvider).getInfoData;
      if (userData.isNotEmpty) assignTextEditing();
      base64ImageString =
          await ref.read(settingProvider).getInfoData['PICTURE']['VALUE'] ?? '';

      if (base64ImageString != null || base64ImageString != "") {
        setProfilePicture();
      } else {
        AppDebug()
            .printDebug(msg: 'base64ImageString is NULL:$base64ImageString');
      }
    } catch (e) {
      final errorMessage = errorMessageService.getErrorMessage();
      if (errorMessage != null && errorMessage.isNotEmpty) {
        showCustomDialog(context, '', errorMessage, 'OK', () {
          errorMessageService.clearErrorMessage();
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  setProfilePicture() {
    final String base64Image = base64ImageString ?? '';
    final String base64String = base64Image.split(',').last;
    final Uint8List imageBytes = base64Decode(base64String);
    if (mounted) {
      setState(() {
        imageByte = imageBytes;
      });
    }
  }

  assignTextEditing() {
    staffCodeController =
        TextEditingController(text: userData['CODE']['VALUE']);
    contactController =
        TextEditingController(text: userData['CONTACT']['VALUE']);
    outletAddressController =
        TextEditingController(text: userData['OUTLET']['VALUE']);
    outletContactController =
        TextEditingController(text: userData['OUTLET_CONTACT']['VALUE']);
    editedData = Map.from(originalData);
  }

  @override
  Widget build(BuildContext context) {
    final bottomIndex = ref.watch(bottomNavNotifierProvider).index;
    AppDebug()
        .printDebug(msg: 'bottomIndex:$bottomIndex..$isEditing..$userLogin');
    if (userLogin == 'STAFF') {
      if (bottomIndex != 2 && isEditing == true) {
        resetToOriginalData();
      }
    } else if (userLogin == 'TM') {
      if (bottomIndex != 4 && isEditing == true) {
        resetToOriginalData();
      }
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await backBtnHandler.popped(context);
      },
      child: Scaffold(
        appBar: Appbar(title: isEditing ? 'EDITING INFO' : 'SETTING'),
        body: userData.isEmpty || isLoading == true
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
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: Adaptive.w(6), top: Adaptive.h(4)),
                            child: GestureDetector(
                              onTap: isEditing ? profileActionDialog : null,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 50.0,
                                    backgroundColor: Colors.white,
                                    child: imageByte == null
                                        ? const Icon(
                                            Icons.person,
                                            size: 50.0,
                                            color: Colors.grey,
                                          )
                                        : ClipOval(
                                            child: Image.memory(
                                            imageByte!,
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.fill,
                                          )),
                                  ),
                                  if (isEditing)
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4.0,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Color(0xFFED1C24),
                                        size: 18,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: Adaptive.w(5), top: Adaptive.h(10)),
                            child: CustomContainer(
                              onPressed: () {
                                setState(() {
                                  isEditing = !isEditing;
                                });
                                if (isEditing == false) {
                                  saveEditInfo(base64ImageString);
                                }
                              },
                              title: isEditing ? 'SAVE' : 'EDIT INFO',
                              titleSize: 12,
                              height: Adaptive.h(5),
                              width: Adaptive.w(30),
                              color: Color(0xFFED1C24),
                              backgroundColor: Color(0xFFF9DADB),
                              fontWeight: FontWeight.w600,
                              borderSide: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              isSave: isSave,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: Adaptive.w(6),
                                top: Adaptive.h(2),
                                bottom: Adaptive.h(2)),
                            child: Text(
                              userData['NAME']['VALUE'],
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          // height: Adaptive.h(40),
                          width: Adaptive.w(90),
                          child: Column(
                            children: [
                              buildText('Staff Code', userData['CODE']['VALUE'],
                                  editable: false,
                                  controller: staffCodeController),
                              buildHorizontalLine(),
                              buildText('Contact', userData['CONTACT']['VALUE'],
                                  editable: isEditing,
                                  controller: contactController),
                              buildHorizontalLine(),
                              buildText(
                                  'Outlet Address', userData['OUTLET']['VALUE'],
                                  editable: false,
                                  controller: outletAddressController),
                              buildHorizontalLine(),
                              buildText('Outlet Contact',
                                  userData['OUTLET_CONTACT']['VALUE'],
                                  editable: isEditing,
                                  controller: outletContactController),
                            ],
                          )),
                      isEditingShow(ref),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  saveEditInfo(image) async {
    try {
      setState(() {
        if (mounted) {
          isSave = true;
        }
      });
      final status = await ref.read(settingProvider).submitEditInfo(
          userData['NAME']['VALUE'],
          contactController.text,
          outletAddressController.text,
          outletContactController.text,
          image);
      AppDebug().printDebug(msg: 'status setting: $status');
      if (status['status'] == '1') {
        await fetchData();
        showCustomDialog(context, '', 'Successfully submitted', 'OK', () {});
        setState(() {
          if (mounted) {
            isSave = false;
          }
        });
      }
    } catch (e) {
      AppDebug().printDebug(msg: 'error in catch setting: $e');
      final errorMessage = errorMessageService.getErrorMessage();
      if (errorMessage != null && errorMessage.isNotEmpty) {
        showCustomDialog(context, '', errorMessage, 'OK', () {
          errorMessageService.clearErrorMessage();
        });
      }
    } finally {
      setState(() {
        if (mounted) {
          isSave = false;
        }
      });
    }
  }

  Widget isEditingShow(WidgetRef ref) {
    return !isEditing
        ? Column(
            children: [
              SizedBox(
                height: Adaptive.h(5),
              ),
              Text(
                'Version : $appVersion.$buildNumber',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFFEA1C24),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: Adaptive.h(4),
              ),
              CustomContainer(
                onPressed: () async {
                  showCustomDialog(context, 'Logout', 'Confirm logout?', "OK",
                      () async {
                    await AppLogout().logout(context, ref);
                  }, cancel: 'Cancel', onCancel: () {});
                },
                title: 'LOGOUT',
                color: Colors.white,
                backgroundColor: Color(0xFFED1C24),
                width: Adaptive.w(90),
                borderRadius: BorderRadius.circular(5),
              ),
              SizedBox(
                height: Adaptive.h(5),
              ),
            ],
          )
        : Container(
            child: SizedBox(
              height: Adaptive.h(5),
            ),
          );
  }

  Widget buildText(String title, String subject,
      {bool editable = false,
      TextEditingController? controller,
      bool isAddress = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Adaptive.w(8), vertical: Adaptive.h(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: Adaptive.w(32),
            child: editable
                ? TextField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFED1C24)),
                      ),
                    ),
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.phone,
                    showCursor: true,
                    cursorColor: Color(0xFFED1C24),
                    controller: controller,
                    textAlign: TextAlign.end,
                    maxLines: null,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                : Text(
                    subject,
                    textAlign: TextAlign.end,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildHorizontalLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1.0),
        height: 1.0,
        color: Colors.grey,
      ),
    );
  }

  void profileActionDialog() async {
    var alert = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(left: 0.0, right: 0.0),
        width: Adaptive.px(350),
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                top: 18.0,
              ),
              margin: const EdgeInsets.only(top: 25.0, right: 20.0, left: 20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text("Choose Image",
                            style: TextStyleGlobal().dialogMainText),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Please select image to upload",
                              textAlign: TextAlign.center,
                              style: TextStyleGlobal().dialogSubsText),
                        ),
                      ],
                    ),
                  ) //
                      ),
                  Divider(color: Colors.grey[400], thickness: 1.0),
                  InkWell(
                    splashColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(Adaptive.sp(0),
                          Adaptive.sp(0), Adaptive.sp(0), Adaptive.sp(3)),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Gallery",
                        style: TextStyleGlobal().dialogMainText2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () async {
                      _pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                  Divider(color: Colors.grey[400], thickness: 1.0),
                  InkWell(
                    splashColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(Adaptive.sp(0),
                          Adaptive.sp(3), Adaptive.sp(0), Adaptive.sp(10)),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0)),
                      ),
                      child: Text(
                        "Camera",
                        style: TextStyleGlobal().dialogMainText2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () async {
                      _pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                  Separator().heightSeperator(10)
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return showDialog(
      context: context,
      builder: (_) => alert,
      useRootNavigator: false,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile!.readAsBytes();
        img.Image? originalImage =
            img.decodeImage(Uint8List.fromList(imageBytes));

        if (originalImage != null) {
          img.Image resizedImage =
              img.copyResize(originalImage, width: 800, height: 600);
          List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 85);
          _base64Image = base64Encode(compressedBytes);
        }

        if (_base64Image != null) {
          base64ImageString = 'data:image/jpeg;base64,$_base64Image';
          setProfilePicture();
        } else {
          AppDebug().printDebug(msg: "Error: Base64 image is null");
        }
      } else {
        AppDebug().printDebug(msg: 'No image selected');
      }
    } catch (e) {
      AppDebug().printDebug(msg: "Error picking image: $e");
      GlobalUtils.showFloatingMessage(context, 'Error picking image: $e');
    }
  }
}
