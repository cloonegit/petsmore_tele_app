import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nrs_tele_apps/global_function/app_back_button.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/app_logout.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/provider/bottom_nav_provider.dart';
import 'package:nrs_tele_apps/screen/converted_detail.dart';
import 'package:nrs_tele_apps/services/get_it.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:nrs_tele_apps/widgets/appbar.dart';
import 'package:nrs_tele_apps/widgets/bottom_navigation_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Converted2 extends ConsumerStatefulWidget {
  final String? outlet;

  Converted2({super.key, required this.outlet});

  @override
  ConsumerState<Converted2> createState() => _Converted2State();
}

class _Converted2State extends ConsumerState<Converted2>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  final AppDeviceBackBtn backBtnHandler = AppDeviceBackBtn();

  final errorMessageService = GetIt.instance<ErrorMessageService>();

  List tabList = ['CUSTOMER', 'APPROACHED'];
  List allList = [];
  List data = [];
  List custList = [];
  List approachedList = [];
  List filteredList = [];
  bool isLoading = false;
  String resultCampaignFilter = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserLogin();
    fetchData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      fetchData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
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
    AppDebug().printDebug(msg: 'in fetchData converted2');
    Future.microtask(() async {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      try {
        await ref.read(convertedProvider).fetchCustomerList(widget.outlet);
        await ref.read(convertedProvider).fetchApproachedList(widget.outlet);
        custList = ref.read(convertedProvider).getCustList;
        approachedList = ref.read(convertedProvider).getApproachedList;

        AppDebug().printDebug(msg: 'custList:$custList');
        AppDebug().printDebug(msg: 'approachedList:$approachedList');

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        final errorMessage = errorMessageService.getErrorMessage();
        if (errorMessage != null && errorMessage.isNotEmpty) {
          showCustomDialog(context, '', errorMessage, 'OK', () {
            errorMessageService.clearErrorMessage();
          });
        }
      }

      // try {
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
      // } catch (e) {
      // final errorMessage = errorMessageService.getErrorMessage();
      // if (errorMessage != null && errorMessage.isNotEmpty) {
      //   showCustomDialog(context, '', errorMessage, 'OK', () {
      //     errorMessageService.clearErrorMessage();
      //   });
      // }
      // }
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
    return DefaultTabController(
      length: tabList.length,
      child: PopScope(
        // canPop: false,
        // onPopInvoked: (didPop) async {
        //   await backBtnHandler.popped(context);
        // },
        child: Scaffold(
          appBar: Appbar(
            title: 'CONVERTED',
          ),
          body: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return isLoading == true
                ? Center(
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 5,
                      strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFED1C24)),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        // height: Adaptive.h(9),
                        color: Colors.white,
                        child: TabBar(
                          labelPadding: EdgeInsetsDirectional.symmetric(
                              horizontal: Adaptive.w(12)),
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          tabAlignment: TabAlignment.center,
                          isScrollable: true,
                          labelColor: const Color(0xFFED1C24),
                          unselectedLabelColor: Colors.black,
                          indicatorColor: const Color(0xFFED1C24),
                          tabs: List.generate(tabList.length, (index) {
                            return _buildTab(tabList[index], index);
                          }),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              _buildPage(),
                              _buildPage2(),
                            ]),
                      ),
                    ],
                  );
          }),
          bottomNavigationBar: BottomNavBar(
            currentIndex: ref.read(bottomNavNotifierProvider).index,
            onTap: (index) {
              ref.read(bottomNavNotifierProvider.notifier).setIndex(index);
            },
          ),
        ),
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
        ],
      ),
    );
  }

  Widget _buildPage() {
    custList = ref.watch(convertedProvider).getCustList;
    AppDebug().printDebug(msg: 'in _buildPage converted2:$custList');

    return custList.isEmpty
        ? Center(
            child: Text(
            'No data available',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ))
        : RefreshIndicator(
            onRefresh: _refreshData,
            color: Color(0xFFED1C24),
            backgroundColor: Colors.white,
            child: ListView.builder(
              itemCount: custList.length,
              itemBuilder: (context, itemIndex) {
                var currentItem = custList[itemIndex];

                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Adaptive.w(5), vertical: Adaptive.h(1)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConvertedDetail(
                            cid: currentItem['ID'] ?? '',
                            outlet: widget.outlet ?? '',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      // height: Adaptive.h(13),
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
                                      left: Adaptive.w(4), top: Adaptive.h(1)),
                                  child: Text(
                                    currentItem['NAME'] ?? '',
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
                                left: Adaptive.w(4), right: Adaptive.w(4)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Adaptive.h(1),
                                    ),
                                    Container(
                                      width: Adaptive.w(25),
                                      child: Text(
                                        currentItem['CONTACT'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Adaptive.h(1),
                                    ),
                                    Text(
                                      currentItem['DATE'] ?? '',
                                      style: TextStyle(
                                          fontFamily: 'Poppins', fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: Adaptive.h(1),
                                    ),
                                  ],
                                ),
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

  Widget _buildPage2() {
    approachedList = ref.watch(convertedProvider).getApproachedList;
    AppDebug().printDebug(msg: 'in _buildPage2 converted2:$approachedList');

    return approachedList.isEmpty
        ? Center(
            child: Text(
            'No data available',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ))
        : RefreshIndicator(
            onRefresh: _refreshData,
            color: Color(0xFFED1C24),
            backgroundColor: Colors.white,
            child: ListView.builder(
              itemCount: approachedList.length,
              itemBuilder: (context, itemIndex) {
                var currentItem = approachedList[itemIndex];
                String currentID = approachedList[itemIndex]['ID'];

                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Adaptive.w(5), vertical: Adaptive.h(1)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConvertedDetail(
                            outlet: widget.outlet ?? '',
                            cid: currentItem['ID'] ?? '',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.14,
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
                                    left: Adaptive.w(4),
                                    top: Adaptive.h(1),
                                  ),
                                  child: Text(
                                    currentItem['CODE'] ?? '',
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
                                left: Adaptive.w(4), right: Adaptive.w(4)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Adaptive.h(1),
                                    ),
                                    Container(
                                      width: Adaptive.w(25),
                                      child: Text(
                                        currentItem['NAME'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Adaptive.h(1),
                                    ),
                                    Text(
                                      currentItem['CONTACT'] ?? '',
                                      style: TextStyle(
                                          fontFamily: 'Poppins', fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: Adaptive.h(1),
                                    ),
                                    Text(
                                      currentItem['CONVERTED_BY'] ?? '',
                                      style: TextStyle(
                                          fontFamily: 'Poppins', fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: Adaptive.h(1),
                                    ),
                                  ],
                                ),
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
