import 'package:flutter/foundation.dart';
import 'package:petsmore_tele_app/api/login_api.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/services/get_it.dart';
import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';

class LoginProvider extends ChangeNotifier {
  bool isError = false;
  bool get getIsError => isError;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  String? _failure;
  String? get failure => _failure;

  String userPosition = '';
  String get getUserPosition => userPosition;

  Map responseData = {};
  Map get getResponseData => responseData;

  void _setFailure(failure) {
    _failure = failure;
    AppDebug().printDebug(msg: 'login provider failure: $failure');
    notifyListeners();
  }

  Future<void> clearData() async {
    isError = false;
    _isFetching = false;
    _failure = null;
    responseData.clear();
    userPosition = '';
    // notifyListeners();
  }

  void setUserLogin(getUserPosition) {
    userPosition = getUserPosition;
    AppDebug()
        .printDebug(msg: 'login provider getUserPosition: $getUserPosition');
    notifyListeners();
  }

  Future fetchLogin({String? username, String? password}) async {
    _setFailure(null);
    _isFetching = true;
    notifyListeners();
    var res;
    try {
      res = await LoginAPI().login(username, password);
      responseData = res;
      AppDebug().printDebug(msg: 'login provider res: $res');
      if (res['status'] == '1') {
        userPosition = res['LIST']['POSITION'];
        AppDebug().printDebug(msg: 'login provider res: $userPosition');
        GetSharedPreferences().setUserInfo(
          userID: res['LIST']['ID'],
          userCode: res['LIST']['CODE'],
          userName: res['LIST']['NAME'],
          userPosition: res['LIST']['POSITION'],
          userHQStaff: res['LIST']['HQSTAFF'],
        );
        var id = await GetSharedPreferences().getUserID();
        var code = await GetSharedPreferences().getuserCode();
        var name = await GetSharedPreferences().getUserName();
        var position = await GetSharedPreferences().getUserPosition();
        var hqstaff = await GetSharedPreferences().getUserHQStaff();
        setUserLogin(position);
        getIt<UserLoginService>().setUserLogin(res['LIST']['POSITION']);

        // userPosition = position;
        AppDebug().printDebug(msg: 'userlogin:$userPosition..$getUserPosition');

        AppDebug()
            .printDebug(msg: 'user data: $id,$code,$name,$position,$hqstaff');
        notifyListeners();
      } else {
        AppDebug().printDebug(msg: 'login provider status 0: $res');
        return res;
      }
    } catch (f) {
      AppDebug().printDebug(msg: 'login provider f: ${f}');

      _setFailure(f);
      return f;
    }

    _setFailure(null);
    _isFetching = false;
    notifyListeners();
    return res;
  }
}
