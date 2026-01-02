import 'package:nrs_tele_apps/config/global.dart';
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
import 'package:nrs_tele_apps/screen/campaign.dart';
import 'package:nrs_tele_apps/services/get_it.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:nrs_tele_apps/widgets/appbar.dart';
import 'package:nrs_tele_apps/widgets/bottom_navigation_bar.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class Telemarketer extends ConsumerStatefulWidget {
  String outlet = '';
  Telemarketer({super.key, required this.outlet});

  @override
  ConsumerState<Telemarketer> createState() => _TelemarketerState();
}

class _TelemarketerState extends ConsumerState<Telemarketer> {
  final errorMessageService = GetIt.instance<ErrorMessageService>();

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List data = [];
  List filteredData = [];
  bool isLoading = true;
  String assign = '';
  String userLogin = '';

  void initState() {
    super.initState();
    getUserLogin();
    fetchData();
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

  fetchData() {
    Future.microtask(() async {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      try {
        await ref
            .read(telemarketingAssignProvider)
            .fetchTelemarketerList(widget.outlet);
        data = ref.read(telemarketingAssignProvider).getTelemarketerList;
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
  //     'name': 'cloone1',
  //     'details':
  //         '(HQ) TELEMARKETER A\nCommencement of PW Testing, P1 basic (Online) convert to P1 classic Testing, P1 Expiry Reminder Test, 202409 - EDO, testing, TELE MARKETING',
  //     'isAssigned': true,
  //   },
  //   {
  //     'name': 'cloone2',
  //     'details':
  //         '(SBU) TM C\n202409 - IPHONE 16 PRE-ORDER, Commencement of PW Testing, 202409 - AEON PRE-APPROVED REMINDER, P1 basic (Online) convert to P1 classic Testing, P1 Expiry Reminder Test, 202409 - Lapsed P1, testing, TELE MARKETING',
  //     'isAssigned': false,
  //   },
  //   {
  //     'name': 'SH13019',
  //     'details':
  //         '(SBU) MOHAMAD HAFIZI BIN ZAKARIA\n202409 - IPHONE 16 PRE-ORDER, Commencement of PW Testing, 202409 - AEON PRE-APPROVED REMINDER, P1 basic (Online) convert to P1 classic Testing, testing, TELE MARKETING',
  //     'isAssigned': true,
  //   },
  // ];

  void filterData(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredData = data.where((item) {
        if (item is Map) {
          return (item['CODE']?.toLowerCase().contains(searchQuery) ?? false) ||
              (item['CAMPAIGN']?.toLowerCase().contains(searchQuery) ??
                  false) ||
              (item['NAME']?.toLowerCase().contains(searchQuery) ?? false);
        }
        return false;
      }).toList();
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

  @override
  Widget build(BuildContext context) {
    if (searchController.text.isEmpty) filteredData = data;

    return Scaffold(
      appBar: Appbar(
        title: widget.outlet,
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Campaign(
                outlet: widget.outlet,
              ),
            ),
          );
        },
      ),
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
                    // CustomSearchBar(
                    //   context,
                    //   searchController: searchController,
                    //   searchQuery: searchQuery,
                    //   data: data,
                    //   filteredData: filteredData,
                    // ),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Toggle to assign telemarketer',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshData,
                        color: AppColors.primary,
                        backgroundColor: Colors.white,
                        child: ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              elevation: 4,
                              margin: EdgeInsets.all(8),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      filteredData[index]['CODE'],
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Switch(
                                      activeTrackColor: Colors.green,
                                      value: filteredData[index]
                                          ['TELEMARKETER'],
                                      onChanged: (val) {
                                        assignToggle(val, index);
                                      },
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Adaptive.h(1),
                                    ),
                                    Text(
                                      filteredData[index]['NAME'],
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: Adaptive.h(1),
                                    ),
                                    Text(
                                      data[index]['CAMPAIGN'],
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: ref.read(bottomNavNotifierProvider).index,
        onTap: (index) {
          ref.read(bottomNavNotifierProvider.notifier).setIndex(index);
        },
      ),
    );
  }

  assignToggle(bool val, int index) {
    String action = val ? 'assign' : 'unassign';

    showCustomDialog(
        context,
        '',
        'Are you sure to $action ${filteredData[index]['CODE']} as Telemarketer? ',
        'OK', () {
      setState(() {
        filteredData[index]['TELEMARKETER'] = val;
        assign = '${filteredData[index]['CODE']}=$val';
      });
      // AppDebug().printDebug(msg: 'assignnn:$assign///$val');

      ref
          .read(telemarketingAssignProvider)
          .setTelemarketerAssign(assign, widget.outlet);
    }, cancel: 'Cancel');
  }
}
