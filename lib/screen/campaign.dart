import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/app_logout.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/provider/bottom_nav_provider.dart';
import 'package:nrs_tele_apps/screen/campaign_telemarketer.dart';
import 'package:nrs_tele_apps/screen/telemarketer.dart';
import 'package:nrs_tele_apps/services/get_it.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:nrs_tele_apps/widgets/appbar.dart';
import 'package:nrs_tele_apps/widgets/bottom_navigation_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Campaign extends ConsumerStatefulWidget {
  String outlet = '';
  Campaign({super.key, required this.outlet});

  @override
  ConsumerState<Campaign> createState() => _CampaignState();
}

class _CampaignState extends ConsumerState<Campaign> {
  final errorMessageService = GetIt.instance<ErrorMessageService>();

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool isLoading = false;
  List data = [];
  List filteredData = [];
  String campaignId = '';
  String userLogin = '';

  void initState() {
    super.initState();
    getUserLogin();
    fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getUserLogin() async {
    userLogin = await GetSharedPreferences().getUserPosition();
    AppDebug().printDebug(msg: 'userlogin campaign:$userLogin');
    if (userLogin.isEmpty || userLogin == "") {
      await AppLogout().logout(context, ref);
      showCustomDialog(
          context, '', 'userLogin not found, Please re-login.', 'OK', () {});
    }
  }

  // List<Map<String, dynamic>> data = [
  //   {'outlet': 'V Care', 'details': 'Private', 'share': 'No Share'},
  //   {'outlet': 'V Care', 'details': 'Private', 'share': 'No Share'},
  //   {'outlet': 'V Care', 'details': 'Private', 'share': 'No Share'},
  //   {'outlet': 'V Care', 'details': 'Private', 'share': 'No Share'},
  //   {'outlet': 'V Care', 'details': 'Private', 'share': 'No Share'},
  //   {'outlet': 'V Care', 'details': 'Private', 'share': 'No Share'},
  //   {'outlet': 'V Care', 'details': 'Private', 'share': 'No Share'},
  //   {'outlet': 'V Care', 'details': 'Private', 'share': 'No Share'},
  //   {'outlet': 'V Care', 'details': 'Private', 'share': 'No Share'},
  // ];

  fetchData() {
    Future.microtask(() async {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      try {
        await ref.read(telemarketingCampaignAssignProvider).fetchOutletList();
        data = ref.read(telemarketingCampaignAssignProvider).getOutletList;
        AppDebug().printDebug(msg: 'campaign:$data');
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

  void filterData(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredData = data.where((item) {
        if (item is Map) {
          return (item['campaign_name']?.toLowerCase().contains(searchQuery) ??
                  false) ||
              (item['setting_group']?.toLowerCase().contains(searchQuery) ??
                  false) ||
              (item['setting_share']?.toLowerCase().contains(searchQuery) ??
                  false);
        }
        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'CAMPAIGN'),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFED1C24)),
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
                        cursorColor: Color(0xFFED1C24),
                        controller: searchController,
                        onChanged: (value) {
                          filterData(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          suffixIcon: searchController.text.trim().isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() {
                                      searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    Expanded(child: _buildPage())
                  ],
                ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: ref.read(bottomNavNotifierProvider).index,
        onTap: (index) {
          AppDebug().printDebug(msg: 'index campaign:$index');
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

  Widget _buildPage() {
    if (searchController.text.isEmpty) filteredData = data;

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: Color(0xFFED1C24),
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
                    builder: (context) => CampaignTelemarketer(
                      campaignName: currentItem['campaign_name'],
                      campaignId: currentItem['id'],
                      outlet: widget.outlet,
                    ),
                  ),
                );
              },
              child: IntrinsicHeight(
                child: Container(
                  // height: Adaptive.h(11),
                  width: Adaptive.w(50),
                  decoration: BoxDecoration(
                    color: Color(0xFFED1C24),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: Adaptive.w(4),
                                top: Adaptive.h(1),
                              ),
                              child: Text(
                                currentItem['campaign_name'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                                  horizontal: Adaptive.w(4),
                                ),
                                child: Container(
                                  width: Adaptive.w(70),
                                  child: Text(
                                    currentItem['setting_group'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
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
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: Adaptive.w(4),
                                    left: Adaptive.w(4),
                                    bottom: Adaptive.h(1)),
                                child: Container(
                                  width: Adaptive.w(70),
                                  child: Text(
                                    currentItem['setting_share'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
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
