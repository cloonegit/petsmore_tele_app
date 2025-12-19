import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/provider/call_summary_detail_provider.dart';
import 'package:nrs_tele_apps/provider/call_summary_provider.dart';
import 'package:nrs_tele_apps/provider/converted_provider.dart';
import 'package:nrs_tele_apps/provider/get_campaign_provider.dart';
import 'package:nrs_tele_apps/provider/home_provider.dart';
import 'package:nrs_tele_apps/provider/login_provider.dart';
import 'package:nrs_tele_apps/provider/search_provider.dart';
import 'package:nrs_tele_apps/provider/telemarketer_campaign_assign_provider.dart';
import 'package:nrs_tele_apps/provider/telemarketing_assign_provider.dart';
import 'package:nrs_tele_apps/provider/setting_provider.dart';
import 'package:nrs_tele_apps/screen/call_details.dart';
import 'package:nrs_tele_apps/screen/call_summary.dart';
import 'package:nrs_tele_apps/screen/campaign.dart';
import 'package:nrs_tele_apps/screen/campaign_telemarketer.dart';
import 'package:nrs_tele_apps/screen/converted.dart';
import 'package:nrs_tele_apps/screen/converted2.dart';
import 'package:nrs_tele_apps/screen/converted_detail.dart';
import 'package:nrs_tele_apps/screen/home.dart';
import 'package:nrs_tele_apps/screen/load.dart';
import 'package:nrs_tele_apps/screen/login.dart';
import 'package:nrs_tele_apps/screen/notification.dart';
import 'package:nrs_tele_apps/screen/outlet.dart';
import 'package:nrs_tele_apps/screen/settings.dart';
import 'package:nrs_tele_apps/screen/splash.dart';
import 'package:nrs_tele_apps/screen/telemarketer.dart';
import 'package:nrs_tele_apps/services/get_it.dart' as getItSetup;
import 'package:nrs_tele_apps/services/get_sharedpreferences.dart';
import 'package:nrs_tele_apps/widgets/bottom_navigation_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// class MyAppWithInitialRoute extends StatefulWidget {
//   final String initialRoute;

//   MyAppWithInitialRoute({super.key, required this.initialRoute});

//   @override
//   _MyAppWithInitialRouteState createState() => _MyAppWithInitialRouteState();
// }

String userLogin = '';
bool isLoggedIn = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final loginProvider = ChangeNotifierProvider((ref) => LoginProvider());
final homeProvider = ChangeNotifierProvider((ref) => HomeProvider());
final callSummaryProvider =
    ChangeNotifierProvider((ref) => CallSummaryProvider());
final callSummaryDetailProvider =
    ChangeNotifierProvider((ref) => CallSummaryDetailProvider());
final campaignProvider = ChangeNotifierProvider((ref) => GetCampaignProvider());
final telemarketingAssignProvider =
    ChangeNotifierProvider((ref) => TelemarketingAssignProvider());
final telemarketingCampaignAssignProvider =
    ChangeNotifierProvider((ref) => TelemarketingCampaignAssignProvider());
final settingProvider = ChangeNotifierProvider((ref) => SettingProvider());
final convertedProvider = ChangeNotifierProvider((ref) => ConvertedProvider());
final searchProvider = ChangeNotifierProvider((ref) => SearchProvider());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkLoginStatus();
  checkPlatform();
  getItSetup.setup();
  runApp(ProviderScope(
    child: MyAppWithInitialRoute(
      initialRoute: '/load',
      // initialRoute: initialRoute,
    ),
  ));
}

Future<bool> checkLoginStatus() async {
  isLoggedIn = await GetSharedPreferences().getLastLoginStatus();
  AppDebug().printDebug(msg: 'isLoggedIn in main:$isLoggedIn');
  return isLoggedIn;
}

void checkPlatform() {
  if (Platform.isAndroid) {
    AppDebug().printDebug(msg: "Running on Android");
    GetSharedPreferences().setPlatform('android');
  } else if (Platform.isIOS) {
    AppDebug().printDebug(msg: "Running on iOS");
    GetSharedPreferences().setPlatform('ios');
  } else {
    AppDebug().printDebug(msg: "Running on an unsupported platform");
    GetSharedPreferences().setPlatform('');
  }
}

Future<void> getUserLogin() async {
  // userLogin = await ref.read(loginProvider).getUserPosition ?? '';
  userLogin = await GetSharedPreferences().getUserPosition();
  AppDebug().printDebug(msg: 'userlogin in main:$userLogin');
}

class MyAppWithInitialRoute extends StatelessWidget {
  final String initialRoute;

  const MyAppWithInitialRoute({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Telemarketing App',
        theme: ThemeData(
          // primarySwatch: Color(0xFFED1C24),
          scaffoldBackgroundColor: Colors.grey[50],
          // scaffoldBackgroundColor: Colors.black,
          primaryColor: Color(0xFFED1C24),
          useMaterial3: true,
          checkboxTheme: CheckboxThemeData(
            fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Color(0xFFED1C24);
              }
              return Colors.transparent;
            }),
            checkColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return Colors.transparent;
            }),
          ),
          navigationBarTheme: NavigationBarThemeData(
            indicatorColor: Color(0xFFED1C24),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFED1C24),
                    fontWeight: FontWeight.w400);
              }
              return const TextStyle(fontSize: 10, color: Colors.grey);
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(
                  color: Color(0xFFED1C24),
                  size: 24,
                );
              }
              return const IconThemeData(
                color: Colors.grey,
                size: 24,
              );
            }),
            backgroundColor: Colors.white,
          ),
        ),
        initialRoute: initialRoute,
        routes: {
          '/login': (context) => const Login(),
          '/splash': (context) => const Splash(),
          // '/no-internet': (context) => const NoInternetScreen(
          //       previousRoute: '',
          //     ),
          '/load': (context) => const Load(),
          '/home': (context) => BottomNavBarWrapper(child: Home()),
          '/telemarketer': (context) => BottomNavBarWrapper(
                  child: Telemarketer(
                outlet: '',
              )),
          '/outlet': (context) => BottomNavBarWrapper(child: Outlet()),
          '/campaign': (context) => BottomNavBarWrapper(
                  child: Campaign(
                outlet: '',
              )),
          '/campaign-telemarketer': (context) => BottomNavBarWrapper(
                  child: CampaignTelemarketer(
                campaignId: '',
                outlet: '',
                campaignName: '',
              )),
          '/converted': (context) => BottomNavBarWrapper(child: Converted()),
          '/converted2': (context) => BottomNavBarWrapper(
                  child: Converted2(
                outlet: '',
              )),
          '/converted-details': (context) => ConvertedDetail(
                cid: '',
                outlet: '',
              ),
          '/call-summary': (context) =>
              BottomNavBarWrapper(child: CallSummary()),
          '/call-details': (context) => CallDetails(
                cid: '',
              ),
          '/notification': (context) => const Notifications(),
          '/settings': (context) => BottomNavBarWrapper(child: Setting()),
        },
      );
    });
  }
}
