import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/provider/bottom_nav_provider.dart';
import 'package:nrs_tele_apps/screen/call_summary.dart';
import 'package:nrs_tele_apps/screen/converted.dart';
import 'package:nrs_tele_apps/screen/home.dart';
import 'package:nrs_tele_apps/screen/login.dart';
import 'package:nrs_tele_apps/screen/outlet.dart';
import 'package:nrs_tele_apps/screen/settings.dart';
import 'package:nrs_tele_apps/services/get_it.dart';
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap, super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  final userLoginService = GetIt.instance<UserLoginService>();

  void initState() {
    super.initState();
    userLogin = userLoginService.getUserLogin() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    userLogin = userLoginService.getUserLogin() ?? '';
    AppDebug().printDebug(msg: 'userlogin bottom nav bar 2:$userLogin');

    return userLogin == ""
        ? Login()
        : userLogin == 'STAFF'
            ? staffUser()
            : TMUser();
  }

  Widget TMUser() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      child: NavigationBar(
        height: Adaptive.h(10),
        indicatorColor: Colors.transparent,
        selectedIndex: widget.currentIndex,
        onDestinationSelected: widget.onTap,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/icons/footer-home-default-500px.png'),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_rounded,
            ),
            label: 'Telemarketer',
          ),
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/icons/footer-call-summary-default-500px.png'),
            ),
            label: 'Call Summary',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.sync,
            ),
            label: 'Converted',
          ),
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/icons/footer-setting-default-500px.png'),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget staffUser() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      child: NavigationBar(
        height: Adaptive.h(10),
        indicatorColor: Colors.transparent,
        selectedIndex: widget.currentIndex,
        onDestinationSelected: widget.onTap,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/icons/footer-home-default-500px.png'),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/icons/footer-call-summary-default-500px.png'),
            ),
            label: 'Call Summary',
          ),
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/icons/footer-setting-default-500px.png'),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class BottomNavBarWrapper extends ConsumerStatefulWidget {
  final Widget child;

  BottomNavBarWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState createState() => _BottomNavBarWrapperState();
}

class _BottomNavBarWrapperState extends ConsumerState<BottomNavBarWrapper> {
  final PageController _pageController = PageController();
  final userLoginService = GetIt.instance<UserLoginService>();

  @override
  void initState() {
    super.initState();
    userLogin = userLoginService.getUserLogin() ?? '';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavBarItemTapped(index) {
    ref.read(bottomNavNotifierProvider.notifier).setIndex(index);
    if (Navigator.canPop(context)) {
      AppDebug().printDebug(msg: '_onNavBarItemTapped:$index');
      Navigator.popUntil(context, (route) => route.isFirst);
      _pageController.jumpToPage(index);
    } else {
      _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(bottomNavNotifierProvider).index;
    AppDebug().printDebug(msg: 'getIndexFromProvider:$selectedIndex');

    ref.listen<BottomNavState>(bottomNavNotifierProvider, (previous, next) {
      if (previous?.index != next.index) {
        AppDebug()
            .printDebug(msg: 'in ref listen:${previous?.index},${next.index}');
        // _pageController.jumpToPage(next.index);
        _onNavBarItemTapped(next.index);
      }
    });

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        // onPageChanged: (index) {
        //   if (selectedIndex != index) {
        //     ref.read(bottomNavIndexProvider.notifier).state = index;
        //   }
        // },
        children: _buildNavBarChildren(),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          AppDebug().printDebug(msg: 'onTapIndex:$index');
          AppDebug().printDebug(msg: 'onTapselectedIndex:$selectedIndex');
          ref.read(bottomNavNotifierProvider.notifier).setIndex(index);
          int indextab = ref.read(initialTabIndexProvider);
          AppDebug().printDebug(msg: 'index tab:$indextab');

          if (userLogin == 'STAFF') {
            if (index == 1) {
              ref.read(initialTabIndexProvider.notifier).state = 0;
              ref.read(callSummaryProvider.notifier).setCampaignFilter('ALL');
            }
          } else if (userLogin == 'TM') {
            if (index == 2) {
              ref.read(initialTabIndexProvider.notifier).state = 0;
              ref.read(callSummaryProvider.notifier).setCampaignFilter('ALL');
            }
          }
        },
      ),
    );
  }

  List<Widget> _buildNavBarChildren() {
    if (userLogin == 'TM') {
      return [
        Home(),
        Outlet(),
        CallSummary(),
        Converted(),
        Setting(),
      ];
    } else if (userLogin == 'STAFF') {
      return [
        Home(),
        CallSummary(),
        Setting(),
      ];
    } else {
      return [];
    }
  }
}
