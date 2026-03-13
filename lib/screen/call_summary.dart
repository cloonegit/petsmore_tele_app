import 'package:petsmore_tele_app/config/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:petsmore_tele_app/global_function/app_back_button.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/global_function/show_custom_dialog.dart';
import 'package:petsmore_tele_app/main.dart';
import 'package:petsmore_tele_app/provider/bottom_nav_provider.dart';
import 'package:petsmore_tele_app/screen/call_details.dart';
import 'package:petsmore_tele_app/services/get_it.dart';
import 'package:petsmore_tele_app/widgets/appbar.dart';
import 'package:petsmore_tele_app/widgets/custom_campaign_filter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CallSummary extends ConsumerStatefulWidget {
  CallSummary({
    super.key,
  });

  @override
  ConsumerState<CallSummary> createState() => _CallSummaryState();
}

class _CallSummaryState extends ConsumerState<CallSummary>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  final AppDeviceBackBtn backBtnHandler = AppDeviceBackBtn();
  // final ConnectivityService _connectivityService =
  //     GetIt.I<ConnectivityService>();
  final errorMessageService = GetIt.instance<ErrorMessageService>();

  List tabList = [];
  List allList = [];
  List filteredList = [];
  List campaignList = [];
  bool isLoading = false;
  String resultCampaignFilter = '';
  bool erroMsgOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    AppDebug().printDebug(msg: 'app lifecycle:$state');
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.resumed) {
      fetchData();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> fetchData() async {
    errorMessageService.clearErrorMessage();
    AppDebug().printDebug(msg: 'init fetchdata call summary');
    Future.microtask(() async {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      try {
        await ref.read(callSummaryProvider).fetchCallSummary();
        tabList = await ref.read(callSummaryProvider).tabList;
        AppDebug().printDebug(msg: 'tabList in call summary page:$tabList');
        allList = await ref.read(callSummaryProvider).allList;
        AppDebug().printDebug(msg: 'allList in call summary page:$allList');

        _tabController = TabController(
          length: tabList.length,
          vsync: this,
          initialIndex: ref.read(initialTabIndexProvider),
        );

        if (_tabController != null) {
          _tabController!.addListener(() {
            if (_tabController!.indexIsChanging) {
              AppDebug().printDebug(
                  msg: 'Changing to tab index: ${_tabController!.index}');
              ref.read(initialTabIndexProvider.notifier).state =
                  _tabController!.index;
            }
          });
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

  Future<void> _refreshData() async {
    try {
      fetchData();
      AppDebug().printDebug(msg: 'Data Refresh Successful');
    } catch (e) {
      AppDebug().printDebug(msg: 'Error during data refresh: $e');
    }
  }

  void filteredByCampaign() {
    if (resultCampaignFilter == 'ALL' || resultCampaignFilter == '') {
      campaignList = allList;
    } else {
      // Filter campaigns based on the selected filter
      campaignList = allList.where((item) {
        return item['CAMPAIGN'] == resultCampaignFilter;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final initialTab = ref.watch(initialTabIndexProvider.notifier).state;
    final callSummary = ref.watch(callSummaryProvider);
    // allList = callSummary.getallList;
    resultCampaignFilter = callSummary.getcampaignFilter;

    filteredByCampaign();
    AppDebug().printDebug(
        msg: 'campaignList in call summary page(build):$campaignList');

    AppDebug().printDebug(msg: 'call summary built');
    // AppDebug().printDebug(msg: 'initialTab:$initialTab');
    AppDebug().printDebug(msg: 'tabList in build:$tabList');
    // ref.read(initialTabIndexProvider.notifier).state = initialTab;

    // if (mounted) {
    //   setState(() {
    //     _tabController?.dispose();
    //     _tabController = TabController(
    //         length: tabList.length, vsync: this, initialIndex: initialTab);
    //   });
    // }
    // ref.listen<int>(initialTabIndexProvider, (previous, next) {
    //   if (previous != next) {
    //     AppDebug().printDebug(
    //         msg: 'in ref listen initialTabIndexProvider:$previous,$next');

    //     if (mounted) {
    //       setState(() {
    //         _tabController?.dispose();
    //         _tabController = TabController(
    //             length: tabList.length, vsync: this, initialIndex: next);
    //       });
    //     }
    //   }
    // });

    return DefaultTabController(
      length: tabList.length,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          await backBtnHandler.popped(context);
        },
        child: Scaffold(
            appBar: Appbar(
              title: 'CALL SUMMARY',
            ),
            body: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              if (callSummary.isFetching == true ||
                  callSummary.tabList.isEmpty ||
                  isLoading == true) {
                return Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 5,
                    strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                );
              } else {
                return Column(
                  children: <Widget>[
                    Container(
                      // height: Adaptive.h(9),
                      color: Colors.white,
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: _tabController,
                        tabAlignment: TabAlignment.center,
                        isScrollable: true,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: AppColors.primary,
                        tabs: List.generate(tabList.length, (index) {
                          return Padding(
                            padding: tabList[index]['NAME'] == "ALL"
                                ? EdgeInsets.symmetric(
                                    horizontal: Adaptive.w(5))
                                : EdgeInsets.symmetric(
                                    horizontal: Adaptive.w(0)),
                            child: _buildTab(tabList[index]['NAME'], index),
                          );
                        }),
                      ),
                    ),
                    CustomCampaignFilter(context),
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: List.generate(
                            tabList.length, (index) => _buildPage(index)),
                      ),
                    ),
                  ],
                );
              }
            })),
      ),
    );
  }

  Widget _buildTab(String? tabName, index) {
    return Tab(
      height: Adaptive.h(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$tabName',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Adaptive.sp(16),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${tabList[index]['NUM']}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Adaptive.sp(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    String currentTabID = tabList[index]['ID'];

    // Filter the `allList` based on the current tab's ID
    List filteredList = campaignList.where((item) {
      if (currentTabID == "ALL") return true; // Show all for "ALL"
      return item['CALL_STATUS'] ==
          tabList[index]['NAME']; // Filter by status for each tab
    }).toList();
    // AppDebug().printDebug(msg: 'filteredList:$filteredList');
    if (filteredList.isEmpty) {
      return Center(
          child: Text(
        'No data available',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ));
    }
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppColors.primary,
      backgroundColor: Colors.white,
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, itemIndex) {
          var currentItem = filteredList[itemIndex];
          String currentID = filteredList[itemIndex]['ID'];

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(5), vertical: Adaptive.h(1)),
            child: GestureDetector(
              onTap: () {
                AppDebug().printDebug(msg: 'currentID:$currentID');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallDetails(
                      // onNavBarItemTapped: widget.onNavBarItemTapped,
                      cid: currentID,
                      onPop: () async {
                        await fetchData();
                        AppDebug()
                            .printDebug(msg: 'on pop callback call details');
                      },
                    ),
                  ),
                );
              },
              child: Container(
                width: Adaptive.w(50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(
                                // left: Adaptive.w(4), top: Adaptive.h(1)
                                left: Adaptive.w(4),
                                top: Adaptive.h(1),
                                right: Adaptive.w(15)),
                            child: Text(
                              currentItem['NAME'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: Adaptive.h(1), right: Adaptive.w(4)),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: Adaptive.w(4),
                          right: Adaptive.w(4),
                          bottom: Adaptive.h(1.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Adaptive.w(25),
                                child: Text(
                                  currentItem['CAMPAIGN'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                height: Adaptive.h(1),
                              ),
                              Text(
                                currentItem['HIDDENCONTACT'],
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 15),
                              ),
                            ],
                          ),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     const Text(
                          //       'Last Called',
                          //       style: TextStyle(
                          //         fontFamily: 'Poppins',
                          //         fontSize: 11,
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: Adaptive.h(1),
                          //     ),
                          //     Text(
                          //       currentItem['LAST_CALL_DATE'] ?? '-',
                          //       style: TextStyle(
                          //           fontFamily: 'Poppins', fontSize: 12),
                          //     ),
                          //   ],
                          // ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentTabID == "ALL"
                                    ? currentItem['CALL_STATUS'] ?? ''
                                    : '',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),
                              ),
                              SizedBox(
                                height: Adaptive.h(1),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '-',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(), // Push to middle
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
