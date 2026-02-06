import 'package:petsmore_tele_app/config/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:petsmore_tele_app/global_function/app_back_button.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/global_function/app_logout.dart';
import 'package:petsmore_tele_app/global_function/show_custom_dialog.dart';
import 'package:petsmore_tele_app/main.dart';
import 'package:petsmore_tele_app/provider/bottom_nav_provider.dart';
import 'package:petsmore_tele_app/services/get_it.dart';
import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';
import 'package:petsmore_tele_app/widgets/appbar.dart';
import 'package:petsmore_tele_app/widgets/bottom_navigation_bar.dart';
import 'package:petsmore_tele_app/widgets/custom_tiles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Home extends ConsumerStatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with WidgetsBindingObserver {
  String userLogin = '';
  final AppDeviceBackBtn backBtnHandler = AppDeviceBackBtn();

  final errorMessageService = GetIt.instance<ErrorMessageService>();
  bool isLoading = false;
  @override
  void initState() {
    AppDebug().printDebug(msg: 'home initstate');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserLogin();
    fetchData();
    // checkConnectivity();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      getUserLogin();
      fetchData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppDebug().printDebug(msg: 'dispose home');
    super.dispose();
  }

  Future<void> _refreshData() async {
    try {
      fetchData();
      AppDebug().printDebug(msg: 'Data Refresh Successful');
    } catch (e) {
      AppDebug().printDebug(msg: 'Error during data refresh: $e');
    }
  }

  fetchData() {
    AppDebug().printDebug(msg: 'init homepage');
    Future.microtask(() async {
      try {
        await ref.read(homeProvider).fetchHome(context, ref);
      } catch (e) {
        final errorMessage = errorMessageService.getErrorMessage();
        if (errorMessage != null && errorMessage.isNotEmpty) {
          showCustomDialog(context, '', errorMessage, 'OK', () {
            errorMessageService.clearErrorMessage();
          });
        }
      } finally {}
    });
  }

  navigateTiles(indexTab) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (userLogin == 'STAFF') {
        ref.read(bottomNavNotifierProvider.notifier).setIndex(1);
      } else {
        ref.read(bottomNavNotifierProvider.notifier).setIndex(2);
      }
      ref
          .read(bottomNavNotifierProvider.notifier)
          .setBottomTabName('CallSummary');
      ref.read(initialTabIndexProvider.notifier).state = indexTab;
      ref.read(callSummaryProvider.notifier).setCampaignFilter('ALL');
    });
  }

  navigateCampaign(String campaignFilter) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (userLogin == 'STAFF') {
        ref.read(bottomNavNotifierProvider.notifier).setIndex(1);
      } else {
        ref.read(bottomNavNotifierProvider.notifier).setIndex(2);
      }

      ref.read(initialTabIndexProvider.notifier).state = 0;
      ref.read(callSummaryProvider.notifier).setCampaignFilter(campaignFilter);
    });
  }

  Future<void> getUserLogin() async {
    userLogin = await GetSharedPreferences().getUserPosition();
    AppDebug().printDebug(msg: 'userlogin Home:$userLogin');
    if (userLogin.isEmpty || userLogin == "") {
      await AppLogout().logout(context, ref);
      showCustomDialog(
          context, '', 'userLogin not found, Please re-login.', 'OK', () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await backBtnHandler.popped(context);
      },
      child: Scaffold(
        appBar: Appbar(
          title: 'HOME',
        ),
        body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final home = ref.watch(homeProvider);

            if (home.isFetching == true) {
              return Center(
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 5,
                  strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            } else {
              return RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: Colors.white,
                onRefresh: _refreshData,
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: Adaptive.w(5), top: Adaptive.w(5)),
                          child: Row(
                            children: [
                              Text(
                                '${home.listTitle}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Adaptive.w(5),
                            top: Adaptive.h(2),
                            right: Adaptive.w(3.5),
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(), // Disable scrolling for the GridView
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of items per row
                              mainAxisSpacing:
                                  Adaptive.h(2), // Spacing between rows
                              crossAxisSpacing:
                                  Adaptive.w(3), // Spacing between columns
                            ),
                            itemCount: home.callStatusList.length,
                            itemBuilder: (context, index) {
                              final item = home.callStatusList[index];
                              return CustomTiles(
                                onPressed: () {
                                  navigateTiles(
                                      index + 1); // Navigate to the item
                                },
                                title: item['NUM']
                                    .toString(), // Get the number for the item
                                subtitle:
                                    item['NAME'], // Get the name for the item
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: Adaptive.w(5), top: Adaptive.h(5)),
                          child: Row(
                            children: [
                              Text(
                                '${home.campaignTitle}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: Adaptive.w(5),
                              top: Adaptive.h(2),
                              right: Adaptive.w(3.5),
                              bottom: Adaptive.h(2)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: home.campaignList.length,
                            itemBuilder: (context, index) {
                              final item = home.campaignList[index];

                              return Padding(
                                padding: EdgeInsets.only(bottom: Adaptive.h(2)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomTiles(
                                      height: Adaptive.h(11),
                                      width: Adaptive.w(90),
                                      onPressed: () {
                                        navigateCampaign(item['NAME']);
                                      },
                                      title2: item['NUM'].toString(),
                                      subtitle2: item['NAME'],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget generateTileGrid(int itemCount, Color tileColor) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 tiles per row
      ),
      itemCount: itemCount, // Total number of tiles
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(8.0),
          color: tileColor,
          child: Center(
            child: Text(
              'Tile ${index + 1}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
