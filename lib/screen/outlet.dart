import 'package:nrs_tele_apps/config/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nrs_tele_apps/global_function/app_back_button.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/app_logout.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/screen/telemarketer.dart';
import 'package:nrs_tele_apps/services/get_it.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:nrs_tele_apps/widgets/appbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Outlet extends ConsumerStatefulWidget {
  const Outlet({
    super.key,
  });

  @override
  ConsumerState<Outlet> createState() => _OutletState();
}

class _OutletState extends ConsumerState<Outlet> {
  final errorMessageService = GetIt.instance<ErrorMessageService>();

  TextEditingController searchController = TextEditingController();
  final AppDeviceBackBtn backBtnHandler = AppDeviceBackBtn();

  String searchQuery = '';
  List data = [];
  List filteredData = [];
  bool isLoading = false;
  String userLogin = '';

  void initState() {
    super.initState();
    getUserLogin();
    fetchData();
  }

  fetchData() {
    Future.microtask(() async {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      try {
        await ref.read(telemarketingAssignProvider).fetchOutletList();
        data = ref.read(telemarketingAssignProvider).getOutletList;
        AppDebug().printDebug(msg: 'ressss:$data');
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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // List<Map<String, dynamic>> data = [
  //   {
  //     'outlet': 'GS005',
  //     'details':
  //         'NO 103 & 105 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS006',
  //     'details':
  //         'NO 111 & 115 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS007',
  //     'details':
  //         'NO 123 & 125 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS008',
  //     'details':
  //         'NO 123 & 125 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS005',
  //     'details':
  //         'NO 103 & 105 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS006',
  //     'details':
  //         'NO 111 & 115 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS007',
  //     'details':
  //         'NO 123 & 125 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS008',
  //     'details':
  //         'NO 123 & 125 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS005',
  //     'details':
  //         'NO 103 & 105 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS006',
  //     'details':
  //         'NO 111 & 115 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS007',
  //     'details':
  //         'NO 123 & 125 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  //   {
  //     'outlet': 'GS008',
  //     'details':
  //         'NO 123 & 125 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await backBtnHandler.popped(context);
      },
      child: Scaffold(
        appBar: Appbar(title: 'OUTLET'),
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 5,
                  strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : data.isEmpty
                ? Center(
                    child: Text(
                    'No data available',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ))
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: Adaptive.w(4),
                            right: Adaptive.w(4),
                            top: Adaptive.h(2),
                            bottom: Adaptive.h(2)),
                        child: TextField(
                          enableInteractiveSelection: false,
                          cursorColor: AppColors.primary,
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                              hintText: 'Search',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              suffixIcon:
                                  searchController.text.trim().isNotEmpty
                                      ? IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            searchController.clear();
                                            setState(() {
                                              searchQuery = '';
                                            });
                                          },
                                        )
                                      : null),
                        ),
                      ),
                      Expanded(child: _buildPage())
                    ],
                  ),
      ),
    );
  }

  Future<void> getUserLogin() async {
    // userLogin = await ref.read(loginProvider).getUserPosition ?? '';
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
      // fetchData();
      AppDebug().printDebug(msg: 'Data Refresh Successful');
    } catch (e) {
      AppDebug().printDebug(msg: 'Error during data refresh: $e');
    }
  }

  Widget _buildPage() {
    filteredData = data.where((item) {
      if (item is Map) {
        return (item['CODE']?.toLowerCase().contains(searchQuery) ?? false) ||
            (item['ADDRESS']?.toLowerCase().contains(searchQuery) ?? false);
      }
      return false;
    }).toList();

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppColors.primary,
      backgroundColor: Colors.white,
      child: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, itemIndex) {
          var currentItem = filteredData[itemIndex];

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(5), vertical: Adaptive.h(1)),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Telemarketer(
                      outlet: currentItem['CODE'],
                    ),
                  ),
                );
              },
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Adaptive.h(1)),
                  width: Adaptive.w(50),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: Adaptive.w(2),
                              top: Adaptive.h(1),
                            ),
                            child: Text(
                              currentItem['CODE'] ?? '',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Adaptive.w(2),
                              ),
                              child: Container(
                                width: Adaptive.w(70),
                                child: Text(
                                  currentItem['ADDRESS'] ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: Adaptive.h(0),
                              right: Adaptive.w(3),
                            ),
                            child: Icon(
                              color: Colors.white,
                              Icons.arrow_forward_ios,
                              size: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
