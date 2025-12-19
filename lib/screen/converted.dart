import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nrs_tele_apps/global_function/app_back_button.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/screen/converted2.dart';
import 'package:nrs_tele_apps/screen/telemarketer.dart';
import 'package:nrs_tele_apps/services/get_it.dart';
import 'package:nrs_tele_apps/widgets/appbar.dart';
import 'package:nrs_tele_apps/widgets/custom_search_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Converted extends ConsumerStatefulWidget {
  const Converted({super.key});

  @override
  ConsumerState<Converted> createState() => _ConvertedState();
}

class _ConvertedState extends ConsumerState<Converted> {
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
    fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  fetchData() {
    Future.microtask(() async {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      try {
        await ref.read(convertedProvider).fetchOutletList();
        data = ref.read(convertedProvider).getOutletList;
        AppDebug().printDebug(msg: 'converted init:$data');
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

  // List<Map<String, dynamic>> data = [
  //   {
  //     'outlet': 'GS005',
  //     'details':
  //         'NO 103 & 105 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //     'count': '0/137',
  //   },
  //   {
  //     'outlet': 'GS006',
  //     'details':
  //         'NO 111 & 115 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //     'count': '0/137',
  //   },
  //   {
  //     'outlet': 'GS007',
  //     'details':
  //         'NO 123 & 125 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //     'count': '0/137',
  //   },
  //   {
  //     'outlet': 'GS008',
  //     'details':
  //         'NO 123 & 125 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //     'count': '0/137',
  //   },
  //   {
  //     'outlet': 'GS005',
  //     'details':
  //         'NO 103 & 105 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //     'count': '0/137',
  //   },
  //   {
  //     'outlet': 'GS006',
  //     'details':
  //         'NO 111 & 115 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //     'count': '0/137',
  //   },
  //   {
  //     'outlet': 'GS007',
  //     'details':
  //         'NO 123 & 125 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //     'count': '0/137',
  //   },
  //   {
  //     'outlet': 'GS008',
  //     'details':
  //         'NO 123 & 125 JALAN PELABUR B, SEKSYEN 23, 40300, SHAH ALAM SELANGOR',
  //     'count': '0/137',
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
        appBar: Appbar(title: 'CONVERTED'),
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
                      // CustomSearchBar(
                      //   context,
                      //   searchController: searchController,
                      //   data: data,
                      //   searchQuery: searchQuery,
                      //   item: ['CODE', 'ADDRESS', 'STATUS'],
                      // ),
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
      ),
    );
  }

  void filterData(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredData = data.where((item) {
        if (item is Map) {
          return (item['CODE']?.toLowerCase().contains(searchQuery) ?? false) ||
              (item['ADDRESS']?.toLowerCase().contains(searchQuery) ?? false) ||
              (item['STATUS']?.toLowerCase().contains(searchQuery) ?? false);
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

  Widget _buildPage() {
    if (searchController.text.isEmpty) filteredData = data;

    // searchQuery = searchController.text.trim();

    // data = searchQuery.isNotEmpty
    //     ? ref.watch(searchProvider).getFilteredData
    //     : ref.watch(convertedProvider).getOutletList;
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: Color(0xFFED1C24),
      backgroundColor: Colors.white,
      child: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, itemIndex) {
          var currentItem = filteredData[itemIndex];

          return filteredData.isEmpty
              ? Center(
                  child: Text(
                  'No data available',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ))
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Adaptive.w(5), vertical: Adaptive.h(1)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Converted2(
                            outlet: currentItem['CODE'],
                          ),
                        ),
                      );
                    },
                    child: IntrinsicHeight(
                      child: Container(
                        // height: Adaptive.h(18),
                        width: Adaptive.w(50),
                        decoration: BoxDecoration(
                          color: Color(0xFFED1C24),
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
                                        vertical: Adaptive.h(1)),
                                    child: Container(
                                      width: Adaptive.w(50),
                                      child: Text(
                                        currentItem['ADDRESS'] ?? '',
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: Adaptive.h(0),
                                    right: Adaptive.w(1),
                                  ),
                                  child: Text(
                                    currentItem['STATUS'] ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
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
